import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/create_task_bottom_sheet.dart';
import 'widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = fetchTasks();
  }

  Future<List<dynamic>> fetchTasks() async {
    try {
      final response = await Supabase.instance.client
          .from('tasks')
          .select()
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      return Future.error('Failed to fetch tasks: $e');
    }
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = fetchTasks();
    });
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      await Supabase.instance.client.from('tasks').delete().eq('id', taskId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully')),
      );
      _refreshTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  void _openEditTaskBottomSheet(dynamic task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CreateTaskBottomSheet(
        taskId: task['id'].toString(), // Ensure taskId is passed as String
        taskTitle: task['title'],
        taskDescription: task['description'],
      ),
    ).then((_) {
      _refreshTasks();
    });
  }

  // Add the buildTaskItem method here
  Widget buildTaskItem(Map<String, dynamic> task) {
    return Card(
      color: Color(0xFF1E1E1E), // Warna gelap untuk card
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon status tugas
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: task['status'] == 'Completed'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                task['status'] == 'Completed'
                    ? Icons.check_circle
                    : Icons.pending,
                color: task['status'] == 'Completed'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            SizedBox(width: 16),
            // Detail task
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    task['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        task['task_date'] ?? 'No Date',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.alarm, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        task['task_time'] ?? 'No Time',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tombol edit dan delete
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    _openEditTaskBottomSheet(task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    _deleteTask(task['id']);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'img/TODOGUL2.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white30),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF8687E7)));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/empaty_tasks.png',
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'What do you want to do today?',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tap + to add your tasks',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  );
                } else {
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return buildTaskItem(task); // Use the method here
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => CreateTaskBottomSheet(),
          ).then((_) {
            _refreshTasks();
          });
        },
        backgroundColor: Color(0xFF8687E7),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
