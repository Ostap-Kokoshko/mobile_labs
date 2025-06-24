import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/pages/registration_page/cubit/registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationState());

  void updateEmail(String email) => emit(state.copyWith(email: email));
  void updateLogin(String login) => emit(state.copyWith(login: login));
  void updatePassword(String password) => emit(
        state.copyWith(password: password),
      );
}
