import 'package:flutter/material.dart';
import 'package:journal/models/note.dart';
import 'package:journal/repository/notes_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Widget build(BuildContext context) {
    const _vertical_gap = SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dark Theme'),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
              _vertical_gap,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sound Fx'),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
              _vertical_gap,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Save data to drive'),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
              _vertical_gap,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Position title below the description'),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
              _vertical_gap,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Create Custom Theme'),
                    Icon(Icons.check_box),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
