import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dialog_create_conversion_state.dart';

class DialogCreateConversionCubit extends Cubit<DialogCreateConversionState> {
  DialogCreateConversionCubit() : super(const DialogCreateConversionState());

  setNameConversionChanged(String nameRoomConversion){
    emit(state.copyWith(nameRoomConversion: nameRoomConversion));
  }

  setImgRoomConversionPathChanged(String imgRoomConversionPath){
    emit(state.copyWith(imgRoomConversdionPath: imgRoomConversionPath));
  }

  removeImg(){
    emit(state.copyWith(imgRoomConversdionPath: ''));
  }
}
