module game/turn/turn

pub import game/board/board

import std/os/readline

pub effect fun perform-action-turn(current-board : board, current-player : player) : either<player, maybe<player>>

pub fun handle-perform-action-turn(action : () -> <perform-action-turn | e> a) : e a
  with fun perform-action-turn(current-board, current-player)
    // Implement the handler for performing an action
    Left(opponent(current-player))

  action()

pub effect fun read-location() : maybe<location>

pub fun handle-read-location(action : () -> <console, exn, read-location | e> a) : <console, exn | e> a
  fun validate-input(x : string) : maybe<location>
    fun parse-row(row : char) : maybe<int>
      match row
        '1' -> Just(7)
        '2' -> Just(6)
        '3' -> Just(5)
        '4' -> Just(4)
        '5' -> Just(3)
        '6' -> Just(2)
        '7' -> Just(1)
        '8' -> Just(0)
        _   -> Nothing

    fun parse-column(column : char) : maybe<int>
      match column
        'a' -> Just(0)
        'b' -> Just(1)
        'c' -> Just(2)
        'd' -> Just(3)
        'e' -> Just(4)
        'f' -> Just(5)
        'g' -> Just(6)
        'h' -> Just(7)
        _   -> Nothing
    
    if is-empty(x) then return Nothing

    match list(x.to-lower)
      Cons(y, (Cons(z, Nil))) ->
        match (parse-row(z), parse-column(y))
          (Just(m), Just(n)) -> Just((m, n))
          _                  -> Nothing
      _                       -> Nothing

  with fun read-location()
    validate-input(readline())

  action()

fun input-location(input-label : string, invalid-input-warning : string, predicate : (location) -> bool = fn(_) True) : <div, console, read-location> location
  print(input-label ++ ": ")

  match read-location()
    Just(x) | predicate(x) -> x
    _                      ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-location(input-label, invalid-input-warning, predicate)

fun check-source(current-board : board, current-player : player) : ((location) -> bool)
  fn(source : location) : bool
    match find-figure(current-board, source, Just(current-player))
      Just(_) -> True
      _       -> False

pub fun turn(current-board : board, current-player : player) : <div, console, perform-action-turn, read-location> maybe<player>
  println(current-board.show)
  println("")
  println(current-player.show ++ "'s turn")
  println("")

  val source = input-location("Source", "Invalid input!", check-source(current-board, current-player))
  println("")

  match perform-action-turn(current-board, current-player)
    Left(x)  -> turn(current-board, x)
    Right(x) -> x
