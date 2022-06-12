module application/application

import game/board/board
import game/game
import game/game-state/game-state
import game/player/player
import main-menu/main-menu
import main-menu/main-menu-action/main-menu-action

pub fun run(initial-inputs : list<string> = [], initial-should-print : bool = True) : <console, div, exn> ()
  fun start(initial-player : player, inputs : ref<h, list<string>>, should-print : bool) : <console, div, exn, st<h>> ()
    match main-menu(inputs, should-print)
      NewGameAction ->
        if should-print then println("")

        match game(initial-player, inputs, should-print)
          Just(x) -> if should-print then println(x.show ++ " wins!")
          _       -> if should-print then println("Draw!")

        if should-print then println("")
        start(initial-player, inputs, should-print)
      _             -> ()

  if initial-should-print then println("Chess game")
  if initial-should-print then println("")

  start(White, ref(initial-inputs), initial-should-print)
