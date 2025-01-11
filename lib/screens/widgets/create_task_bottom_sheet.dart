import 'package:flutter/material.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://imbrrrtmtsphkmkhwpow.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImltYnJycnRtdHNwaGtta2h3cG93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY1MDQ2MTEsImV4cCI6MjA1MjA4MDYxMX0.DdBcnppdkSTnWNK8oPB-Ul-A-nViqR-DGpuI2S8Jw3w',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

Future<void> addTask(String title, String description) async {
  final response = await Supabase.instance.client
      .from('tasks')
      .insert({
        'user_id': Supabase.instance.client.auth.currentUser?.id ?? '',
        'title': title,
        'description': description,
      })
      .select();

  if (response.isEmpty) {
    print('Error adding task');
  } else {
    print('Task added successfully!');
  }
}

Future<List<dynamic>> fetchTasks() async {
  final response = await Supabase.instance.client
      .from('tasks')
      .select()
      .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? '');

  if (response.isEmpty) {
    print('Error fetching tasks');
    return [];
  } else {
    return response;
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Management')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final tasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]['title'] ?? ''),
                  subtitle: Text(tasks[index]['description'] ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CreateTaskBottomSheet extends StatefulWidget {
  @override
  _CreateTaskBottomSheetState createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  int selectedStatusIndex = 0; // 0 = Incomplete, 1 = Completed

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create to-do',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          CustomTextField(hintText: 'Enter Title', labelText: 'Title'),
          SizedBox(height: 16),
          CustomTextField(hintText: 'Enter Description', labelText: 'Description', maxLines: 3),
          SizedBox(height: 16),
          CustomDropdown(labelText: 'Repeat', options: ['No Repeat', 'Daily', 'Weekly', 'Monthly']),
          SizedBox(height: 16),
          CustomDropdown(labelText: 'Day', options: [
            'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
          ]),
          SizedBox(height: 16),
          CustomDropdown(
            labelText: 'Reminder',
            options: [
              'None',
              '5 minutes before',
              '10 minutes before',
              '15 minutes before',
              '30 minutes before',
              '1 hour before'
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                  },
                  child: Text('Select Date'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: Text('Select Time'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text('Add Task'),
            ),
          ),
        ],
      ),
    );
  }
}
