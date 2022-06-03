module effects-and-handlers/user-input

import std/os/readline

pub effect fun user-input() : string

pub fun read-input(action : () -> <console, exn, user-input | e> a) : <console, exn | e> a
  with fun user-input() readline()
  action()

pub fun simulate-input(inputs : list<string>, action : () -> <console, exn, user-input | e> a) : <console, exn | e> a
  var remaining-inputs : list<string> := inputs

  with fun user-input()
    match remaining-inputs
      Cons(x, xs) ->
        remaining-inputs := xs
        println(x)
        x
      _           -> readline()
  
  action()
