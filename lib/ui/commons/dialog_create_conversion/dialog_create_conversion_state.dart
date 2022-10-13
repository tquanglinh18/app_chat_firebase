part of 'dialog_create_conversion_cubit.dart';

class DialogCreateConversionState extends Equatable {
  final String nameRoomConversion;
  final String imgRoomConversdionPath;

  const DialogCreateConversionState({
    this.nameRoomConversion = '',
    this.imgRoomConversdionPath = '',
  });

  DialogCreateConversionState copyWith({
    String? nameRoomConversion,
    String? imgRoomConversdionPath,
  }) {
    return DialogCreateConversionState(
      nameRoomConversion: nameRoomConversion ?? this.nameRoomConversion,
      imgRoomConversdionPath: imgRoomConversdionPath ?? this.imgRoomConversdionPath,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        nameRoomConversion,
        imgRoomConversdionPath,
      ];
}
