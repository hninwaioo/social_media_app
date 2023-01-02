import 'package:flutter/material.dart';
import '../models/authentication_model.dart';
import '../models/authentication_model_impl.dart';

class RegisterBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  String userName = "";
  bool isDisposed = false;

  ///Model
  final AuthenticationModel _model = AuthenticationModelImpl();

  Future onTapRegister(){
    _showLoading();
    return _model.register(email, userName, password).whenComplete(()=> _hideLoading());

  }

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onUserNameChanged(String userName){
    this.userName = userName;
  }

  void onPasswordChanged(String password){
    this.password = password;
  }

  void _showLoading(){
    isLoading = true;
    _notifySafety();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafety();
  }

  void _notifySafety(){
    if(!isDisposed){
      notifyListeners();
    }
  }
  @override
  void dispose(){
    super.dispose();
    isDisposed = true;
  }

}