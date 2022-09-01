import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.username,
    required this.updatedAt,
    this.avatarUrl,
  });

  final String id;
  final String username;
  final String? avatarUrl;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, username, updatedAt, avatarUrl];
}
