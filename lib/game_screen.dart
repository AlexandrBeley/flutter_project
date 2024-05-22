import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  String player1;
  String player2;
  GameScreen({required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;
  @override
  void initState() {
   super.initState();
   _board = List.generate(3, (_) => List.generate(3, (_) =>""));
   _currentPlayer = "X";
   _winner = "";
   _gameOver = false;
  }

  void _resetGame(){
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) =>""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }
  void _makeMove(int x, int y) {
    if(_gameOver || _board[x][y] != "") {
      return;
    }
    setState(() {
      _board[x][y] = _currentPlayer;
      if((_board[x][0] == _board[x][1] && _board[x][2] == _board[x][1] && _board[x][0] != "") ||
          (_board[0][y] == _board[1][y] && _board[2][y] == _board[1][y] && _board[0][y] != "")) {
        _winner = _board[x][y];
        _gameOver = true;
      }
      if((_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2] && _board[1][1] != "") || 
          (_board[2][0] == _board[1][1] && _board[1][1] == _board[0][2] && _board[1][1] != "")) {
        _winner = _board[1][1];
        _gameOver = true;
      }

      if(_currentPlayer == "X") {
        _currentPlayer = "O";
      }
      else {
        _currentPlayer = "X";
      }

      if(!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a tie";
      }
      if(_winner != "") {
        String _txt = _winner;
        if(_winner == "X") {
          _winner = widget.player1;
          _txt = _winner + " Won!";
        } else if(_winner == "O") {
          _winner = widget.player2 + " Won!";
          _txt = _winner + " Won!";
        }
        AwesomeDialog(context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        btnOkText: "Play Again",
        title: _txt,
        btnOkOnPress: (){
          _resetGame();
        })..show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF323D5B),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 70),
          SizedBox(
            height: 120,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Turn: ", 
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _currentPlayer == "X" 
                        ? widget.player1 + " ($_currentPlayer)" 
                        : widget.player2 + " ($_currentPlayer)",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: _currentPlayer == "X" ? Color(0xFFE25041) : Color(0xFF1CBD9E)),
                  ),
                ],
              ),
              SizedBox(height: 20), 
            ],),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF5F6B84),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(5),
            child: GridView.builder(
              itemCount: 9,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                int x = index ~/3;
                int y = index % 3;
                return GestureDetector(
                  onTap: ()=>_makeMove(x,y),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF0E1E3A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(_board[x][y],
                      style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: _board[x][y] == "X" ? Color(0xFFE25041) : Color(0xFF1CBD9E)
                      ),),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: _resetGame,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Text(
                    "Reset Game",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],),
      )
    );
  }

}