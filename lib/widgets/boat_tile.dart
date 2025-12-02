import 'package:flutter/material.dart';
import '../models/boat.dart';

class BoatTile extends StatelessWidget {
  final Boat boat;

  const BoatTile({super.key, required this.boat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${boat.year} - ${boat.powerType}"),
      subtitle: Text("Length: ${boat.length} | Price: \$${boat.price}"),
    );
  }
}
