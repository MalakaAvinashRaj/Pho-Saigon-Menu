class MenuItem {
  final String number;
  final String englishName;
  final String vietnameseName;
  final String category;

  MenuItem({
    required this.number,
    required this.englishName,
    required this.vietnameseName,
    required this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      number: json['Number'],
      englishName: json['English Name'],
      vietnameseName: json['Vietnamese Name'],
      category: json['Category'],
    );
  }
}
