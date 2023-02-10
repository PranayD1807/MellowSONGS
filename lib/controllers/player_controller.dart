import 'dart:developer';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  RxInt playIndex = 0.obs;
  RxBool isPlaying = false.obs;
  RxDouble max = 0.0.obs;
  RxDouble value = 0.0.obs;
  RxString duration = ''.obs;
  RxString position = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  autoPlayNext(List songs) {
    audioPlayer.positionStream.listen((p) {
      if (p.compareTo(audioPlayer.duration ?? const Duration(seconds: 1)) ==
          0) {
        if (songs.length - 1 == playIndex.value) {
          return;
        }
        playSong(
          uri: songs[playIndex.value + 1].uri,
          index: playIndex.value + 1,
          playlist: songs,
        );
      }
    });
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playSong({String? uri, required int index, required playlist}) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();

      isPlaying(true);
      updatePosition();
      autoPlayNext(playlist);
    } on Exception catch (e) {
      // TODO
      print(e.toString());
    }
  }

  void checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      return;
    } else {
      checkPermission();
    }
  }
}
