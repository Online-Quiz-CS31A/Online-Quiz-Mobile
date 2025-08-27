import 'course.dart';
import 'notification_item.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final List<Course> courses;
  final List<NotificationItem> notifications;
  final String? bio;
  final String? phoneNumber;
  final String? emergencyContact;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.courses,
    required this.notifications,
    this.bio,
    this.phoneNumber,
    this.emergencyContact,
  });
}