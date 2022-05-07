module game/turn/turn

pub import game/board/board

import std/os/readline

val synonyms-for-draw = ["stalemate", "draw", "tie"]
val synonyms-for-surrender = ["good game", "gg", "forfait", "ff"]

type action
  Move(from : location, to : location)
  KingsideCastling
  QueensideCastling
  DrawOffer
  Surrender

pub effect fun perform-turn(current-action : action, current-board : board, current-player : player) : either<player, maybe<player>>

pub fun handle-perform-turn(action : () -> <perform-turn | e> a) : e a
  with fun perform-turn(current-action, current-board, current-player)
    match current-action
      // Move(from-location, to-location) ->
      // KingsideCastling                 ->
      // QueensideCastling                ->
      // DrawOffer                        ->
      Surrender                        -> Right(Just(current-player.opponent))
      _                                -> Left(opponent(current-player)) // REMOVE when all of the above are done

  action()

pub effect fun read-input-turn() : maybe<action>

pub fun handle-read-input-turn(action : () -> <console, exn, read-input-turn | e> a) : <console, exn | e> a
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

  with fun read-input-turn()
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
          ((Just(q), Just(r)), (Just(s), Just(t))) -> Just(Move((q, r), (s, t)))
          _                                        -> Nothing
      _                                       -> Nothing

  action()

fun validate-input-turn(current-action : action, current-board : board, current-player : player) : bool
  match current-action
    Move(from-location, _to-location) ->
      match find-figure(current-board, from-location, Just(current-player))
        Just(_) -> True // Validate the move separately for different possible figures
        Nothing -> False
    KingsideCastling                  -> False
    QueensideCastling                 -> False
    _                                 -> True

fun input-turn(current-board : board, current-player : player, invalid-input-warning : string) : <div, console, read-input-turn> action
  print(current-player.show ++ "'s turn: ")

  match read-input-turn()
    Just(x) | validate-input-turn(x, current-board, current-player) -> x
    _                                                               ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-turn(current-board, current-player, invalid-input-warning)

pub fun turn(current-board : board, current-player : player) : <div, console, perform-turn, read-input-turn> maybe<player>
  println(current-board.show)
  println("")
  
  val current-action = input-turn(current-board, current-player, "Invalid input!")
  println("")

  match perform-turn(current-action, current-board, current-player)
    Left(x)  -> turn(current-board, x)
    Right(x) -> x
