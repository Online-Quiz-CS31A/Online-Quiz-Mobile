import 'course.dart';
import 'notification_item.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final List<Course> courses;
  final List<NotificationItem> notifications;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.courses,
    required this.notifications,
  });
}