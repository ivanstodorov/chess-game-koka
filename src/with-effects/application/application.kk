module application/application

import effects-and-handlers/execution-method
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

pub fun run() : <div, execution-method, exn> ()
  fun start(initial-player : player) : <div, execution-method, exn> ()
    with handle-read-input-main-menu
    match main-menu()
      NewGameAction -> 
        custom-println("")

        with handle-show-board
        with handle-read-input-turn
        with handle-read-input-pawn-promotion
        with handle-read-input-draw-offer
        match game(initial-player)
          Just(x) -> custom-println(x.show ++ " wins!")
          _       -> custom-println("Draw!")

        custom-println("")
        start(initial-player)
      _             -> ()

  custom-println("Chess game")
  custom-println("")

  start(White)
