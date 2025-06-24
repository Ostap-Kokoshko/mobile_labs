#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
#include <ArduinoJson.h>
#include <EEPROM.h>
#include "secrets.h"


// -----------------------------
// MQTT topics
const char* temp_topic = "home/temperature";
const char* hum_topic = "home/humidity";
const char* request_topic = "device/request";
const char* response_topic = "device/response";
const char* serial_topic = "device/set_serial";

// -----------------------------
// DHT датчик
#define DHTPIN 2
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// -----------------------------
WiFiClientSecure espClient;
PubSubClient client(espClient);

// ---------- Callback ----------

String serialNumber = "";

void saveSerialToEEPROM(const String& serial) {
  EEPROM.begin(64);
  for (int i = 0; i < serial.length(); i++) {
    EEPROM.write(i, serial[i]);
  }
  EEPROM.write(serial.length(), '\0'); // маркер кінця рядка
  EEPROM.commit();
  EEPROM.end();
}

String readSerialFromEEPROM() {
  EEPROM.begin(64);
  char buffer[32];
  for (int i = 0; i < 32; i++) {
    buffer[i] = EEPROM.read(i);
    if (buffer[i] == '\0') break;
  }
  EEPROM.end();
  return String(buffer);
}

void callback(char* topic, byte* payload, unsigned int length) {
  String msg;
  for (unsigned int i = 0; i < length; i++) {
    msg += (char)payload[i];
  }

  Serial.print("MQTT повідомлення [");
  Serial.print(topic);
  Serial.print("]: ");
  Serial.println(msg);

  DynamicJsonDocument doc(256);
  DeserializationError err = deserializeJson(doc, msg);

  if (err) {
    Serial.println("Помилка парсингу JSON");
    return;
  }

  if (String(topic) == request_topic) {
    String user = doc["user"];
    String pass = doc["pass"];

    DynamicJsonDocument response(128);
    if (user == mqtt_user && pass == mqtt_pass) {
      response["status"] = "success";
    } else {
      response["status"] = "fail";
    }

    String resStr;
    serializeJson(response, resStr);
    client.publish(response_topic, resStr.c_str());
    Serial.println("Відповідь на креденшинали: " + resStr);
  }

  else if (String(topic) == serial_topic) {
    String serial = doc["serial"];
    Serial.println("Отримано серійник: " + serial);
    serialNumber = serial;
    saveSerialToEEPROM(serialNumber);
    Serial.println("Серійник збережено в EEPROM");

    // 🔽 Надіслати підтвердження назад
    DynamicJsonDocument response(128);
    response["serial"] = serialNumber;
    response["device"] = mqtt_user; // або будь-яке унікальне ім’я
    String resStr;
    serializeJson(response, resStr);
    client.publish(response_topic, resStr.c_str());
  }

  else if (String(topic) == "device/info_request") {
    DynamicJsonDocument info(128);
    info["serial"] = serialNumber;
    info["device"] = mqtt_user;

    String infoStr;
    serializeJson(info, infoStr);
    client.publish("device/info_response", infoStr.c_str());
    Serial.println("Надіслано info: " + infoStr);
  }
}


// ---------- WiFi ----------

void setup_wifi() {
  delay(10);
  Serial.println("Підключення до Wi-Fi...");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi з'єднано");
  Serial.print("IP адреса: ");
  Serial.println(WiFi.localIP());
}

// ---------- MQTT ----------

void reconnect() {
  while (!client.connected()) {
    Serial.print("Підключення до MQTT... ");
    String clientId = "ESP8266Client-" + String(random(0xffff), HEX);

    if (client.connect(clientId.c_str(), mqtt_user, mqtt_pass)) {
      Serial.println("успішно");

      client.subscribe(request_topic);
      client.subscribe(serial_topic);
      client.subscribe("device/info_request");

    } else {
      Serial.print("Помилка, rc=");
      Serial.print(client.state());
      Serial.println(" повтор через 5 секунд");
      delay(5000);
    }
  }
}

// ---------- SETUP & LOOP ----------

void setup() {
  Serial.begin(115200);
  dht.begin();
  setup_wifi();

  espClient.setInsecure(); // ігнорування сертифікату SSL
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  
  serialNumber = readSerialFromEEPROM();
  Serial.println("Серійник з EEPROM: " + serialNumber);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  float h = dht.readHumidity();
  float t = dht.readTemperature();

  if (isnan(h) || isnan(t)) {
    Serial.println("Помилка зчитування з DHT22");
    return;
  }

  Serial.printf("Температура: %.1f °C | Вологість: %.1f %%\n", t, h);

  client.publish(temp_topic, String(t, 1).c_str(), true);
  client.publish(hum_topic, String(h, 1).c_str(), true);

  delay(5000);
}
