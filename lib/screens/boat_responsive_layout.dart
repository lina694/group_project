import 'package:flutter/material.dart';
import '../models/boat.dart';
import 'boat_list_screen.dart';
import 'boat_details_screen.dart';

/// A widget that manages the responsive layout for the Boat module.
///
/// Checks the screen width to determine whether to show a list-only view (Phone)
/// or a side-by-side master-detail view (Tablet/Desktop).
class BoatResponsiveLayout extends StatefulWidget {
  /// Creates a [BoatResponsiveLayout].
  const BoatResponsiveLayout({super.key});

  @override
  State<BoatResponsiveLayout> createState() => _BoatResponsiveLayoutState();
}

class _BoatResponsiveLayoutState extends State<BoatResponsiveLayout> {
  /// The currently selected boat to display in the detail pane.
  Boat? _selectedBoat;

  /// A flag indicating whether the "Add Boat" form should be visible.
  bool _showAddForm = false;

  /// Key used to access the state of the boat list for refreshing data.
  final GlobalKey<BoatListScreenState> _listKey = GlobalKey<BoatListScreenState>();

  /// Refreshes the list of boats and resets the selection state.
  void _refreshList() {
    _listKey.currentState?.refreshBoats();
    setState(() {
      _selectedBoat = null;
      _showAddForm = false;
    });
  }

  /// Handles the selection of a boat from the list.
  ///
  /// On tablets, it updates the state to show details on the right.
  /// On phones, it pushes a new route to the detail screen.
  void _onBoatSelected(Boat boat, bool isTablet) {
    if (isTablet) {
      setState(() {
        _selectedBoat = boat;
        _showAddForm = false;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoatDetailsScreen(
            boat: boat,
            onDataChanged: _refreshList,
          ),
        ),
      );
    }
  }

  /// Initiates the "Add Boat" flow.
  void _navigateToAddPage({required bool isTablet}) {
    if (isTablet) {
      setState(() {
        _selectedBoat = null;
        _showAddForm = true;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoatDetailsScreen(
            onDataChanged: _refreshList,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint for switching layouts (600px).
        final bool isTablet = constraints.maxWidth > 600;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToAddPage(isTablet: isTablet),
            child: const Icon(Icons.add),
          ),
          body: isTablet
              ? _buildTabletLayout(isTablet)
              : _buildPhoneLayout(isTablet),
        );
      },
    );
  }

  /// Builds the layout for smaller screens (phones).
  Widget _buildPhoneLayout(bool isTablet) {
    return BoatListScreen(
      key: _listKey,
      onBoatSelected: (boat) => _onBoatSelected(boat, isTablet),
    );
  }

  /// Builds the master-detail layout for larger screens (tablets).
  Widget _buildTabletLayout(bool isTablet) {
    return Row(
      children: [
        // Left pane: List of boats
        Expanded(
          flex: 1,
          child: BoatListScreen(
            key: _listKey,
            selectedBoatId: _selectedBoat?.id,
            onBoatSelected: (boat) => _onBoatSelected(boat, isTablet),
          ),
        ),
        // Right pane: Details or Add Form
        Expanded(
          flex: 2,
          child: _selectedBoat != null
              ? BoatDetailsScreen(
            key: ValueKey(_selectedBoat!.id),
            boat: _selectedBoat,
            onDataChanged: _refreshList,
            isTablet: true,
          )
              : _showAddForm
              ? BoatDetailsScreen(
            key: const ValueKey('add_form'),
            onDataChanged: _refreshList,
            isTablet: true,
          )
              : const Center(
            child: Text('Select a boat or press + to add.'),
          ),
        ),
      ],
    );
  }
}