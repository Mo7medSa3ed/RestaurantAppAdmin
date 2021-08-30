class Copoun {
  String id;
  String createdAt;
  String updatedAt;
  String name;
  String img;
  num numOfDishes;

  Copoun(
      {this.img,
      this.name,
      this.numOfDishes,
      this.id,
      this.createdAt,
      this.updatedAt});

  factory Copoun.fromJson(Map<String, dynamic> json) => Copoun(
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],
      img: json['img'],
      numOfDishes: json['numOfDishes']);

  Map<String, dynamic> toJson() =>
      {'name': name, 'img': img, 'numOfDishes': numOfDishes};

  Map<String, dynamic> toJsonForUpdate() =>
      {'name': name, 'img': img, 'numOfDishes': numOfDishes, '_id': id};
}
