import 'package:auth_task/ui/home_page/home_page.dart';
import 'package:auth_task/ui/login_page/login_bloc.dart';
import 'package:auth_task/ui/login_page/login_state.dart';
import 'package:auth_task/ui/login_page/login_widgets/login_form.dart';
import 'package:auth_task/ui/login_page/login_widgets/sotial_login_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_widgets/login_divider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Authorization Task'),
            centerTitle: true,
          ),
          body: LoginBody(),
        ),
      );
}

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return BlocConsumer(
      listener: (BuildContext context, state) {
        if (state is ProgressIndicatorState) {
          _showMaterialDialog(context);
        } else if (state is LoginSuccessfulState) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) {
            return HomePage();
          }), (Route<dynamic> route) => false);
        }
      },
      bloc: BlocProvider.of<LoginCubit>(context),
      builder: (context, state) {
        if (state is StartState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: _height / 16),
                    Text(
                      'Увійдіть \nщоб продовжити',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: _height / 24),
                    SocialLoginButtons(),
                    SizedBox(height: _height / 24),
                    LoginDivider(),
                    SizedBox(height: _height / 24),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _showMaterialDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
