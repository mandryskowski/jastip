import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'DeliveryCarrierPage.dart';

class MenuBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 130.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://cdn.frankerfacez.com/emoticon/660211/4'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'John Smith',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '4.3',
                            style: TextStyle(
                              color: Color(0xFF1C702E),
                              fontSize: 19,
                            ),
                          ),
                          Icon(Icons.star, color: Color(0xFF1C702E), size: 20.0),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SectionTitle(title: 'Transport and Delivery'),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('My Orders'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.assignment_return),
            title: Text('My Drop-Offs'),
            onTap: () {},
          ),
          Divider(),
          SectionTitle(title: 'Services'),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('Send Package'),
            onTap: () {
              Navigator.push(
                context,
                coolHomeTransition(0),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Transport Package'),
            onTap: () {
              Navigator.push(
                context,
                coolHomeTransition(1),
              );
            },
          ),
          Divider(),
          SectionTitle(title: 'Support'),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Customer Support'),
            onTap: () {},
          ),
          Divider(),
          SectionTitle(title: 'Account'),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account Details'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  PageRouteBuilder coolHomeTransition(int initialIndex) {
    return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(initialIndex: initialIndex),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
  }
}

 class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}




