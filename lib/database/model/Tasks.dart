class Task {
  int id;
  String taskName;

  Task(this.taskName);

  Map<String, dynamic> toMap() => {
    'id': id,
    'task_name': taskName,
  };

  Task.fromMap(Map<String, dynamic> map){
    id = map['id'];
    taskName = map['task_name'];
  }
}