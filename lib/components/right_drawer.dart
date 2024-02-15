import 'package:flutter/material.dart';
import 'package:weather_app/services/local_storage_service.dart';

class RightDrawer extends StatefulWidget {
  @override
  _RightDrawerState createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {

  final LocalStorageService localStorageService = LocalStorageService();
  String _selectedUnit = 'C';
  String _selectedRefreshRate = 'Setiap jam';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    String? unit = localStorageService.getSetting('unit');
    String? refreshRate = localStorageService.getSetting('refresh_rate');
    setState(() {
      _selectedUnit = unit ?? 'C';
      _selectedRefreshRate = refreshRate ?? 'Setiap jam';
    });
  }

  void _showUnitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            ListTile(
              title: Text('Celsius (°C)'),
              onTap: () {
                localStorageService.saveSetting('unit', 'C');
                setState(() => _selectedUnit = 'C');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Fahrenheit (°F)'),
              onTap: () {
                localStorageService.saveSetting('unit', 'F');
                setState(() => _selectedUnit = 'F');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRefreshRateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            ListTile(
              title: Text('Setiap menit'),
              onTap: () {
                localStorageService.saveSetting('refresh_rate', 'Setiap menit');
                setState(() => _selectedRefreshRate = 'Setiap menit');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Setiap jam'),
              onTap: () {
                localStorageService.saveSetting('refresh_rate', 'Setiap jam');
                setState(() => _selectedRefreshRate = 'Setiap jam');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Setiap 3 jam'),
              onTap: () {
                localStorageService.saveSetting('refresh_rate', 'Setiap 3 jam');
                setState(() => _selectedRefreshRate = 'Setiap 3 jam');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showHelpModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Bantuan',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                  'Anda bisa melihat prakiraan cuaca serta cuaca saat ini di aplikasi ini. Anda juga bisa menambahkan lokasi yang ingin anda lihat prakiraan cuacanya.'),
            ],
          ),
        );
      },
    );
  }

  void _showAboutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Anggota Tim:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Husnia (220401020032)'),
              Text('Fadillah Munajad (200401010019)'),
              Text('M. Dayan Budi (210401010045)'),
              Text('Gusti Bagus C. (210401010082)'),
            ],
          ),
        );
      },
    );
  }

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
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
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
            trailing: Text(_selectedUnit == 'C' ? '°C' : '°F'),
            onTap: () => _showUnitModal(context),
          ),
          ListTile(
            title: Text('Penyegaran'),
            trailing: Text(_selectedRefreshRate),
            onTap: () => _showRefreshRateModal(context),
          ),
          // ListTile(
          //   title: Text('Bahasa'),
          //   trailing: Text('Indonesia'),
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Bantuan'),
            onTap: () => _showHelpModal(context),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Kami'),
            onTap: () => _showAboutModal(context),
          ),
        ],
      ),
    );
  }
}
