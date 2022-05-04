module chess-game

import game/game
import main-menu/main-menu

pub fun main() : <console, exn, div> ()
  println("Chess game")
  println("")

  match main-menu()
    NewGameAction -> 
      println("")

      match game()
        Just(White) -> println("White player wins!")
        Just(Black) -> println("Black player wins!")
        _           -> println("Draw!")

    QuitAction    -> return ()
