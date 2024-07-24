import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wi-Fi App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
      ],
      home: WiFiInfoScreen(),
    );
  }
}

class WiFiInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Info'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (Platform.isAndroid || Platform.isIOS) {
              // Meminta izin ACCESS_FINE_LOCATION
              if (await Permission.location.request().isGranted) {
                final info = NetworkInfo();
                var wifiName = await info.getWifiName(); // Nama Wi-Fi (SSID)
                var wifiBSSID = await info.getWifiBSSID(); // BSSID
                var wifiIP = await info.getWifiIP(); // IP Address
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Wi-Fi Info'),
                      content: Text('SSID: $wifiName\n'
                          'IP Address: $wifiIP\n'
                          'BSSID: $wifiBSSID'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Permission Denied'),
                      content: Text('Location permission is required to access Wi-Fi information.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Unsupported Platform'),
                    content: Text('This feature is not supported on this platform.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('Get Wi-Fi Info'),
        ),
      ),
    );
  }
}
