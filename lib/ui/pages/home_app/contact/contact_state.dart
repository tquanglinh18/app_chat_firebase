part of 'contact_cubit.dart';

@immutable
class ContactState extends Equatable {
  final String? searchText;
  List<ConversionEntity> listConversion;
  LoadStatus? loadStatusSearch;

  ContactState({
    this.searchText = '',
    this.listConversion = const [],
    this.loadStatusSearch,
  });

  ContactState copyWith({
    String? searchText,
    List<ConversionEntity>? listConversion,
    LoadStatus? loadStatusSearch,
    List<ConversionEntity>? listSearch,
  }) {
    return ContactState(
      searchText: searchText ?? this.searchText,
      listConversion: listConversion ?? this.listConversion,
      loadStatusSearch: loadStatusSearch ?? this.loadStatusSearch,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        searchText,
        listConversion,
        loadStatusSearch,
      ];
}
