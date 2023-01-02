import 'package:flutter/material.dart';
import '../models/authentication_model.dart';
import '../models/authentication_model_impl.dart';

class LoginBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  bool isDisposed = false;

  ///Model
  final AuthenticationModel _model = AuthenticationModelImpl();

  Future onTapLogin(){
    _showLoading();
    return _model.login(email, password).whenComplete(()=> _hideLoading());
  }

  void onEmailChanged(String email) {
    this.email = email;
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