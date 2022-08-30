part of 'contact_cubit.dart';

@immutable
class ContactState extends Equatable {
  final String? searchText;

  const ContactState({
    this.searchText = '',
  });

  ContactState copyWith({String? searchText}) {
    return ContactState(
      searchText: searchText ?? this.searchText,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [searchText];
}
