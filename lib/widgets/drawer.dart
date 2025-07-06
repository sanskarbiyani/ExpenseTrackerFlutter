import 'package:flutter/material.dart';
import 'package:message_expense_tracker/screens/accounts.dart';
import 'package:message_expense_tracker/screens/home.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key, required this.currentScreen});

  final String currentScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 35,
                    child: Text(
                      'S',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sanskar Biyani",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "My Wallet",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color:
                  currentScreen == "Home"
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color:
                    currentScreen == 'Home'
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_balance,
              color:
                  currentScreen == "Accounts"
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              "Accounts",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color:
                    currentScreen == "Accounts"
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AccountScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.notes_sharp,
              color:
                  currentScreen == "Records"
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              "Records",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color:
                    currentScreen == "Records"
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AccountScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history_sharp,
              color:
                  currentScreen == "PlannedPayments"
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              "Planned Payments",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color:
                    currentScreen == "PlannedPayments"
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AccountScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
