import 'package:flutter/material.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  final String? taskId;
  final String? taskTitle;
  final String? taskDescription;
  
  // Constructor to optionally pass data for editing
  CreateTaskBottomSheet({this.taskId, this.taskTitle, this.taskDescription});

  @override
  _CreateTaskBottomSheetState createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  int selectedStatusIndex = 0; // 0 = Incomplete, 1 = Completed
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedRepeat = 'No Repeat';
  String selectedDay = 'Sunday';
  String selectedReminder = 'None';

  @override
  void initState() {
    super.initState();

    // If the taskId is provided, set the data for editing
    if (widget.taskId != null) {
      _titleController.text = widget.taskTitle ?? '';
      _descriptionController.text = widget.taskDescription ?? '';
    }
  }

  // Function to add a task
  Future<void> addTask(String title, String description) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('tasks').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'status': selectedStatusIndex == 0 ? 'Incomplete' : 'Completed',
        'task_date': selectedDate?.toIso8601String(),
        'task_time': selectedTime != null
    ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00'
    : null,
        'repeat_option': selectedRepeat,
        'day_option': selectedDay,
        'reminder_option': selectedReminder,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding task: $e')),
      );
    }
  }

  // Function to update a task
  Future<void> updateTask(String id, String title, String description) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('tasks').update({
        'title': title,
        'description': description,
        'status': selectedStatusIndex == 0 ? 'Incomplete' : 'Completed',
        'task_date': selectedDate?.toIso8601String(),
        'task_time': selectedTime != null
    ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00'
    : null,
        'repeat_option': selectedRepeat,
        'day_option': selectedDay,
        'reminder_option': selectedReminder,
      }).eq('id', id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }

  // Function to delete a task
  Future<void> deleteTask(String id) async {
    try {
      await Supabase.instance.client.from('tasks').delete().eq('id', id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully!')),
      );
      Navigator.pop(context); // Close the bottom sheet after deleting the task
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskId == null ? 'Create to-do' : 'Edit to-do', // Change based on taskId
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _titleController,
              hintText: 'Enter Title',
              labelText: 'Title',
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              hintText: 'Enter Description',
              labelText: 'Description',
              maxLines: 3,
            ),
            SizedBox(height: 16),
            CustomDropdown(
              labelText: 'Repeat',
              options: ['No Repeat', 'Daily', 'Weekly', 'Monthly'],
              value: selectedRepeat,
              onChanged: (value) {
                setState(() {
                  selectedRepeat = value!;
                });
              },
            ),
            SizedBox(height: 16),
            CustomDropdown(
              labelText: 'Day',
              options: [
                'Sunday',
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday'
              ],
              value: selectedDay,
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                });
              },
            ),
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
              value: selectedReminder,
              onChanged: (value) {
                setState(() {
                  selectedReminder = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8687E7),
                    ),
                    child: Text('Select Date'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8687E7),
                    ),
                    child: Text('Select Time'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Task Status:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: ToggleButtons(
                isSelected: [selectedStatusIndex == 0, selectedStatusIndex == 1],
                onPressed: (index) {
                  setState(() {
                    selectedStatusIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                selectedBorderColor: Colors.white,
                fillColor: Color(0xFF8687E7),
                color: Colors.white,
                selectedColor: Colors.black,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Incomplete'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Completed'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            widget.taskId == null
                ? ElevatedButton(
                    onPressed: () async {
                      await addTask(_titleController.text, _descriptionController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8687E7),
                    ),
                    child: Center(
                      child: Text('Add Task'),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateTask(
                                widget.taskId!,
                                _titleController.text,
                                _descriptionController.text,
                            );
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8687E7),
                          ),
                          child: Center(
                            child: Text('Update Task'),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await deleteTask(widget.taskId!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Center(
                            child: Text('Delete Task'),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
