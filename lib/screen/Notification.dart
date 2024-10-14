import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: AppBar(
            actions: [
              GestureDetector(
                onTap: () {
                  // Handle delete action
                },
                child: CircleAvatar(
                  maxRadius: 23,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: SvgPicture.asset(
                    "assets/images/DeleteIcon.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.035,
              ),
            ],
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 120, right: 15, left: 15),
              child: Container(
                width: width * 0.95,
                height: height * 0.08,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                  child: TabBar(
                    indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    indicatorWeight: 0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerHeight: 0,
                    indicatorColor: Colors.white,
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    tabs: const [
                      Tab(text: 'Notification'),
                      Tab(text: 'Messages'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            // Your notification tab content
            Center(
              child: Text('Notification Tab Content'),
            ),
            // Your messages tab content
            Center(
              child: Text('Messages Tab Content'),
            ),
          ],
        ),
      ),
    );
  }
}
