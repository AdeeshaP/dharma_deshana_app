import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:rxdart/rxdart.dart';

class MulpituwaAudioPlayerPopup extends StatefulWidget {
  final String deshanaurl;
  // final int currentIndex;
  final String deshanawa;
  final bool isCurrentlyPlayingFavorite;

  const MulpituwaAudioPlayerPopup({
    Key? key,
    required this.deshanaurl,
    required this.deshanawa,
    required this.isCurrentlyPlayingFavorite,
  }) : super(key: key);

  @override
  _MulpituwaAudioPlayerPopupState createState() =>
      _MulpituwaAudioPlayerPopupState();
}

class _MulpituwaAudioPlayerPopupState extends State<MulpituwaAudioPlayerPopup> {
  late AudioPlayer _audioPlayer;
  // bool _isPlaying = true;
  bool loaded = false;
  // int _currentIndex = 0;
  bool _isCurrentlyPlayingFavorite = false;
  // String _deshanawa = "";

  Stream<PositionData> get _positionedDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (a, b, c) => PositionData(a, b, c ?? Duration.zero),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    initilizePlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> initilizePlayer() async {
    // _deshanawa = widget.deshanawa;
    _isCurrentlyPlayingFavorite = widget.isCurrentlyPlayingFavorite;
    final deshana = ConcatenatingAudioSource(children: [
      AudioSource.uri(
        Uri.parse(widget.deshanaurl),
        tag: MediaItem(
          id: '806',
          title: widget.deshanawa,
          artUri: Uri.parse(
              "https://lh3.googleusercontent.com/koLVuGa7wLbmwEWU2Qb4n4vC7DxIdgZkWv77eaqdUDzHg0-HcpHi6qLZXHTXbdNVKkM"),
        ),
      ),
    ]);
    try {
      // await _audioPlayer.setUrl(widget.deshanaurl);
      await _audioPlayer.setAudioSource(deshana);

      setState(() {
        loaded = true;
      });
      await _audioPlayer.play();
    } on PlayerInterruptedException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        color: Colors.black,
      ),
      height: Responsive.isMobileSmall(context)
          ? 180
          : Responsive.isMobileMedium(context)
              ? 200
              : Responsive.isMobileLarge(context)
                  ? 200
                  : Responsive.isTabletPortrait(context)
                      ? 220
                      : 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.amber),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 2),
          //   child: Text(
          //     _deshanawa,
          //     style: GoogleFonts.notoSerif(
          //       fontSize: Responsive.isMobileSmall(context)
          //           ? 13.5
          //           : Responsive.isMobileMedium(context)
          //               ? 14.5
          //               : Responsive.isMobileLarge(context)
          //                   ? 15.5
          //                   : Responsive.isTabletPortrait(context)
          //                       ? 17
          //                       : 18,
          //       color: Colors.amber,
          //       fontWeight: FontWeight.w500,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          StreamBuilder(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return MediaMetaData(
                  title: metadata.title.toString(),
                );
              }),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StreamBuilder(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot1) {
                  final Duration duration = loaded
                      ? snapshot1.data as Duration
                      : const Duration(seconds: 0);
                  return StreamBuilder(
                      stream: _audioPlayer.bufferedPositionStream,
                      builder: (context, snapshot2) {
                        final Duration bufferedDuration = loaded
                            ? snapshot2.data as Duration
                            : const Duration(seconds: 0);
                        return SizedBox(
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ProgressBar(
                              progress: duration,
                              total:
                                  _audioPlayer.duration ?? Duration(seconds: 0),
                              buffered: bufferedDuration,
                              timeLabelPadding: 2,
                              timeLabelTextStyle: TextStyle(
                                  fontSize: Responsive.isMobileSmall(context)
                                      ? 13
                                      : Responsive.isMobileMedium(context)
                                          ? 14.5
                                          : Responsive.isMobileLarge(context)
                                              ? 15.5
                                              : Responsive.isTabletPortrait(
                                                      context)
                                                  ? 18
                                                  : 22,
                                  color: Colors.white),
                              progressBarColor: Colors.amber,
                              baseBarColor: Colors.grey[200],
                              bufferedBarColor: Colors.grey[350],
                              thumbColor: Colors.amber,
                              onSeek: loaded
                                  ? (duration) async {
                                      await _audioPlayer.seek(duration);
                                    }
                                  : null,
                            ),
                          ),
                        );
                      });
                }),
          ),
          SizedBox(
            height: Responsive.isMobileSmall(context)
                ? 20
                : Responsive.isMobileMedium(context) ||
                        Responsive.isMobileLarge(context)
                    ? 20
                    : Responsive.isTabletPortrait(context)
                        ? 26
                        : 28,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     IconButton(
          //       onPressed: () async {},
          //       icon: Icon(
          //         _isCurrentlyPlayingFavorite
          //             ? Icons.favorite
          //             : Icons.favorite_outline,
          //         size: Responsive.isMobileSmall(context)
          //             ? 27
          //             : Responsive.isMobileMedium(context) ||
          //                     Responsive.isMobileLarge(context)
          //                 ? 30
          //                 : Responsive.isTabletPortrait(context)
          //                     ? 35
          //                     : 35,
          //         color: Colors.white,
          //       ),
          //     ),
          //     CircleAvatar(
          //       radius: 23,
          //       backgroundColor: Colors.white,
          //       child: CircleAvatar(
          //         backgroundColor: Colors.black,
          //         radius: 21,
          //         child: IconButton(
          //           onPressed: () async {},
          //           icon: Icon(
          //             Icons.skip_previous,
          //             size: Responsive.isMobileSmall(context)
          //                 ? 25
          //                 : Responsive.isMobileMedium(context)
          //                     ? 26
          //                     : Responsive.isMobileLarge(context)
          //                         ? 28
          //                         : Responsive.isTabletPortrait(context)
          //                             ? 30
          //                             : 32,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: _isPlaying ? _pause : _play,
          //       icon: Icon(
          //         _isPlaying ? Icons.pause : Icons.play_arrow,
          //         size: Responsive.isMobileSmall(context)
          //             ? 30
          //             : Responsive.isMobileMedium(context) ||
          //                     Responsive.isMobileLarge(context)
          //                 ? 35
          //                 : Responsive.isTabletPortrait(context)
          //                     ? 40
          //                     : 40,
          //         color: Colors.white,
          //       ),
          //     ),
          //     CircleAvatar(
          //       radius: 23,
          //       backgroundColor: Colors.white,
          //       child: CircleAvatar(
          //         backgroundColor: Colors.black,
          //         radius: 21,
          //         child: IconButton(
          //           onPressed: () async {},
          //           icon: Icon(
          //             Icons.skip_next,
          //             size: Responsive.isMobileSmall(context)
          //                 ? 25
          //                 : Responsive.isMobileMedium(context)
          //                     ? 26
          //                     : Responsive.isMobileLarge(context)
          //                         ? 28
          //                         : Responsive.isTabletPortrait(context)
          //                             ? 30
          //                             : 32,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: _stop,
          //       icon: Icon(
          //         Icons.stop_rounded,
          //         color: Colors.white,
          //         size: Responsive.isMobileSmall(context)
          //             ? 30
          //             : Responsive.isMobileMedium(context) ||
          //                     Responsive.isMobileLarge(context)
          //                 ? 35
          //                 : Responsive.isTabletPortrait(context)
          //                     ? 40
          //                     : 40,
          //       ),
          //     ),
          //   ],
          // ),

          Controls(
            audioPlayer: _audioPlayer,
            isCurentlyPlayingFavorite: _isCurrentlyPlayingFavorite,
          ),
        ],
      ),
    );
  }
  // },
  // );
  // }
}

class Controls extends StatelessWidget {
  const Controls(
      {super.key,
      required this.audioPlayer,
      required this.isCurentlyPlayingFavorite});

  final AudioPlayer audioPlayer;
  final bool isCurentlyPlayingFavorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () async {},
          icon: Icon(
            isCurentlyPlayingFavorite ? Icons.favorite : Icons.favorite_outline,
            size: Responsive.isMobileSmall(context)
                ? 27
                : Responsive.isMobileMedium(context) ||
                        Responsive.isMobileLarge(context)
                    ? 28
                    : Responsive.isTabletPortrait(context)
                        ? 35
                        : 35,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: audioPlayer.seekToPrevious,
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 2, color: Colors.white)),
            child: Icon(
              Icons.skip_previous_rounded,
              color: Colors.white,
              size: Responsive.isMobileSmall(context)
                  ? 27
                  : Responsive.isMobileMedium(context) ||
                          Responsive.isMobileLarge(context)
                      ? 30
                      : Responsive.isTabletPortrait(context)
                          ? 35
                          : 35,
            ),
          ),
        ),
        StreamBuilder(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final isPlaying = playerState?.playing;

              if (!(isPlaying ?? false)) {
                return IconButton(
                  onPressed: audioPlayer.play,
                  icon: Icon(Icons.play_arrow),
                  iconSize: Responsive.isMobileSmall(context)
                      ? 30
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? 35
                          : Responsive.isTabletPortrait(context)
                              ? 40
                              : 40,
                  color: Colors.white,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: audioPlayer.pause,
                  icon: Icon(Icons.pause_rounded),
                  iconSize: Responsive.isMobileSmall(context)
                      ? 27
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? 30
                          : Responsive.isTabletPortrait(context)
                              ? 35
                              : 35,
                  color: Colors.white,
                );
              }
              return Icon(
                Icons.pause_rounded,
                size: Responsive.isMobileSmall(context)
                    ? 27
                    : Responsive.isMobileMedium(context) ||
                            Responsive.isMobileLarge(context)
                        ? 30
                        : Responsive.isTabletPortrait(context)
                            ? 35
                            : 35,
                color: Colors.white,
              );
            }),
        GestureDetector(
          onTap: audioPlayer.seekToNext,
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 2, color: Colors.white)),
            child: Icon(
              Icons.skip_next_rounded,
              color: Colors.white,
              size: Responsive.isMobileSmall(context)
                  ? 27
                  : Responsive.isMobileMedium(context) ||
                          Responsive.isMobileLarge(context)
                      ? 30
                      : Responsive.isTabletPortrait(context)
                          ? 35
                          : 35,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.stop_rounded,
            size: Responsive.isMobileSmall(context)
                ? 27
                : Responsive.isMobileMedium(context) ||
                        Responsive.isMobileLarge(context)
                    ? 30
                    : Responsive.isTabletPortrait(context)
                        ? 35
                        : 35,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(this.position, this.buffredPosition, this.duration);

  final Duration position;
  final Duration buffredPosition;
  final Duration duration;
}

class MediaMetaData extends StatelessWidget {
  const MediaMetaData({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        title,
        style: GoogleFonts.notoSerif(
          fontSize: Responsive.isMobileSmall(context)
              ? 13.5
              : Responsive.isMobileMedium(context)
                  ? 14.5
                  : Responsive.isMobileLarge(context)
                      ? 15.5
                      : Responsive.isTabletPortrait(context)
                          ? 17
                          : 18,
          color: Colors.amber,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
