import 'package:flutter/material.dart';

class RightDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent, // Removing the blue background color
            ),
          ),
          // SwitchListTile(
          //   title: Text('Notifikasi'),
          //   value: true,
          //   onChanged: (bool value) {
          //     // Handle change
          //   },
          // ),
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
