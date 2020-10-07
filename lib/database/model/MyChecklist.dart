class MyChecklist{
  int id;
  int taskId;
  int status;
  int targetId;

  MyChecklist(this.taskId, this.status, this.targetId);

  Map<String, dynamic> toMap() => {
    'id' : id,
    'task_id': taskId,
    'status': status,
    'target_id': targetId,
  };

  MyChecklist.fromMap(Map<String, dynamic> map){
    id = map['id'];
    taskId = map['task_id'];
    status = map['status'];
    targetId = map['target_id'];
  }
}