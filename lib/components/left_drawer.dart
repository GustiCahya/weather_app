import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView( // Using ListView for better scrolling behavior
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Handle the tap event for search here
              print('Search Tapped!');
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20), // Adjust padding for positioning
              child: Container(
                height: 48, // Standard height for text fields
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light grey color for the input field
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.search, color: Colors.grey[600]), // Darker grey icon
                    ),
                    Text(
                      'Search Location',
                      style: TextStyle(color: Colors.grey[600]), // Darker grey text
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Bogor'),
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Jakarta'),
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Depok'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tambah lokasi'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Atur lokasi tersimpan'),
          ),
        ],
      ),
    );
  }
}
