class Notification {
  final int id;
  final String title;
  final String message;
  final String type;
  final String status;
  final int? studyId;
  final String? studyTitle;
  final String? relatedUrl;
  final DateTime createdAt;
  final DateTime? readAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.status,
    this.studyId,
    this.studyTitle,
    this.relatedUrl,
    required this.createdAt,
    this.readAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      status: json['status'],
      studyId: json['studyId'],
      studyTitle: json['studyTitle'],
      relatedUrl: json['relatedUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'status': status,
      'studyId': studyId,
      'studyTitle': studyTitle,
      'relatedUrl': relatedUrl,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  bool get isUnread => status == 'unread';
} 