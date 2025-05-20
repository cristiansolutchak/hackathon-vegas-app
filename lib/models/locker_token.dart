// Models
class Locker {
  final int id;
  final String state;

  Locker({required this.id, required this.state});

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['id'],
      state: json['state'],
    );
  }
}