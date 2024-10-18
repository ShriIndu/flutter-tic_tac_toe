import 'package:lottie/lottie.dart';
import 'package:slot_machine_roller/slot_machine_roller.dart';
import 'package:flutter/material.dart';
import 'package:thambolaaaaaaa_test/button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';
import 'dart:math';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 80,
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFFA388EE),
//         title: Row(children: [
//           GestureDetector(
//             onTap: () async {
//               Navigator.pop(context);
//             },
//             child: Card(
//               elevation: 10,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Container(
//                 height: 38,
//                 width: 38,
//                 padding: const EdgeInsets.only(left: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Center(
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.black,
//                     size: 25,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//       body: Stack(children: [
//         Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width),
//         Positioned.fromRect(
//           // left: 5,
//           rect: Rect.fromCenter(
//               center: Offset(
//                 -MediaQuery.of(context).size.width * 0.15,
//                 MediaQuery.of(context).size.height * 0.4,
//               ),
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 50),
//             child: Lottie.asset(
//               'assets/99aWuTlhTFDjso72W8noJgjXAo (2).json',
//               //height: double.infinity,
//               //width: double.infinity,
//               fit: BoxFit.cover,
//               repeat: true,
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
//   late ConfettiController _confettiController;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
//   final AudioPlayer _coinAudioPlayer = AudioPlayer();
//   final AudioPlayer _confettiMusicPlayer =
//       AudioPlayer(); // New player for confetti music

//   var targets = List<int?>.filled(3, null);
//   var tempTargets = List<int?>.filled(3, 7);
//   final Random _random = Random();
//   bool _isRolling = false;
//   bool _isConfettiRunning = false;
//   bool _showCoinsAnimation = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _confettiController =
//         ConfettiController(duration: const Duration(seconds: 5));
//     _startBackgroundMusic();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _audioPlayer.dispose();
//     _confettiController.dispose();
//     _backgroundMusicPlayer.dispose();
//     _coinAudioPlayer.dispose();
//     _confettiMusicPlayer.dispose(); // Dispose confetti music player

//     // Stop background music before disposing
//     _stopBackgroundMusic();

//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       // Stop all audio when the app is paused or about to close
//       _stopAllAudio();
//     } else if (state == AppLifecycleState.resumed) {
//       _startBackgroundMusic();
//     }
//     super.didChangeAppLifecycleState(state);
//   }

//   Future<void> _stopAllAudio() async {
//     await _audioPlayer.stop();
//     await _backgroundMusicPlayer.stop();
//     await _coinAudioPlayer.stop();
//     await _confettiMusicPlayer.stop();
//   }

//   Future<void> _startBackgroundMusic() async {
//     await _backgroundMusicPlayer
//         .setSource(AssetSource('Background - slot-machine.mp3'));
//     await _backgroundMusicPlayer.setVolume(0.5);
//     _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
//     await _backgroundMusicPlayer.resume();
//   }

//   Future<void> _stopBackgroundMusic() async {
//     await _backgroundMusicPlayer.pause(); // Pause the music
//   }

//   Future<void> _playConfettiMusic() async {
//     await _confettiMusicPlayer.setSource(AssetSource(
//         'mixkit-cheering-crowd-loud-whistle-610.wav')); // Add your confetti music file here
//     await _confettiMusicPlayer.setVolume(0.8);
//     _confettiMusicPlayer.setReleaseMode(ReleaseMode.loop); // Loop if needed
//     await _confettiMusicPlayer.resume();
//   }

//   Future<void> _stopConfettiMusic() async {
//     await _confettiMusicPlayer.pause(); // Stop confetti music
//   }

//   Future<void> _playCoinSound() async {
//     await _coinAudioPlayer
//         .setSource(AssetSource('slot-machine-coin-payout-1-188227.mp3'));
//     await _coinAudioPlayer.setVolume(1.0);
//     await _coinAudioPlayer.resume(); // Start playing coin sound
//     await _stopBackgroundMusic(); // Pause background music
//   }

//   Future<void> _stopCoinSound() async {
//     await _coinAudioPlayer.pause(); // Stop coin sound
//   }

//   Future<void> _startRolling() async {
//     setState(() {
//       _isRolling = true;
//       _showCoinsAnimation = false;
//       tempTargets = List<int?>.filled(3, null);
//     });

//     await _audioPlayer
//         .setSource(AssetSource('untitled-made-with-flexclipmp4_ExVvWXVF.wav'));
//     await _audioPlayer.setVolume(1.0);
//     await _audioPlayer.resume(); // Start playing

//     // Stop background music while rolling
//     await _stopBackgroundMusic();

//     // Start the rolling and generate random numbers
//     // int generatedNumber = _random.nextInt(7) + 1;
//     for (int i = 0; i < 3; i++) {
//       await Future.delayed(const Duration(milliseconds: 3000), () {
//         setState(() {
//           // tempTargets[i] = generatedNumber;
//           tempTargets[i] = _random.nextInt(7) + 1;
//         });
//       });
//     }

//     // Stop rolling
//     await Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         targets = List.from(tempTargets);
//         _isRolling = false;
//         print("Results: ${targets.join(', ')}");

//         // Check if all the targets are the same to trigger confetti
//         if (targets.every((element) => element == targets[0])) {
//           _isConfettiRunning = true;
//           _confettiController.play();

//           // Play confetti music and stop background music
//           _playConfettiMusic();
//           _stopBackgroundMusic();

//           Future.delayed(const Duration(seconds: 7), () {
//             setState(() {
//               _isConfettiRunning = false;
//               _showCoinsAnimation = true;
//             });

//             // Start playing the coin sound
//             _playCoinSound();

//             // Hide the coins animation after 2 seconds
//             Future.delayed(const Duration(seconds: 2), () {
//               setState(() {
//                 _showCoinsAnimation = false;
//                 _stopCoinSound(); // Stop the coin sound
//                 _stopConfettiMusic(); // Stop confetti music
//                 _startBackgroundMusic(); // Resume background music
//               });
//             });
//           });
//         } else {
//           _showCoinsAnimation = true;
//           _playCoinSound();
//           Future.delayed(const Duration(seconds: 2), () {
//             setState(() {
//               _showCoinsAnimation = false;
//               _stopCoinSound();
//               _startBackgroundMusic();
//             });
//           });
//         }
//       });
//     });

//     await _audioPlayer.stop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/sparkl_slot_machine.png'),
//                     fit: BoxFit.fill)),
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//               image: AssetImage('assets/slot_machine.png'),
//             )),
//           ),
//           Positioned.fromRect(
//             rect: Rect.fromCenter(
//                 center: MediaQuery.of(context).devicePixelRatio > 3
//                     ? Offset(
//                         MediaQuery.of(context).size.width * 0.43,
//                         MediaQuery.of(context).size.height * 0.67,
//                       )
//                     : Offset(
//                         MediaQuery.of(context).size.width * 0.43,
//                         MediaQuery.of(context).size.height * 0.675,
//                       ),
//                 height: MediaQuery.of(context).size.height * 0.1,
//                 width: MediaQuery.of(context).size.width * 0.53),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 50),
//               child: Lottie.asset(
//                 (_isRolling || _isConfettiRunning || _showCoinsAnimation)
//                     ? 'assets/Grey.json'
//                     : 'assets/uDshBXitCi.json',
//                 fit: BoxFit.cover,
//                 repeat: true,
//               ),
//             ),
//           ),
//           Positioned.fromRect(
//             rect: Rect.fromCenter(
//                 center: Offset(
//                   MediaQuery.of(context).size.width * 0.43,
//                   MediaQuery.of(context).size.height * 0.3,
//                 ),
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 width: MediaQuery.of(context).size.width * 0.53),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 70),
//               child: Transform.rotate(
//                   angle: 0.285398,
//                   child: _showCoinsAnimation
//                       ? Lottie.asset(
//                           'assets/coins_animation.json',
//                           fit: BoxFit.cover,
//                           repeat: true,
//                         )
//                       : SizedBox()),
//             ),
//           ),
//           Center(
//             child: Column(
//               children: [
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     final width = (constraints.maxWidth).clamp(.0, 533.0);
//                     final screenSize = Size(width / 1.5, width / 4.6);
//                     return Stack(
//                       children: [
//                         Transform.translate(
//                           offset: MediaQuery.of(context).devicePixelRatio > 2.99
//                               ? Offset(
//                                   MediaQuery.of(context).size.width * 0.263,
//                                   MediaQuery.of(context).size.height * 0.44,
//                                 )
//                               : Offset(
//                                   MediaQuery.of(context).size.width * 0.25,
//                                   MediaQuery.of(context).size.height * 0.44,
//                                 ),
//                           child: Row(
//                             children: List.generate(
//                               3,
//                               (index) => Container(
//                                 child: SlotMachineRoller(
//                                   height: screenSize.height,
//                                   width:
//                                       MediaQuery.of(context).devicePixelRatio >
//                                               2.99
//                                           ? screenSize.width / 3 - 19
//                                           : screenSize.width / 3 - 20,
//                                   itemBuilder: (number) {
//                                     String imagePath;
//                                     if (number <= 6) {
//                                       imagePath = 'assets/slot$number.png';
//                                     } else {
//                                       imagePath = 'assets/slot$number.png';
//                                     }
//                                     return Image.asset(
//                                       imagePath,
//                                       height: screenSize.height,
//                                       width: MediaQuery.of(context)
//                                                   .devicePixelRatio >
//                                               2.99
//                                           ? 40
//                                           : 50,
//                                       fit: BoxFit.contain,
//                                       package: number <= 6
//                                           ? 'slot_machine_roller'
//                                           : null,
//                                     );
//                                   },
//                                   target: tempTargets[index],
//                                   delay:
//                                       Duration(milliseconds: 250 * (2 - index)),
//                                   reverse: index & 1 > 0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         //  )
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: ConfettiWidget(
//               confettiController: _confettiController,
//               blastDirectionality: BlastDirectionality.explosive,
//               shouldLoop: false,
//               numberOfParticles: 20,
//               colors: const [
//                 Colors.red,
//                 Colors.green,
//                 Colors.blue,
//                 Colors.yellow,
//                 Colors.pink,
//                 Colors.orange,
//                 Colors.purple,
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: MediaQuery.of(context).size.height * 0.24,
//             left: MediaQuery.of(context).size.width * 0.28,
//             right: MediaQuery.of(context).size.width * 0.3,
//             child: GestureDetector(
//               onTap: (_isRolling || _isConfettiRunning) ? null : _startRolling,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent, // Button background color
//                   // borderRadius: BorderRadius.circular(22),
//                   // border: Border.all(
//                   //   color: _isRolling ? Colors.grey : Colors.black,
//                   //   width: 2, // Border width
//                   // ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'SPIN',
//                     style: TextStyle(
//                       // color: (_isRolling || _isConfettiRunning)
//                       //     ? Colors.grey
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(top: 60, right: 15, child: _buildWalletIcon()),
//           Positioned(
//             top: 60,
//             left: 15,
//             child: GestureDetector(
//               onTap: () async {
//                 Navigator.pop(context);
//               },
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: Container(
//                   height: 38,
//                   width: 38,
//                   padding: const EdgeInsets.only(left: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Center(
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       color: Colors.black,
//                       size: 25,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Positioned(
//           //   top: MediaQuery.of(context).size.height * 0.316,
//           //   left: MediaQuery.of(context).size.width * 0.47,
//           //   child: Image.asset(
//           //     'assets/logo.png',
//           //     width: 40,
//           //     height: 40,
//           //     fit: BoxFit.contain,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget imageSelected(int? number, double size) {
//     if (number == null) {
//       return Icon(Icons.question_mark, size: size);
//     }
//     if (number <= 6) {
//       return Image.asset(
//         'assets/slot$number.png',
//         height: size,
//         width: size,
//         package: 'slot_machine_roller',
//       );
//     } else {
//       return Image.asset(
//         'assets/slot$number.png',
//         height: size,
//         width: size,
//       );
//     }
//   }

//   Widget _buildWalletIcon() {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         height: 40,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Theme.of(context).colorScheme.surface,
//           boxShadow: [
//             BoxShadow(
//               color: Theme.of(context).shadowColor,
//               spreadRadius: 1,
//               offset: const Offset(1, 1),
//             ),
//           ],
//           border: Border.all(
//             color: Theme.of(context).colorScheme.secondary,
//             width: 0.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               'assets/coin.png',
//               width: 25,
//               height: 25,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(width: 4),
//             const Text(
//               '100',
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }