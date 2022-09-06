import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../database/share_preferences_helper.dart';
import '../../../../models/entities/chat_user_entity.dart';
import '../../../../models/enums/load_status.dart';
import '../../../../network/fire_base_api.dart';
import '../../../../utils/logger.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactState());

  onSearchTextChanged(String? searchText) {
    emit(state.copyWith(searchText: searchText));
  }

  initData() async {
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      FirebaseApi.getConversion().then(
        (value) {
          emit(
            state.copyWith(
              loadStatus: LoadStatus.success,
              listConversion: value,
            ),
          );
        },
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }

  listSearch(String? searchText) {
    if ((searchText ?? "").isEmpty) return;
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      FirebaseApi.getConversion().then(
        (value) {
          List<ConversionEntity> listSearch = value.isNotEmpty
              ? value.where((element) => (element.nameConversion ?? "").contains(searchText ?? "")).toList()
              : [];
          emit(
            state.copyWith(
              loadStatus: LoadStatus.success,
              listConversion: listSearch,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadStatus: LoadStatus.failure,

        ),
      );
    }
  }

  realTimeFireBase() {
    FirebaseApi.getConversion().then(
      (value) {
        emit(
          state.copyWith(
            listConversion: value,
          ),
        );
      },
    );
  }
}
