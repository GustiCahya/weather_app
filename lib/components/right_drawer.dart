import 'package:flutter/material.dart';

class RightDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Pengaturan', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          SwitchListTile(
            title: Text('Notifikasi'),
            value: true,
            onChanged: (bool value) {
              // Handle change
            },
          ),
          ListTile(
            title: Text('Satuan'),
            trailing: Text('°C'),
          ),
          ListTile(
            title: Text('Penyegaran'),
            trailing: Text('Setiap jam'),
          ),
          ListTile(
            title: Text('Bahasa'),
            trailing: Text('Indonesia'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Bantuan'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang kami'),
          ),
        ],
      ),
    );
  }
}
