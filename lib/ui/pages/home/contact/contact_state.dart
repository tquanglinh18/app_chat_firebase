part of 'contact_cubit.dart';

@immutable
class ContactState extends Equatable {
  final String? searchText;
  List<ConversionEntity> listConversion;
  LoadStatus? loadStatusSearch;
  LoadStatus? loadStatusAddConversion;

  ContactState({
    this.searchText = '',
    this.listConversion = const [],
    this.loadStatusSearch,
    this.loadStatusAddConversion,
  });

  ContactState copyWith({
    String? searchText,
    List<ConversionEntity>? listConversion,
    LoadStatus? loadStatusSearch,
    List<ConversionEntity>? listSearch,
    LoadStatus? loadStatusAddConversion,
  }) {
    return ContactState(
      searchText: searchText ?? this.searchText,
      listConversion: listConversion ?? this.listConversion,
      loadStatusSearch: loadStatusSearch ?? this.loadStatusSearch,
      loadStatusAddConversion: loadStatusAddConversion ?? this.loadStatusAddConversion,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        searchText,
        listConversion,
        loadStatusSearch,
        loadStatusAddConversion,
      ];
}
