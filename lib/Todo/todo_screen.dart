import 'package:flutter/material.dart';
import 'package:journal/constants.dart';
import 'package:journal/main.dart';
import 'package:journal/repository/todos_repository.dart';
import 'package:journal/Settings/Settings.dart';
import 'package:journal/Todo/create_todo_screen.dart';
import 'package:journal/Todo/widgets/todo_tile.dart';
import 'package:journal/theme_notifier.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> with RouteAware {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(fontSize: 32),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  onThemeChanged: () =>
                      Provider.of<ThemeNotifier>(context, listen: false)
                          .notifyListeners(),
                ),
              ),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder(
        future: TodosRepository.get_todos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(todo_recommendation_text),
              );
            }
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  for (var todo in snapshot.data!)
                    TodoTile(
                      todo: todo,
                    )
                ],
              );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTodoScreen(),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
