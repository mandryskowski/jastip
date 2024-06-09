import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'SimpleFormBox.dart';
import 'FormElement.dart';
import 'DeliveryCarrierPage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'JASTIP+',
                  style: tradeMarkStyle
                ),
                SizedBox(height: 16),
                SimpleFormBox(
                  fields: [
                    MapEntry('User name', [
                      SearchBarContentsTuple('eg. TopG', String, 'username'),
                    ]),
                    MapEntry('Password', [
                      SearchBarContentsTuple('**********', String, 'password'),
                    ]),
                  ], 
                  action: 'Log in', 
                  submitAction: submitAction,
                  suffix: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      redirectionText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitAction(Map<String, String> mp, BuildContext context) async {
    mp.remove('password');
    
    try {
      Map<String, dynamic> response = await HttpRequests.postRequest(mp, 'login', ret: true);
      if (response.containsKey('id')) {
        LoggedInUserData().userId = int.parse(response['id'].toString());
        LoggedInUserData().userName = response['username'].toString();
        print(LoggedInUserData().userId);
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(), settings: RouteSettings(name: '/HomePage0')),
        );
      } else {
        // Handle the case where the response does not contain the expected 'id' key
        showError(context, 'Login failed, ID not found in response.');
        print('Login failed, ID not found in response.');
      }
    } catch (e) {
      // Handle any errors that occur during the POST request
      print('An error occurred: $e');
      showError(context, 'An error occurred: $e');
    }
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget redirectionText() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Text(
              'Forgot password?',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Don’t have an account? Register here',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
