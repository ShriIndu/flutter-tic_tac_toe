import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SpinMachineController extends GetxController {
  late ConfettiController confettiController;
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer coinAudioPlayer = AudioPlayer();
  final AudioPlayer confettiMusicPlayer = AudioPlayer();

  var targets = List<int?>.filled(3, null).obs;
  var tempTargets = List<int?>.filled(3, 7).obs;
  final Random random = Random();
  var isRolling = false.obs;
  var isConfettiRunning = false.obs;
  var showCoinsAnimation = false.obs;

  void resetGame() {
    isRolling.value = false;
    isConfettiRunning.value = false;
    showCoinsAnimation.value = false;
    tempTargets.value = List<int?>.filled(3, 7);
    targets.value = List<int?>.filled(3, null);
  }

  Future<void> startBackgroundMusic() async {
    await backgroundMusicPlayer
        .setSource(AssetSource('Background - slot-machine (1).mp3'));
    await backgroundMusicPlayer.setVolume(0.03);
    backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundMusicPlayer.resume();
  }

  Future<void> stopBackgroundMusic() async {
    await backgroundMusicPlayer.pause();
  }

  // Future<void> playConfettiMusic() async {
  //   // await confettiMusicPlayer
  //   //     .setSource(AssetSource('mixkit-cheering-crowd-loud-whistle-610.wav'));
  //   // await confettiMusicPlayer.setVolume(0.8);
  //   // confettiMusicPlayer.setReleaseMode(ReleaseMode.loop);
  //   // await confettiMusicPlayer.resume();
  // }

  // Future<void> stopConfettiMusic() async {
  //   await confettiMusicPlayer.pause();
  // }

  Future<void> playCoinSound() async {
    await coinAudioPlayer
        .setSource(AssetSource('slot-machine-coin-payout-1-188227.mp3'));
    await coinAudioPlayer.setVolume(3.0);
    await coinAudioPlayer.resume();
    await stopBackgroundMusic(); // Pause background music
  }

  Future<void> stopCoinSound() async {
    await coinAudioPlayer.pause(); // Stop coin sound
  }

  Future<void> startRolling() async {
    isRolling.value = true;
    showCoinsAnimation.value = false;
    tempTargets.value = List<int?>.filled(3, null);
    await audioPlayer
        .setSource(AssetSource('untitled-made-with-flexclipmp4_ExVvWXVF.wav'));
    await audioPlayer.setVolume(0.05);
    await audioPlayer.resume(); // Start playing

    // Stop background music while rolling
    await stopBackgroundMusic();

    // Start the rolling and generate random numbers
    // int generatedNumber = random.nextInt(7) + 1;
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 3000), () {
        tempTargets[i] = random.nextInt(7) + 1; // Generate random number
        //tempTargets[i] = generatedNumber;
      });
    }

    // Stop rolling
    await Future.delayed(const Duration(seconds: 2), () {
      targets.value = List.from(tempTargets);
      isRolling.value = false;
      print("Results: ${targets.join(', ')}");

      // Check if all the targets are the same to trigger confetti
      if (targets.every((element) => element == targets[0])) {
        isConfettiRunning.value = true;
        confettiController.play();
        startBackgroundMusic();
        // Play confetti music and stop background music
        // playConfettiMusic();
        // stopBackgroundMusic();

        Future.delayed(const Duration(seconds: 7), () {
          isConfettiRunning.value = false;
          showCoinsAnimation.value = true;

          // Start playing the coin sound
          playCoinSound();

          // Hide the coins animation after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            showCoinsAnimation.value = false;
            stopCoinSound(); // Stop the coin sound
            //  stopConfettiMusic(); // Stop confetti music
            startBackgroundMusic(); // Resume background music
          });
        });
      } else {
        showCoinsAnimation.value = true;
        playCoinSound();
        Future.delayed(const Duration(seconds: 2), () {
          showCoinsAnimation.value = false;
          stopCoinSound();
          startBackgroundMusic();
        });
      }
    });

    await audioPlayer.stop();
  }

  Future<void> stopAllAudio() async {
    await audioPlayer.stop();
    await backgroundMusicPlayer.stop();
    await coinAudioPlayer.stop();
    await confettiMusicPlayer.stop();
  }
}
