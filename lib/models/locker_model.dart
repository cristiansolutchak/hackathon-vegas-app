class LockerToken {
  final int lockerId;
  final int startTime;
  final String signature;

  LockerToken({
    required this.lockerId,
    required this.startTime,
    required this.signature,
  });

  factory LockerToken.fromJson(Map<String, dynamic> json) {
    return LockerToken(
      lockerId: json['locker_id'],
      startTime: json['start_time'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locker_id': lockerId,
      'start_time': startTime,
      'signature': signature,
    };
  }
}