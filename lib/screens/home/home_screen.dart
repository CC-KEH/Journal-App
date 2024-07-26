import 'package:flutter/material.dart';
import 'package:journal/repository/notes_repository.dart';
import 'package:journal/screens/create_note/create_note_screen.dart';
import 'package:journal/screens/home/widgets/note_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Journal',
          style: TextStyle(fontSize: 32),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()=>setState(() {}), icon: const Icon(Icons.refresh))
        ],
      ),

      body: FutureBuilder(
        future: NotesRepository.get_notes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Empty'),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                for (var note in snapshot.data!)
                  NoteTile(
                    note: note,
                  )
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateNoteScreen()));
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     const BottomNavigationBarItem(icon: Icon(Icons.image),),
      //     const BottomNavigationBarItem(icon: Icon(Icons.fiber_manual_record),),
      //     const BottomNavigationBarItem(icon: Icon(Icons.video_call),),
      //   ],
      // ),
    );
  }
}
