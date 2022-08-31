part of 'contact_cubit.dart';

@immutable
class ContactState extends Equatable {
  final String? searchText;
  List<ConversionEntity>? listConversion;
  LoadStatus? loadStatus;

  ContactState({
    this.searchText = '',
    this.listConversion = const [],
    this.loadStatus,
  });

  ContactState copyWith({
    String? searchText,
    List<ConversionEntity>? listConversion,
    LoadStatus? loadStatus,
  }) {
    return ContactState(
      searchText: searchText ?? this.searchText,
      listConversion: listConversion ?? this.listConversion,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        searchText,
        listConversion,
        loadStatus,
      ];
}
