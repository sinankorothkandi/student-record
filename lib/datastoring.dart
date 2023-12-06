class Student {
  final int? id;
  final String name;
  final int age;
  final String profilePicture;
  final int classs;
  final String father;
 

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.profilePicture,
    required this.classs,
    required this.father,
   
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'profilePicture': profilePicture,
      'classs': classs,
      'father': father,
     
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      profilePicture: map['profilePicture'],
      classs: map['classs'],
      father: map['father'],
     
    );
  }
}
