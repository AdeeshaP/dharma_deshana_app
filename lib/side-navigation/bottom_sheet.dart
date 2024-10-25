import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class AudioPlayerPopup extends StatefulWidget {
  final List<Map<String, dynamic>> deshanaList;
  final int currentIndex;
  final int realNumber;
  final String firstTappedDeshsnaUrl;
  final Function(int) onCurrentIndexChanged;
  final bool isCurrentlyPlayingFavorite;
  final List<bool> isFavoriteList;
  final Function(int, bool) updateFavoriteStatus;
  final Function(int, bool) toggleFavoriteStatus;

  const AudioPlayerPopup({
    Key? key,
    required this.deshanaList,
    required this.currentIndex,
    required this.realNumber,
    required this.onCurrentIndexChanged,
    required this.isCurrentlyPlayingFavorite,
    required this.isFavoriteList,
    required this.updateFavoriteStatus,
    required this.toggleFavoriteStatus,
    required this.firstTappedDeshsnaUrl,
  }) : super(key: key);

  @override
  _AudioPlayerPopupState createState() => _AudioPlayerPopupState();
}

class _AudioPlayerPopupState extends State<AudioPlayerPopup>
    with WidgetsBindingObserver {
  bool isPlaying = true;
  bool loaded = false;
  int _currentIndex = 0;
  int _realNumber = 0;
  SharedPreferences? _storage;
  List<Map<String, dynamic>> _deshanaList = [];
  List<Map<String, dynamic>> orderedDeshanaList = [];
  List<String>? favoriteIds = [];
  bool _isCurrentlyPlayingFavorite = false;
  late AudioPlayer _audioPlayer;
  AppLifecycleState state = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    initilizePlayer2();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {
      print("App is in the background");
    } else if (state == AppLifecycleState.hidden) {
      print("App is in the hidden");
    } else if (state == AppLifecycleState.detached) {
      print("App is in the detached");
    }
  }

  Future<void> initilizePlayer2() async {
    _storage = await SharedPreferences.getInstance();

    _deshanaList = widget.deshanaList;
    _isCurrentlyPlayingFavorite = widget.isCurrentlyPlayingFavorite;
    _realNumber = widget.realNumber;
    _currentIndex = widget.currentIndex;

    orderedDeshanaList = []
      ..addAll(_deshanaList.sublist(_currentIndex))
      ..addAll(_deshanaList.sublist(0, _currentIndex));

    final _playlist = ConcatenatingAudioSource(children: [
      for (var item in orderedDeshanaList)
        AudioSource.uri(
          Uri.parse(item['deshanaplay'] as String),
          tag: MediaItem(
            id: '${item['id']}',
            title: item['deshananame'] as String,
            artUri: Uri.parse(
                "https://lh3.googleusercontent.com/koLVuGa7wLbmwEWU2Qb4n4vC7DxIdgZkWv77eaqdUDzHg0-HcpHi6qLZXHTXbdNVKkM"), // Placeholder, adjust as necessary
          ),
        ),
    ]);
    await _audioPlayer.setAudioSource(_playlist);
    await _audioPlayer.setLoopMode(LoopMode.all);

    favoriteIds = _storage!.getStringList('favoriteIds') ?? [];

    print("print: favoriteIds in bottom sheet : $favoriteIds");

    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < orderedDeshanaList.length) {
        setState(() {
          _realNumber = orderedDeshanaList[index]['id'];
        });

        print("print: Current playing id is : $_realNumber");

        if (favoriteIds!.contains(_realNumber.toString()) == true) {
          print("print: Adeesha");
          setState(() {
            _isCurrentlyPlayingFavorite = true;
          });
        } else {
          setState(() {
            _isCurrentlyPlayingFavorite = false;
          });
        }
        print(
            "print: status of curent playing fav : $_isCurrentlyPlayingFavorite");
      }
    });

    setState(() {
      loaded = true;
    });

    await _audioPlayer.play();
  }

  void stopMusic() {
    _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
    _audioPlayer.seek(Duration.zero); // Reset progress to 0
  }

  void toggleFavoriteStatus() async {
    _storage = await SharedPreferences.getInstance();

    if (mounted)
      setState(() {
        _isCurrentlyPlayingFavorite = !_isCurrentlyPlayingFavorite;
      });
    print("print: tapped deshana number to make fav : $_realNumber");

    widget.updateFavoriteStatus(
        (806 - _realNumber), _isCurrentlyPlayingFavorite);

    favoriteIds = _storage!.getStringList('favoriteIds') ?? [];
    _isCurrentlyPlayingFavorite == true
        ? favoriteIds!.add((_realNumber).toString())
        : favoriteIds!.remove((_realNumber).toString());

    _storage!.setStringList('favoriteIds', favoriteIds!);
    await _updateFavoriteList();
  }

  Future<void> _updateFavoriteList() async {
    _storage = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> favorites = [];
    for (int i = 0; i < widget.deshanaList.length; i++) {
      if (widget.isFavoriteList[i]) {
        favorites.add(widget.deshanaList[i]);
      }
    }

    String favoritesJson = jsonEncode({"favorites": favorites});
    await _storage!.setString('favorites', favoritesJson);

    List<String> favoriteIds = [];
    for (int i = 0; i < widget.deshanaList.length; i++) {
      if (widget.isFavoriteList[i]) {
        favoriteIds.add(widget.deshanaList[i]['id'].toString());
      }
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
      child: SingleChildScrollView(
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
                    id: metadata.id.toString(),
                  );
                }),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot1) {
                    final Duration duration = loaded
                        ? snapshot1.data as Duration
                        : Duration(seconds: 0);
                    return StreamBuilder(
                        stream: _audioPlayer.bufferedPositionStream,
                        builder: (context, snapshot2) {
                          final Duration bufferedDuration = loaded
                              ? snapshot2.data as Duration
                              : Duration(seconds: 0);
                          return SizedBox(
                            height: 25,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ProgressBar(
                                progress: duration,
                                total: _audioPlayer.duration ??
                                    Duration(seconds: 0),
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
                  ? 15
                  : Responsive.isMobileMedium(context)
                      ? 16
                      : Responsive.isMobileLarge(context)
                          ? 17
                          : Responsive.isTabletPortrait(context)
                              ? 20
                              : 20,
            ),
            // if (state == AppLifecycleState.resumed)
            //   Controls(
            //     audioPlayer: _audioPlayer,
            //     isCurentlyPlayingFavorite: _isCurrentlyPlayingFavorite,
            //     tooglefavStatus: toggleFavoriteStatus,
            //     stopDeshana: stopMusic,
            //     playPrevious: playPrevious,
            //     playNext: playNext2,
            //   )
            // else if (state == AppLifecycleState.paused ||
            //     state == AppLifecycleState.hidden)
            //   Controls(
            //     audioPlayer: _audioPlayer,
            //     isCurentlyPlayingFavorite: _isCurrentlyPlayingFavorite,
            //     tooglefavStatus: toggleFavoriteStatus,
            //     stopDeshana: stopMusic,
            //     playPrevious: _audioPlayer.seekToPrevious,
            //     playNext: _audioPlayer.seekToNext,
            //   )
            Controls(
              audioPlayer: _audioPlayer,
              isCurentlyPlayingFavorite: _isCurrentlyPlayingFavorite,
              tooglefavStatus: toggleFavoriteStatus,
              stopDeshana: stopMusic,
              playPrevious: _audioPlayer.seekToPrevious,
              playNext: _audioPlayer.seekToNext,
            )
          ],
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
    required this.isCurentlyPlayingFavorite,
    required this.tooglefavStatus,
    required this.stopDeshana,
    required this.playPrevious,
    required this.playNext,
  });

  final AudioPlayer audioPlayer;
  final bool isCurentlyPlayingFavorite;
  final Function tooglefavStatus;
  final Function stopDeshana;
  final Function playPrevious;
  final Function playNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            tooglefavStatus();
          },
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
          // onTap: audioPlayer.seekToPrevious,
          onTap: () async {
            playPrevious();
          },
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
          // onTap: audioPlayer.seekToNext,
          onTap: () async {
            playNext();
          },
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
          onPressed: () async {
            stopDeshana();
          },
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
  const MediaMetaData({super.key, required this.title, required this.id});

  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$id.  $title",
        style: GoogleFonts.notoSerif(
          fontSize: Responsive.isMobileSmall(context)
              ? 13.5
              : Responsive.isMobileMedium(context)
                  ? 14
                  : Responsive.isMobileLarge(context)
                      ? 15
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
