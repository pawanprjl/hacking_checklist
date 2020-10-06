class MyTarget{
  int id;
  String targetName;
  int categoryId;

  MyTarget(this.targetName, this.categoryId);

  Map<String, dynamic> toMap() => {
    'id' : id,
    'target_name': targetName,
    'category_id': categoryId,
  };

  MyTarget.fromMap(Map<String, dynamic> map){
    id = map['id'];
    targetName = map['target_name'];
    categoryId = map['category_id'];
  }
}