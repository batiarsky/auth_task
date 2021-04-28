import 'package:auth_task/ui/login_page/login_bloc.dart';
import 'package:auth_task/ui/login_page/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginCubit _loginCubit;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRememberCheck = false;
  String _email = "";
  String _password = "";

  _LoginFormState();

  @override
  Widget build(BuildContext context) {
    _loginCubit = context.read<LoginCubit>();

    return BlocConsumer(
      bloc: _loginCubit,
      listenWhen: (previous, current) => current is LoginErrorState,
      listener: (context, state) {
        if (state is LoginErrorState) {
          _showMaterialDialog(state.message, context);
        }
      },
      builder: (context, state) {
        if (state is LoginSuccessfulState) {
          return Container();
        } else if (state is CredentialState) {
          _email = state.login;
          _password = state.password;
          _isRememberCheck = state.isRememberChecked;
          _emailController.text = _email;
          _passwordController.text = _password;
        }
        return _formBody();
      },
    );
  }

  Form _formBody() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: _emailValidator,
            decoration: InputDecoration(
              labelText: 'Поштова скринька',
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            validator: _passwordValidator,
            decoration: InputDecoration(
              labelText: 'Пароль',
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                      value: _isRememberCheck,
                      onChanged: (value) {
                        _isRememberCheck = value;
                        _loginCubit.updateUser(value);
                      }),
                  SizedBox(width: 8),
                  Text("Запам'ятати"),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "Забули пароль?",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    );
                  },
                  child: Text('Забули пароль?'),
              ),
            ],
          ),
          SizedBox(height: _height / 24),
          SizedBox(
            width: _width,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _loginCubit.onSignIn(_emailController.text,
                      _passwordController.text, _isRememberCheck);
                }
              },
              child: Text('Увійти'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showMaterialDialog(final String message, final BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error!"),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  String _emailValidator(final String email) {
    if (EmailValidator.validate(email)) {
      return null;
    } else {
      return "Please, enter a valid email.";
    }
  }

  String _passwordValidator(String value) {
    if (_passwordController.text.length < 5) {
      return '5 character required for password';
    } else {
      return null;
    }
  }
}
