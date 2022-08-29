import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
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

class OptionChat extends StatefulWidget {
  final bool isSelected;
  final Function(List<File>) onChooseImage;
  final Function(List<File>, File) onChooseVideo;
  final Function(List<File>) onChooseDocument;
  final Function(Recording? record) callBackRecord;
  const OptionChat({
    Key? key,
    this.isSelected = false,
    required this.onChooseImage,
    required this.onChooseVideo,
    required this.onChooseDocument,
    required this.callBackRecord,
  }) : super(key: key);

  @override
  State<OptionChat> createState() => _OptionChatState();
}

class _OptionChatState extends State<OptionChat> {
  List<Asset> images = <Asset>[];
  late FlutterAudioRecorder2 _recorder;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(),
      secondChild: Container(
        padding: const EdgeInsets.fromLTRB(68, 16, 68, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: loadAssets,
              child: const Icon(Icons.image),
            ),
            InkWell(
              onTap: _openVideo,
              child: const Icon(Icons.videocam),
            ),
            InkWell(
              onTap: _openDocument,
              child: const Icon(Icons.file_open_rounded),
            ),
            InkWell(
              onTap: () async {
                await _checkPermission().then(
                  (value) {
                    if (value ?? false) {
                      _start(recordingStatus: RecordingStatus.Unset);
                    }
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child: const Icon(Icons.record_voice_over),
              ),
            ),
          ],
        ),
      ),
      secondCurve: Curves.easeIn,
      crossFadeState: widget.isSelected
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
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
        widget.callBackRecord(current);
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
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

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
          message: "Bạn cần cấp quyền truy cập micro để sử dụng chức năng này",
        );
        return false;
      }
    } catch (e) {
      logger.d(e);
    }
    return null;
  }

  //get image
  Future<void> loadAssets() async {
    if (Platform.isIOS) {
      PermissionStatus permissionPhotosAddOnly =
          await Permission.photosAddOnly.status;
      PermissionStatus permissionPhoto = await Permission.photos.status;
      if (permissionPhotosAddOnly == PermissionStatus.limited &&
          permissionPhoto == PermissionStatus.limited) {
        ///LIMITED
      } else {
        if (permissionPhoto == PermissionStatus.denied) {
          await Permission.photos.request();
          permissionPhotosAddOnly = await Permission.photos.status;
          if (permissionPhotosAddOnly == PermissionStatus.granted) {
            getAssets();
          }
        } else {
          if (permissionPhoto == PermissionStatus.permanentlyDenied) {
            await DialogHelper.showAlertSetting(context, "Thông báo",
                "Bạn cần mở quyền cho phép truy cập camera ở cài đặt để sử dụng tính năng này.");
          } else {
            getAssets();
          }
        }
      }
    } else {
      getAssets();
    }
  }

  void getAssets() async {
    List<Asset> resultList = <Asset>[];
    images = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#AD0000",
          actionBarTitle: "Cuộn camera",
          allViewTitle: "Tất cả ảnh",
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

      widget.onChooseImage(filesPost);
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
                message: "Chỉ hỗ trợ định dạng mp4 và mov",
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
              File file = await File(
                      '$tempDir/THUMBNAIL${DateTime.now().toIso8601String()}.JPEG')
                  .writeAsBytes(bytes!);

              widget.onChooseVideo(check, file);
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
      allowedExtensions: ['pdf', 'PDF', 'doc', 'docx', 'ppsx', 'pptx'],
    );

    try {
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (files.isNotEmpty) {
          widget.onChooseDocument(files);
        }
      } else {}
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
