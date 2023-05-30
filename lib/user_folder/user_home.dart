import 'package:flutter/material.dart';
import 'package:ride_with_mee/user_folder/user_tabs/user_home_tab.dart';
import 'package:ride_with_mee/user_folder/user_tabs/user_notifications_tab.dart';
import 'package:ride_with_mee/user_folder/user_tabs/user_profile_tab.dart';
import 'package:ride_with_mee/user_folder/user_tabs/user_rides_tab.dart';

class PassHomeScreen extends StatefulWidget {
  const PassHomeScreen({Key? key}) : super(key: key);

  @override
  State<PassHomeScreen> createState() => _PassHomeScreenState();
}

class _PassHomeScreenState extends State<PassHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          UserHomeTab(),
          //SearchFeed(),
          UserRidesTab(),

          UserNotificationsTab(),
          UserProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: "Rides",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Color.fromARGB(255, 61, 86, 107),
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            tabController.index = selectedIndex;
          });
        },
      ),
    );
  }
}
