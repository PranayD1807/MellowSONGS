import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mellow_songs/consts/colors.dart';
import 'package:mellow_songs/consts/text_style.dart';
import 'package:mellow_songs/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  const Player({super.key, required this.songs});
  final List<SongModel> songs;
  @override
  Widget build(BuildContext context) {
    PlayerController controller = Get.find<PlayerController>();

    return Stack(
      children: [
        Obx(
          () => Expanded(
            child: QueryArtworkWidget(
              id: songs[controller.playIndex.value].id,
              type: ArtworkType.AUDIO,
              artworkHeight: double.maxFinite,
              artworkWidth: double.maxFinite,
              nullArtworkWidget: Container(
                color: AppColor.bgColor,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: AppColor.bgDarkColor.withOpacity(0.75),
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Obx(
                  () => Expanded(
                      child: Container(
                    height: 300,
                    width: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: QueryArtworkWidget(
                      id: songs[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.maxFinite,
                      artworkWidth: double.maxFinite,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        size: 48,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 12),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    // color: AppColor.whiteColor,
                  ),
                  child: Obx(
                    () => Column(children: [
                      Text(
                        songs[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: AppColor.whiteColor,
                          size: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${songs[controller.playIndex.value].artist}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: AppColor.whiteColor.withOpacity(0.8),
                          size: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(color: AppColor.whiteColor),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: AppColor.sliderColor,
                                inactiveColor: AppColor.whiteColor,
                                activeColor: AppColor.sliderColor,
                                value: controller.value.value,
                                max: controller.max.value,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                onChanged: (val) {
                                  controller
                                      .changeDurationToSeconds(val.toInt());
                                  val = val;
                                  if (controller.max.value ==
                                      controller.value.value) {
                                    log("NEXT");
                                    controller.playSong(
                                      uri: songs[controller.playIndex.value + 1]
                                          .uri,
                                      index: controller.playIndex.value + 1,
                                      playlist: songs,
                                    );
                                  }
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: AppColor.whiteColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: controller.playIndex.value != 0
                                  ? () {
                                      controller.playSong(
                                        uri: songs[
                                                controller.playIndex.value - 1]
                                            .uri,
                                        index: controller.playIndex.value - 1,
                                        playlist: songs,
                                      );
                                    }
                                  : null,
                              icon: Transform.scale(
                                scale: 1.5,
                                child: const Icon(
                                  Icons.skip_previous_rounded,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ),
                            Obx(
                              () => Transform.scale(
                                scale: 1.5,
                                child: CircleAvatar(
                                  backgroundColor: AppColor.whiteColor,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value) {
                                        controller.audioPlayer.pause();
                                        controller.isPlaying(false);
                                      } else {
                                        controller.audioPlayer.play();
                                        controller.isPlaying(true);
                                      }
                                    },
                                    icon: controller.isPlaying.value
                                        ? const Icon(
                                            Icons.pause,
                                            color: AppColor.bgColor,
                                          )
                                        : const Icon(
                                            Icons.play_arrow_rounded,
                                            color: AppColor.bgColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: controller.playIndex.value !=
                                      songs.length - 1
                                  ? () {
                                      controller.playSong(
                                        uri: songs[
                                                controller.playIndex.value + 1]
                                            .uri,
                                        index: controller.playIndex.value + 1,
                                        playlist: songs,
                                      );
                                    }
                                  : null,
                              icon: Transform.scale(
                                scale: 1.5,
                                child: const Icon(
                                  Icons.skip_next_rounded,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
