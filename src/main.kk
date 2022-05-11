module chess-game

import effects-and-handlers/board-history
import effects-and-handlers/board-state
import effects-and-handlers/read-input-draw-offer
import effects-and-handlers/read-input-main-menu
import effects-and-handlers/read-input-pawn-promotion
import effects-and-handlers/read-input-turn
import effects-and-handlers/show-board
import game/board/board
import game/game
import game/game-state/game-state
import game/player/player
import main-menu/main-menu
import main-menu/main-menu-action/main-menu-action

pub fun main() : <console, div, exn> ()
  fun start(initial-player : player) : <board-history, board-state, console, div, read-input-draw-offer, read-input-main-menu, read-input-pawn-promotion, read-input-turn, show-board> ()
    match main-menu()
      NewGameAction -> 
        println("")

        match game(initial-player)
          Just(x) -> println(x.show ++ " wins!")
          _       -> println("Draw!")

        println("")
        start(initial-player)
      _             -> ()

  println("Chess game")
  println("")

  val initial-player : player = White

  with handle-board-state(Board())
  with handle-board-history(Game-state(initial-player, get-board(), False, False, False, False))
  with handle-show-board
  with handle-read-input-main-menu
  with handle-read-input-turn
  with handle-read-input-pawn-promotion
  with handle-read-input-draw-offer
  start(initial-player)
