part of 'contact_cubit.dart';

class ContactState extends Equatable {
  final String? searchText;
  final List<ConversionEntity> listConversion;
  final LoadStatus? loadStatusSearch;
  final LoadStatus? loadStatusAddConversion;
  final bool isClose;

  const ContactState({
    this.searchText = '',
    this.listConversion = const [],
    this.loadStatusSearch,
    this.loadStatusAddConversion,
    this.isClose = false,
  });

  ContactState copyWith({
    String? searchText,
    List<ConversionEntity>? listConversion,
    LoadStatus? loadStatusSearch,
    List<ConversionEntity>? listSearch,
    LoadStatus? loadStatusAddConversion,
    bool? isClose,
  }) {
    return ContactState(
      searchText: searchText ?? this.searchText,
      listConversion: listConversion ?? this.listConversion,
      loadStatusSearch: loadStatusSearch ?? this.loadStatusSearch,
      loadStatusAddConversion: loadStatusAddConversion ?? this.loadStatusAddConversion,
      isClose: isClose ?? this.isClose,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        searchText,
        listConversion,
        loadStatusSearch,
        loadStatusAddConversion,
        isClose,
      ];
}
