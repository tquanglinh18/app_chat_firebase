part of 'more_cubit.dart';

class MoreState extends Equatable {
  final LoadStatus? loadStatus;

  final String name;
  final String avatar;
  final String phoneNumber;

  const MoreState({
    this.loadStatus,
    this.name = '',
    this.avatar = '',
    this.phoneNumber = '',
  });

  MoreState copyWith({
    LoadStatus? loadStatus,
    String? name,
    String? avatar,
    String? phoneNumber,
  }) {
    return MoreState(
      loadStatus: loadStatus ?? this.loadStatus,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        name,
        avatar,
        phoneNumber,
      ];
}
