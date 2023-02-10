import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mellow_songs/consts/colors.dart';

import 'package:mellow_songs/consts/text_style.dart';
import 'package:mellow_songs/controllers/player_controller.dart';
import 'package:mellow_songs/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerController controller = Get.put(PlayerController());

    List<SongModel> songs = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: AppColor.whiteColor,
            ),
          )
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: AppColor.whiteColor,
        ),
        title: Text(
          "MellowSONGS",
          style: ourStyle(
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Songs Found!",
                style: ourStyle(),
              ),
            );
          } else {
            songs = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListView.builder(
                itemCount: songs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Obx(
                      () => ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: AppColor.bgColor,
                        title: Text(
                          songs[i].displayNameWOExt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ourStyle(
                            size: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          songs[i].artist ?? "No Artist Found.",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ourStyle(fontWeight: FontWeight.w300),
                        ),
                        leading: QueryArtworkWidget(
                          id: songs[i].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: AppColor.whiteColor,
                            size: 32,
                          ),
                        ),
                        onTap: () {
                          controller.playSong(
                            uri: songs[i].uri,
                            index: i,
                            playlist: songs,
                          );
                          Get.to(
                            () => Player(
                              songs: songs,
                            ),
                          );
                        },
                        trailing: controller.playIndex.value == i &&
                                controller.isPlaying.value == true
                            ? const Icon(
                                Icons.play_arrow,
                                color: AppColor.whiteColor,
                                size: 26,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
