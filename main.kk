module chess-game

import game/game
import main-menu/main-menu

pub fun main() : <div, console, exn> ()
  fun start() : <div, console, exn> ()
    match main-menu()
      NewGameAction -> 
        println("")

        match game()
          Just(White) -> println("White player wins!")
          Just(Black) -> println("Black player wins!")
          _           -> println("Draw!")

        println("")
        start()
      QuitAction    -> ()

  println("Chess game")
  println("")

  start()
