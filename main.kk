module chess-game

import effects-and-handlers/read-input-main-menu
import game/game
import main-menu/main-menu
import main-menu/main-menu-action/main-menu-action

pub fun main() : <div, console, exn> ()
  fun start() : <div, console, exn, read-input-main-menu> ()
    match main-menu()
      NewGameAction -> 
        println("")

        match game(White)
          Just(x) -> println(x.show ++ " wins!")
          _       -> println("Draw!")

        println("")
        start()
      QuitAction    -> ()

  println("Chess game")
  println("")

  with handle-read-input-main-menu
  start()
