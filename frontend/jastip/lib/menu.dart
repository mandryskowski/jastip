import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/MyDeliveries.dart';
import 'DeliveryCarrierPage.dart';
import 'ToggablePage.dart';

class MenuBox extends StatelessWidget {
  const MenuBox({super.key});

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
                color: backgroundColorData, // Subtle background color
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0), // Padding around the avatar
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://cdn.frankerfacez.com/emoticon/660211/4'),
                    ),
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
          const Padding(
            padding: EdgeInsets.only(top: 8.0), // Space above section title
            child: SectionTitle(title: 'Transport and Delivery'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.push(
                context,
                 coolTransition(0, 'MyDeliveries', (initialIndex) => Mydeliveries(initialIndex: initialIndex)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_return),
            title: const Text('My Drop-Offs'),
            onTap: () {},
          ),
          const PaddedDivider(),
          const SectionTitle(title: 'Services'),
          ListTile(
            leading: const Icon(Icons.send),
            title: const Text('Send Package'),
            onTap: () {
              Navigator.push(
                context,
                coolHomeTransition(0),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Transport Package'),
            onTap: () {
              Navigator.push(
                context,
                coolHomeTransition(1),
              );
            },
          ),
          const PaddedDivider(),
          const SectionTitle(title: 'Support'),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Customer Support'),
            onTap: () {},
          ),
          const PaddedDivider(),
          const SectionTitle(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account Details'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {},
          ),
          const PaddedDivider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  PageRouteBuilder coolHomeTransition(int initialIndex) {
    return coolTransition(initialIndex, 'HomePage', (initialIndex) => HomePage(initialIndex: initialIndex));
  }

  PageRouteBuilder coolTransition(int initialIndex, String routeName, ToggablePage Function(int) newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage(initialIndex),
      settings: RouteSettings(name: '/$routeName$initialIndex'),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add vertical padding
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PaddedDivider extends StatelessWidget {
  const PaddedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0), // Space around dividers
            child: Divider(),
          );
  }
}
