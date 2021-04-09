import 'package:flutter/material.dart';
import 'listen.dart';
import 'getlocation.dart';
import './settings.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Work Timer'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  /// might replace Datatable with PaginatedDataTable
  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
      menuItems.add(PopupMenuItem(
        value: 'Settings',
        child: Text('Settings'),
      ));
      return MaterialApp(
        title: 'My Work Timer',
        home: Scaffold(
          appBar: AppBar(
            title: Text('My Work Timer'),
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) {
                  return menuItems.toList();
                },
                onSelected: (s) {
                  if (s == 'Settings') {
                    goToSettings(context);
                  }
                },
              )
            ],
          ),
          body: DataTable(
        columns: const <DataColumn>[
        DataColumn(
          label: Text(
          'Name',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
      label: Text(
      'Age',
      style: TextStyle(fontStyle: FontStyle.italic),
      ),
      ),
      DataColumn(
      label: Text(
      'Role',
      style: TextStyle(fontStyle: FontStyle.italic),
      ),
      ),
      ],
      rows: const <DataRow>[
      DataRow(
      cells: <DataCell>[
      DataCell(Text('Sarah')),
      DataCell(Text('19')),
      DataCell(Text('Student')),
      ],
      ),
      DataRow(
      cells: <DataCell>[
      DataCell(Text('Janine')),
      DataCell(Text('43')),
      DataCell(Text('Professor')),
      ],
      ),
      DataRow(
      cells: <DataCell>[
      DataCell(Text('William')),
      DataCell(Text('27')),
      DataCell(Text('Associate Professor')),
      ],
      ),
      ],
      )

    )
    ,
    );
  }

  void emptyMethod() {}

  void goToSettings(BuildContext context) {
    print('in gotoSettings');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}
}
