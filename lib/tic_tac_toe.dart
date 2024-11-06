import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  bool gameOver = false;
  String result = '';
  bool isGameStarted = false;
  AudioPlayer audioPlayer = AudioPlayer();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      gameOver = false;
      result = '';
      isGameStarted = false;
    });
  }

  void _makeMove(int row, int col) {
    if (board[row][col] == '' && !gameOver && isGameStarted) {
      setState(() {
        board[row][col] = currentPlayer;
        if (currentPlayer == 'X') {
          _playSound('usermove.wav');
        } else {
          _playSound('systemmove.wav');
        }
        if (_checkWinner(row, col)) {
          gameOver = true;
          if (currentPlayer == 'X') {
            result = 'You Won 40 ';
            _confettiController.play();
            _playSound('mixkit-video-game-win-2016.wav');
          } else {
            result = 'You Lost!!!';
            _playSound('lose.wav');
          }
          _showResultDialog(result);
        } else if (_isBoardFull()) {
          gameOver = true;
          result = 'Draw!!!';
          _playSound('draw.wav');
          _showResultDialog(result);
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (currentPlayer == 'O') {
            Future.delayed(Duration(seconds: 2), _cpuMove);
          }
        }
      });
    }
  }

  void _playSound(String path) async {
    await audioPlayer.play(AssetSource(path));
  }

  bool _checkWinner(int row, int col) {
    bool checkLine(List<String> line) =>
        line.every((cell) => cell == currentPlayer);
    return checkLine(board[row]) ||
        checkLine([board[0][col], board[1][col], board[2][col]]) ||
        (row == col && checkLine([board[0][0], board[1][1], board[2][2]])) ||
        (row + col == 2 && checkLine([board[0][2], board[1][1], board[2][0]]));
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell != ''));
  }

  void _cpuMove() {
    if (!_playToWinOrBlock('O') && !_playToWinOrBlock('X')) {
      _playRandomMove();
    }
    currentPlayer = 'X';
  }

  bool _playToWinOrBlock(String player) {
    for (int i = 0; i < 3; i++) {
      if (_tryMove(i, 0, i, 1, i, 2, player) ||
          _tryMove(0, i, 1, i, 2, i, player)) return true;
    }
    return _tryMove(0, 0, 1, 1, 2, 2, player) ||
        _tryMove(0, 2, 1, 1, 2, 0, player);
  }

  bool _tryMove(int r1, int c1, int r2, int c2, int r3, int c3, String player) {
    if (board[r1][c1] == player &&
        board[r2][c2] == player &&
        board[r3][c3] == '') {
      _makeMove(r3, c3);
      return true;
    }
    if (board[r1][c1] == player &&
        board[r3][c3] == player &&
        board[r2][c2] == '') {
      _makeMove(r2, c2);
      return true;
    }
    if (board[r2][c2] == player &&
        board[r3][c3] == player &&
        board[r1][c1] == '') {
      _makeMove(r1, c1);
      return true;
    }
    return false;
  }

  void _playRandomMove() {
    List<int> emptySpots = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          emptySpots.add(i * 3 + j);
        }
      }
    }

    if (emptySpots.isNotEmpty) {
      Random random = Random();
      int index = random.nextInt(emptySpots.length);
      int position = emptySpots[index];
      int row = position ~/ 3;
      int col = position % 3;
      _makeMove(row, col);
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            _resetGame();
            return true;
          },
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Stack(
              children: [
                SizedBox(
                  width: 300,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 30, top: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (result.contains('Won'))
                            const Text(
                              '\nCongratulations!!',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (result.contains('You Lost!!!'))
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'You Lost!!!\n',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '  😢',
                                          style: TextStyle(fontSize: 40),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (result.contains('Draw!!!'))
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    result,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 0),
                                  const Text(
                                    '😐',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (result.contains('Won'))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          Colors.pink,
                          Colors.blue,
                          Colors.green,
                          Colors.yellow,
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 15,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      _resetGame();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Container(
              child: AppBar(
                title: const Text('Tic Tac Toe',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                toolbarHeight: 80,
                leadingWidth: 25,
                backgroundColor: Color.fromARGB(255, 207, 143, 247),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 207, 143, 247),
                      Color.fromARGB(255, 121, 7, 192),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.11,
                    ),
                    Container(
                      child: Column(
                        children: [
                          for (int row = 0; row < 3; row++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int col = 0; col < 3; col++)
                                  GestureDetector(
                                    onTap: isGameStarted && currentPlayer == 'X'
                                        ? () => _makeMove(row, col)
                                        : null,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: row == 0
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: row == 0 ? 0 : 5,
                                          ),
                                          left: BorderSide(
                                            color: col == 0
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: col == 0 ? 0 : 5,
                                          ),
                                          right: BorderSide(
                                            color: col == 2
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: col == 2 ? 0 : 5,
                                          ),
                                          bottom: BorderSide(
                                            color: row == 2
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: row == 2 ? 0 : 5,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: board[row][col] == ''
                                            ? null
                                            : SizedBox(
                                                width: 95.0,
                                                height: 95.0,
                                                child: Image.asset(
                                                  board[row][col] == 'X'
                                                      ? 'assets/X-background.png'
                                                      : 'assets/0-background.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                    if (isGameStarted)
                      SizedBox(
                        width: 250,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            _resetGame();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                22,
                              ),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'End game',
                            style: TextStyle(
                              color: Color.fromARGB(255, 121, 7, 192),
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isGameStarted)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const Text(
                    'Click on Play Button to Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!isGameStarted)
          Positioned(
            bottom: 20,
            left: 40,
            right: 40,
            child: Column(children: [
              SizedBox(
                width: 250,
                height: 60,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isGameStarted = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        22,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Play',
                        style: TextStyle(
                          color: Color.fromARGB(255, 121, 7, 192),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
      ],
    );
  }
}
