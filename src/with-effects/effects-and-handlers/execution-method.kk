module effects-and-handlers/execution-method

import std/os/readline

pub effect execution-method
  fun user-input() : string
  fun custom-print(x : string) : ()
  fun custom-println(x : string) : ()

pub fun normal-game(action : () -> <console, execution-method, exn | e> a) : <console, exn | e> a
  with handler
    fun user-input() readline()
    fun custom-print(x) print(x)
    fun custom-println(x) println(x)

  action()

pub fun simulation-with-printing(inputs : list<string>, action : () -> <console, execution-method, exn | e> a) : <console, exn | e> a
  var remaining-inputs : list<string> := inputs

  with handler
    fun user-input()
      match remaining-inputs
        Cons(x, xs) ->
          remaining-inputs := xs
          println(x)
          x
        _           -> readline()
    fun custom-print(x) print(x)
    fun custom-println(x) println(x)

  action()

pub fun simulation-without-printing(inputs : list<string>, action : () -> <console, execution-method, exn | e> a) : <console, exn | e> a
  var remaining-inputs : list<string> := inputs

  with handler
    fun user-input()
      match remaining-inputs
        Cons(x, xs) ->
          remaining-inputs := xs
          x
        _           -> readline()
    fun custom-print(_) ()
    fun custom-println(_) ()

  action()
