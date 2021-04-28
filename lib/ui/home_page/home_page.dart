import 'package:auth_task/ui/home_page/home_bloc.dart';
import 'package:auth_task/ui/home_page/home_state.dart';
import 'package:auth_task/ui/login_page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Exit Page'),
          centerTitle: true,
        ),
        body: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final HomeCubit _homeCubit = context.read<HomeCubit>();
    _homeCubit.getUser();
    return BlocConsumer(
      bloc: _homeCubit,
      listenWhen: (previous, current) => current is HomeErrorState,
      listener: (context, state) {
        if (state is HomeErrorState) {
          _showMaterialDialog(state.message, context);
        }
      },
      builder: (context, state) {
        if (state is HomeStartState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeUserFetchedState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Hello \n${state.user.email}',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: _width / 2,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      _homeCubit.backToAuth();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return LoginPage();
                      }), (Route<dynamic> route) => false);
                    },
                    child: Text('Вийти'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28))),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
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
}
