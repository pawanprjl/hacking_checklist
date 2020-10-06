class MyCategory{
  int id;
  String category;

  MyCategory(this.category);

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
  };

  MyCategory.fromMap(Map<String, dynamic> map){
    id = map['id'];
    category = map['category'];
  }
}