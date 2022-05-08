module game/turn/turn

pub import game/board/board

import std/os/readline

val synonyms-for-draw = ["stalemate", "draw", "tie"]
val synonyms-for-surrender = ["good game", "gg", "forfait", "ff"]

type action
  Move(selected-figure : figure, to : location)
  KingsideCastling
  QueensideCastling
  DrawOffer
  Surrender

pub effect board-state
  fun get-board() : board
  fun perform-turn(current-action : action, current-player : player) : either<player, maybe<player>>

pub fun handle-board-state(initial-state : board, action : () -> <board-state | e> a) : e a
  var current-board-state := initial-state

  with handler
    fun get-board() current-board-state

    fun perform-turn(current-action, current-player)
      match current-action
        Move(Figure(x, y, z), to-location) ->
          current-board-state := Board(Cons(Figure(x, y, to-location), current-board-state.figures.remove(fn(current) current.figure-location == z || current.figure-location == to-location)))
          Left(current-player.opponent) // TODO (Checkmate?)
        KingsideCastling                   -> Left(current-player.opponent) // TODO
        QueensideCastling                  -> Left(current-player.opponent) // TODO
        DrawOffer                          -> Left(current-player.opponent) // TODO
        Surrender                          -> Right(Just(current-player.opponent))

  action()

pub effect fun read-input-turn(current-player : player) : maybe<action>

pub fun handle-read-input-turn(action : () -> <console, exn, board-state, read-input-turn | e> a) : <console, exn, board-state | e> a
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

  with fun read-input-turn(current-player)
    val temp = readline()

    if is-empty(temp) then return Nothing

    val input = temp.to-lower

    if input == "0-0" || input == "O-O" then return Just(KingsideCastling)
    if input == "0-0-0" || input == "O-O-O" then return Just(QueensideCastling)
    if is-just(synonyms-for-draw.find(fn(current) current == input)) then return Just(DrawOffer)
    if is-just(synonyms-for-surrender.find(fn(current) current == input)) then return Just(Surrender)

    match list(input)
      Cons(m, Cons(n, Cons(o, Cons(p, Nil)))) ->
        match ((parse-row(n), parse-column(m)), (parse-row(p), parse-column(o)))
          ((Just(q), Just(r)), (Just(s), Just(t))) -> 
            match find-figure(get-board(), (q, r), Just(current-player))
              Just(x) -> Just(Move(x, (s, t)))
              Nothing -> Nothing
          _                                        -> Nothing
      _                                       -> Nothing

  action()

fun validate-input-turn(current-action : action, current-player : player) : board-state bool
  match current-action
    Move(x, to-location) ->
      match valid-moves(x, get-board()).find(fn(current) current == to-location)
        Just(_) -> True // TODO (Is the king in check?)
        Nothing -> False
    KingsideCastling                  -> False // TODO
    QueensideCastling                 -> False // TODO
    _                                 -> True

fun input-turn(current-player : player, invalid-input-warning : string) : <div, console, read-input-turn, board-state> action
  fun handle-invalid-input() : <div, console, read-input-turn, board-state> action
    println("\n" ++ invalid-input-warning ++ "\n")
    input-turn(current-player, invalid-input-warning)

  print(current-player.show ++ "'s turn: ")

  match read-input-turn(current-player)
    Just(x) -> if validate-input-turn(x, current-player) then x else handle-invalid-input()
    _       -> handle-invalid-input()

pub fun turn(current-player : player) : <div, console, board-state, read-input-turn> maybe<player>
  println(get-board().show)
  println("")
  
  val current-action = input-turn(current-player, "Invalid input!")
  println("")

  match perform-turn(current-action, current-player)
    Left(x)  -> turn(x)
    Right(x) -> x
