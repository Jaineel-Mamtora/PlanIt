class Task {
  final int id;
  final String title;
  final int date; // millisecondsSinchEpoch
  final int fromTime; // millisecondsSinchEpoch
  final int toTime; // millisecondsSinchEpoch
  final int reminder;
  final int priority;
  final int status;

  Task({
    this.id,
    this.title,
    this.fromTime,
    this.date,
    this.toTime,
    this.reminder,
    this.priority,
    this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['_id'],
        title: json['title'],
        fromTime: json['from_time'],
        date: json['date'],
        toTime: json['to_time'],
        reminder: json['reminder'],
        priority: json['priority'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'date': date,
        'from_time': fromTime,
        'to_time': toTime,
        'reminder': reminder,
        'priority': priority,
        'status': status,
      };
}
