module effects-and-handlers/board-state

import game/board/board

pub effect board-state
  fun get-board() : board
  fun set-board(new-board : board) : ()

pub fun handle-board-state(initial-state : board, action : () -> <board-state | e> a) : e a
  var current-board-state := initial-state

  with handler
    fun get-board() current-board-state
    fun set-board(new-board) current-board-state := new-board

  action()
