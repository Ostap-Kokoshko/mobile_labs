#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

// -----------------------------
const char* ssid = "Ostap";
const char* password = "Ostap2004";

const char* mqtt_server = "28c5545e26094092b6785f4d24098c1f.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_user = "My_Cred";
const char* mqtt_pass = "MyCred1234";

const char* temp_topic = "home/temperature";
const char* hum_topic = "home/humidity";

// -----------------------------
#define DHTPIN 2
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// -----------------------------
WiFiClientSecure espClient;
PubSubClient client(espClient);

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

void reconnect() {
  while (!client.connected()) {
    Serial.print("Підключення до MQTT...");
    if (client.connect("ESP8266Client", mqtt_user, mqtt_pass)) {
      Serial.println("З'єднано");
    } else {
      Serial.print("Помилка: ");
      Serial.print(client.state());
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  dht.begin();
  setup_wifi();

  espClient.setInsecure();

  client.setServer(mqtt_server, mqtt_port);
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

  Serial.print("Температура: ");
  Serial.print(t);
  Serial.print(" °C  | Вологість: ");
  Serial.print(h);
  Serial.println(" %");

  client.publish(temp_topic, String(t, 1).c_str(), true);
  client.publish(hum_topic, String(h, 1).c_str(), true);

  delay(5000);
}
