import 'package:hacking_checklist/database/model/MyChecklist.dart';
import 'package:hacking_checklist/database/model/MyTargets.dart';
import 'package:hacking_checklist/database/model/Tasks.dart';
import 'package:hacking_checklist/database/repositories/ChecklistRepository.dart';
import 'package:hacking_checklist/database/repositories/TargetRepository.dart';
import 'package:hacking_checklist/database/repositories/TaskRepository.dart';

TaskRepository _taskRepository = new TaskRepository();
ChecklistRepository _checklistRepository = new ChecklistRepository();
TargetRepository _targetRepository = new TargetRepository();

final _tasks = [];

Future<void> resolveMethodology() async {
  await _taskRepository.getAllTasks().then((tasks){
    for (Task task in tasks){
      _tasks.add(task);
    }
  });

  _targetRepository.getAllTargets().then((targets) async {
    for (MyTarget target in targets){
      final _checklists = [];
      await _checklistRepository.getChecklistsOfTarget(target.id).then((checklists) async {
        for (MyChecklist checklist in checklists){
          await _taskRepository.getTaskById(id: checklist.taskId).then((value){
            _checklists.add(value.taskName);
          });
        }
      });
      if (_tasks.length == _checklists.length){
        return;
      }else{
        for (Task task in _tasks){
          if (!_checklists.contains(task.taskName)){
            _checklistRepository.addChecklist(MyChecklist(task.id, 0, target.id));
          }
        }
      }
    }
  });
}