import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/commons/app_util.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../commons/dialog_helper.dart';
import '../type_document.dart';

class OptionChat extends StatefulWidget {
  final bool isSelected;
  final Function(List<File>)? onChooseImage;
  final Function(List<File>, File)? onChooseVideo;
  final Function(List<File>)? onChooseDocument;
  final Function(Recording? record)? callBackRecord;
  final List<DocumentEntity> listDocument;

  const OptionChat({
    Key? key,
    this.isSelected = false,
    required this.onChooseImage,
    required this.onChooseVideo,
    required this.onChooseDocument,
    this.callBackRecord,
    required this.listDocument,
  }) : super(key: key);

  @override
  State<OptionChat> createState() => _OptionChatState();
}

class _OptionChatState extends State<OptionChat> {
  List<Asset> images = <Asset>[];
  late FlutterAudioRecorder2 _recorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedCrossFade(
      firstChild: const SizedBox(),
      secondChild: Container(
        padding: const EdgeInsets.fromLTRB(68, 16, 68, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: widget.listDocument.isEmpty |
                      (widget.listDocument.isNotEmpty &&
                          widget.listDocument.first.type == TypeDocument.IMAGE.toTypeDocument)
                  ? _loadAssets
                  : _warning,
              child: Icon(
                Icons.image,
                color: theme.hintColor,
              ),
            ),
            InkWell(
              onTap: widget.listDocument.isEmpty ? _openVideo : _warning,
              child: Icon(
                Icons.videocam,
                color: theme.hintColor,
              ),
            ),
            InkWell(
              onTap: widget.listDocument.isEmpty ? _openDocument : _warning,
              child: Icon(
                Icons.file_open_rounded,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
      secondCurve: Curves.easeIn,
      crossFadeState: widget.isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
    );
  }

  _warning() {
    return DxFlushBar.showFlushBar(
      context,
      title: "Ch??? ch???n ???????c T???p ????nh k??m c??ng lo???i !",
      type: FlushBarType.WARNING,
    );
  }

  _start({RecordingStatus? recordingStatus}) async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (recordingStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _recorder.current(channel: 0);
        widget.callBackRecord!(current);
      });
    } catch (e) {
      logger.d(e);
    }
  }

  //record
  Future<bool?> _checkPermission() async {
    try {
      if (await FlutterAudioRecorder2.hasPermissions ?? false) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }
        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
        _recorder = FlutterAudioRecorder2(
          customPath,
          audioFormat: AudioFormat.WAV,
        );

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        // _cubit.updateStatusRecord(
        //     record: current, recordingStatus: current!.status);
        return true;
      } else {
        DxFlushBar.showFlushBar(
          context,
          type: FlushBarType.ERROR,
          message: "B???n c???n c???p quy???n truy c???p micro ????? s??? d???ng ch???c n??ng n??y",
        );
        return false;
      }
    } catch (e) {
      logger.d(e);
    }
    return null;
  }

  //get image
  Future<void> _loadAssets() async {
    if (widget.listDocument.length < 10) {
      if (Platform.isIOS) {
        PermissionStatus permissionPhotosAddOnly = await Permission.photosAddOnly.status;
        PermissionStatus permissionPhoto = await Permission.photos.status;
        if (permissionPhotosAddOnly == PermissionStatus.limited && permissionPhoto == PermissionStatus.limited) {
          ///LIMITED
        } else {
          if (permissionPhoto == PermissionStatus.denied) {
            await Permission.photos.request();
            permissionPhotosAddOnly = await Permission.photos.status;
            if (permissionPhotosAddOnly == PermissionStatus.granted) {
              getAssets(widget.listDocument.length);
            }
          } else {
            if (permissionPhoto == PermissionStatus.permanentlyDenied) {
              await DialogHelper.showAlertSetting(context, "Th??ng b??o",
                  "B???n c???n m??? quy???n cho ph??p truy c???p camera ??? c??i ?????t ????? s??? d???ng t??nh n??ng n??y.");
            } else {
              getAssets(widget.listDocument.length);
            }
          }
        }
      } else {
        getAssets(widget.listDocument.length);
      }
    } else {
      DxFlushBar.showFlushBar(
        context,
        title: "Ch??? ch???n t???i ??a 10 ???nh!",
        type: FlushBarType.WARNING,
      );
    }
  }

  void getAssets(int imageSelected) async {
    List<Asset> resultList = <Asset>[];
    images = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10 - imageSelected,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#AD0000",
          actionBarTitle: "Cu???n camera",
          allViewTitle: "T???t c??? ???nh",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      if (!mounted) return;
      if (resultList.isNotEmpty) {
        images = resultList;
      }
      getFileList();
    } catch (e) {
      logger.e(e);
    }
  }

  void getFileList() async {
    FocusScope.of(context).unfocus();
    if (images.isEmpty) {
      return;
    } else {
      var totalLength = 0;
      List<File> filesPost = <File>[];
      filesPost = [];
      for (int i = 0; i < images.length; i++) {
        var file = await AppUtil.getImageFileFromAssets(images[i]);

        filesPost.add(file);
        totalLength = totalLength + file.lengthSync();
      }
      widget.onChooseImage!(filesPost);
    }
  }

  //get video
  Future<void> _openVideo() async {
    FocusScope.of(context).unfocus();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );

    try {
      if (result != null) {
        List<File> filesList = result.paths.map((path) => File(path!)).toList();
        List<File> check = [];

        if (filesList.isNotEmpty) {
          for (int i = 0; i < filesList.length; i++) {
            if (p.extension(filesList[i].path) != '.mp4' &&
                p.extension(filesList[i].path) != '.MP4' &&
                p.extension(filesList[i].path) != '.mov' &&
                p.extension(filesList[i].path) != '.MOV') {
              DxFlushBar.showFlushBar(
                context,
                type: FlushBarType.ERROR,
                message: "Ch??? h??? tr??? ?????nh d???ng mp4 v?? mov",
              );
            } else {
              check.add(filesList[i]);
            }
          }
          if (check.isNotEmpty) {
            Uint8List? bytes;
            bytes = await VideoThumbnail.thumbnailData(
                video: check[0].path,
                imageFormat: ImageFormat.JPEG,
                maxWidth: (MediaQuery.of(context).size.width).toInt(),
                quality: 40);

            String tempDir;
            getTemporaryDirectory().then((d) async {
              tempDir = d.path;
              File file = await File('$tempDir/THUMBNAIL${DateTime.now().toIso8601String()}.JPEG').writeAsBytes(bytes!);

              widget.onChooseVideo!(check, file);
            });
          } else {
            ///TODO
          }
        }
      } else {}
    } catch (e) {
      logger.d("$e");
      DxFlushBar.showFlushBar(
        context,
        type: FlushBarType.ERROR,
        message: "Update error",
      );
    }
  }

  //get File
  Future<void> _openDocument() async {
    FocusScope.of(context).unfocus();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'PDF',
        'doc',
        'docx',
        'ppsx',
        'pptx',
      ],
    );

    try {
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (files.isNotEmpty) {
          (widget.onChooseDocument!(files));
        } else {
          print('null');
        }
      }
    } catch (e) {
      if (!mounted) return;
      DxFlushBar.showFlushBar(
        context,
        type: FlushBarType.ERROR,
        message: "Update error",
      );
    }
  }
}
