import 'package:flutter/material.dart';

import '../../model/task_model.dart';


class TaskPage extends StatelessWidget {
  final Task task;

  const TaskPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(task.taskFreeTexts.join('\n')),
            // Display the task media and question here
          ],
        ),
      ),
    );
  }
}
