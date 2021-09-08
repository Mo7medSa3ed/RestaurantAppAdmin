class Copoun {
  String id;
  String createdAt;
  String updatedAt;
  String text;
  int duration;
  num amount;

  Copoun(
      {this.text,
      this.amount,
      this.duration,
      this.id,
      this.createdAt,
      this.updatedAt});

  factory Copoun.fromJson(Map<String, dynamic> json) => Copoun(
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      text: json['text'],
      duration: json['duration'],
      amount: json['amount']);

  Map<String, dynamic> toJson() =>
      {'text': text, 'duration': duration, 'amount': amount};

  Map<String, dynamic> toJsonForUpdate() =>
      {'text': text, 'duration': duration, 'amount': amount, '_id': id};
}
