// lib/models/contact_message.dart
class ContactMessage {
  final String id;
  final String subject;
  final String message;
  final DateTime timestamp;

  ContactMessage({
    required this.id,
    required this.subject,
    required this.message,
    required this.timestamp,
    required String name,
    required String phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'],
      subject: json['subject'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      name: '',
      phone: '',
    );
  }
}
