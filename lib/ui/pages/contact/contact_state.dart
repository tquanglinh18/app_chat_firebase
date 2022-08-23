part of 'contact_cubit.dart';

class ContactState extends Equatable {
  final int selectedIndex;

  const ContactState({this.selectedIndex = 0});

  ContactState copyWith({
    int? selectedIndex,
  }) {
    return ContactState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];
}
