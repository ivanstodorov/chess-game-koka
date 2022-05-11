module effects-and-handlers/board-history

import game/game-state/game-state

pub effect board-history
  fun get-history() : list<game-state>
  fun add-to-history(new-entry : game-state) : ()
  fun clear-history() : ()

pub fun handle-board-history(initial-entry : game-state, action : () -> <board-history | e> a) : e a
  var history : list<game-state> := [initial-entry]

  with handler
    fun get-history() history
    fun add-to-history(new-entry : game-state) history := Cons(new-entry, history)
    fun clear-history() history := Nil
  
  action()
