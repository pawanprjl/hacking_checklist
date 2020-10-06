class MyChecklist{
  int id;
  String taskName;
  int status;
  int targetId;

  MyChecklist(this.taskName, this.status, this.targetId);

  Map<String, dynamic> toMap() => {
    'id' : id,
    'task_name': taskName,
    'status': status,
    'target_id': targetId,
  };

  MyChecklist.fromMap(Map<String, dynamic> map){
    id = map['id'];
    taskName = map['task_name'];
    status = map['status'];
    targetId = map['target_id'];
  }
}