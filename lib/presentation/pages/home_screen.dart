import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_movies/presentation/bloc/location/location_bloc.dart';
import 'package:we_movies/presentation/pages/explore_screen.dart';
import 'package:we_movies/presentation/pages/movie_screen.dart';
import 'package:we_movies/presentation/pages/upcoming_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.locationBloc, super.key});

  final LocationBloc locationBloc;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late LocationBloc _locationBloc;
  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _locationBloc = widget.locationBloc;
    _widgetOptions = <Widget>[
      MovieScreen(locationBloc: _locationBloc),
      const ExploreScreen(),
      const UpcomingScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: WeContainer(color: Colors.grey[700] ?? Colors.grey),
              activeIcon: const WeContainer(color: Colors.black),
              label: 'We Movies',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
              label: 'Explore',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Upcoming',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class WeContainer extends StatelessWidget {
  const WeContainer({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.only(bottom: 4),
      alignment: Alignment.topCenter,
      child: Text(
        'we',
        style: GoogleFonts.ebGaramond(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}
