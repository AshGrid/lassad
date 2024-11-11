class Webinar {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int duration;
  final int maxParticipants;
  final String meetLink;

  Webinar({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.maxParticipants,
    required this.meetLink,
  });

  factory Webinar.fromJson(Map<String, dynamic> json) {
    return Webinar(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      maxParticipants: json['maxParticipants'],
      meetLink: json['meetLink'],
    );
  }
}
