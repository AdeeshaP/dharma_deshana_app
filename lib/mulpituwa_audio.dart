// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:niwandakimu_mobile/responsive/responsive.dart';

// class MulpituwaAudioPlayerPopup extends StatefulWidget {
//   // final List<Map<String, dynamic>> deshanaList;
//   final String deshanaurl;
//   // final int currentIndex;
//   final String deshanawa;
//   final bool isCurrentlyPlayingFavorite;

//   const MulpituwaAudioPlayerPopup({
//     Key? key,
//     required this.deshanaurl,
//     required this.deshanawa,
//     required this.isCurrentlyPlayingFavorite,
//   }) : super(key: key);

//   @override
//   _MulpituwaAudioPlayerPopupState createState() =>
//       _MulpituwaAudioPlayerPopupState();
// }

// class _MulpituwaAudioPlayerPopupState extends State<MulpituwaAudioPlayerPopup> {
//   late AudioPlayer _audioPlayer;
//   bool _isPlaying = true;
//   bool loaded = false;
//   int _currentIndex = 0;
//   bool _isCurrentlyPlayingFavorite = false;
//   String _deshanawa = "";

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     initilizePlayer();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> initilizePlayer() async {
//     _deshanawa = widget.deshanawa;
//     _isCurrentlyPlayingFavorite = widget.isCurrentlyPlayingFavorite;
//     final deshana = ConcatenatingAudioSource(children: [
//       AudioSource.uri(
//         Uri.parse(widget.deshanaurl),
//         tag: MediaItem(
//           id: '806',
//           title: widget.deshanawa,
//         ),
//       ),
//     ]);
//     try {
//       // await _audioPlayer.setUrl(widget.deshanaurl);
//       await _audioPlayer.setAudioSource(deshana);

//       setState(() {
//         loaded = true;
//       });
//       await _audioPlayer.play();
//     } on PlayerInterruptedException catch (e) {
//       print(e);
//     }
//   }

//   void _play() async {
//     setState(() {
//       _isPlaying = true;
//     });

//     await _audioPlayer.play();
//   }

//   void _pause() async {
//     setState(() {
//       _isPlaying = false;
//     });
//     _audioPlayer.pause();
//   }

//   void _stop() {
//     _audioPlayer.stop(); // Add this method to stop the audio playback
//     setState(() {
//       _isPlaying = false;
//     });
//     _audioPlayer.seek(Duration.zero);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Colors.white,
//             width: 2.0,
//           ),
//         ),
//         color: Colors.black,
//       ),
//       height: Responsive2.isMobileSmall(context)
//           ? 180
//           : Responsive2.isMobileMedium(context)
//               ? 200
//               : Responsive2.isMobileLarge(context)
//                   ? 200
//                   : Responsive2.isTabletPortrait(context)
//                       ? 220
//                       : 240,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Align(
//             alignment: Alignment.bottomRight,
//             child: IconButton(
//               icon: Icon(Icons.close, color: Colors.amber),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: Text(
//               _deshanawa,
//               style: GoogleFonts.notoSerif(
//                 fontSize: Responsive2.isMobileSmall(context)
//                     ? 13.5
//                     : Responsive2.isMobileMedium(context)
//                         ? 14.5
//                         : Responsive2.isMobileLarge(context)
//                             ? 15.5
//                             : Responsive2.isTabletPortrait(context)
//                                 ? 17
//                                 : 18,
//                 color: Colors.amber,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 15),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: StreamBuilder(
//                 stream: _audioPlayer.positionStream,
//                 builder: (context, snapshot1) {
//                   final Duration duration = loaded
//                       ? snapshot1.data as Duration
//                       : const Duration(seconds: 0);
//                   return StreamBuilder(
//                       stream: _audioPlayer.bufferedPositionStream,
//                       builder: (context, snapshot2) {
//                         final Duration bufferedDuration = loaded
//                             ? snapshot2.data as Duration
//                             : const Duration(seconds: 0);
//                         return SizedBox(
//                           height: 25,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: ProgressBar(
//                               progress: duration,
//                               total:
//                                   _audioPlayer.duration ?? Duration(seconds: 0),
//                               buffered: bufferedDuration,
//                               timeLabelPadding: 2,
//                               timeLabelTextStyle: TextStyle(
//                                   fontSize: Responsive2.isMobileSmall(context)
//                                       ? 13
//                                       : Responsive2.isMobileMedium(context)
//                                           ? 14.5
//                                           : Responsive2.isMobileLarge(context)
//                                               ? 15.5
//                                               : Responsive2.isTabletPortrait(
//                                                       context)
//                                                   ? 18
//                                                   : 22,
//                                   color: Colors.white),
//                               progressBarColor: Colors.amber,
//                               baseBarColor: Colors.grey[200],
//                               bufferedBarColor: Colors.grey[350],
//                               thumbColor: Colors.amber,
//                               onSeek: loaded
//                                   ? (duration) async {
//                                       await _audioPlayer.seek(duration);
//                                     }
//                                   : null,
//                             ),
//                           ),
//                         );
//                       });
//                 }),
//           ),
//           SizedBox(
//             height: Responsive2.isMobileSmall(context)
//                 ? 20
//                 : Responsive2.isMobileMedium(context) ||
//                         Responsive2.isMobileLarge(context)
//                     ? 20
//                     : Responsive2.isTabletPortrait(context)
//                         ? 26
//                         : 28,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 onPressed: () async {},
//                 icon: Icon(
//                   _isCurrentlyPlayingFavorite
//                       ? Icons.favorite
//                       : Icons.favorite_outline,
//                   size: Responsive2.isMobileSmall(context)
//                       ? 27
//                       : Responsive2.isMobileMedium(context) ||
//                               Responsive2.isMobileLarge(context)
//                           ? 30
//                           : Responsive2.isTabletPortrait(context)
//                               ? 35
//                               : 35,
//                   color: Colors.white,
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 23,
//                 backgroundColor: Colors.white,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.black,
//                   radius: 21,
//                   child: IconButton(
//                     onPressed: () async {},
//                     icon: Icon(
//                       Icons.skip_previous,
//                       size: Responsive2.isMobileSmall(context)
//                           ? 25
//                           : Responsive2.isMobileMedium(context)
//                               ? 26
//                               : Responsive2.isMobileLarge(context)
//                                   ? 28
//                                   : Responsive2.isTabletPortrait(context)
//                                       ? 30
//                                       : 32,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: _isPlaying ? _pause : _play,
//                 icon: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: Responsive2.isMobileSmall(context)
//                       ? 30
//                       : Responsive2.isMobileMedium(context) ||
//                               Responsive2.isMobileLarge(context)
//                           ? 35
//                           : Responsive2.isTabletPortrait(context)
//                               ? 40
//                               : 40,
//                   color: Colors.white,
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 23,
//                 backgroundColor: Colors.white,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.black,
//                   radius: 21,
//                   child: IconButton(
//                     onPressed: () async {},
//                     icon: Icon(
//                       Icons.skip_next,
//                       size: Responsive2.isMobileSmall(context)
//                           ? 25
//                           : Responsive2.isMobileMedium(context)
//                               ? 26
//                               : Responsive2.isMobileLarge(context)
//                                   ? 28
//                                   : Responsive2.isTabletPortrait(context)
//                                       ? 30
//                                       : 32,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: _stop,
//                 icon: Icon(
//                   Icons.stop_rounded,
//                   color: Colors.white,
//                   size: Responsive2.isMobileSmall(context)
//                       ? 30
//                       : Responsive2.isMobileMedium(context) ||
//                               Responsive2.isMobileLarge(context)
//                           ? 35
//                           : Responsive2.isTabletPortrait(context)
//                               ? 40
//                               : 40,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   // },
//   // );
//   // }
// }
