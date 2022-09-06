part of 'contact_cubit.dart';

@immutable
class ContactState extends Equatable {
  final String? searchText;
  List<ConversionEntity> listConversion;
  LoadStatus? loadStatus;
  List<ConversionEntity> listSearch;

  ContactState({
    this.searchText = '',
    this.listConversion = const [],
    this.loadStatus,
    this.listSearch = const [],
  });

  ContactState copyWith({
    String? searchText,
    List<ConversionEntity>? listConversion,
    LoadStatus? loadStatus,
    List<ConversionEntity>? listSearch,
  }) {
    return ContactState(
      searchText: searchText ?? this.searchText,
      listConversion: listConversion ?? this.listConversion,
      loadStatus: loadStatus ?? this.loadStatus,
      listSearch: listSearch ?? this.listSearch,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        searchText,
        listConversion,
        loadStatus,
        listSearch,
      ];
}
