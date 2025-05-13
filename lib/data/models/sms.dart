class Sms {
  final String senderNum;
  final String content;
  final DateTime date;

  Sms({required this.senderNum, required this.content, required this.date});

  factory Sms.fromJson(Map<dynamic, dynamic> json) => Sms(
    senderNum: json['address'] as String,
    content: json['body'] as String,
    date: DateTime.fromMillisecondsSinceEpoch(int.parse(json['date'])),
  );

  Map<String, dynamic> toJson() => {
    'senderNum': senderNum,
    'content': content,
    'date': date.millisecondsSinceEpoch,
  };
}
