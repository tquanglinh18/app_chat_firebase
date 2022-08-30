part of 'chats_cubit.dart';

@immutable
class ChatsState extends Equatable{
  final String? searchText;

  const ChatsState({
    this.searchText = '',
  });

  ChatsState copyWith({String? searchText}) {
    return ChatsState(
      searchText: searchText ?? this.searchText,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [searchText];
}

