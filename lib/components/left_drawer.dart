import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Text('Search Location'),
            decoration: BoxDecoration(
              color: Colors.blue,
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
