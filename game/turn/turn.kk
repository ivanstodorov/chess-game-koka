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
  fun set-board(new-board : board) : ()

pub fun handle-board-state(initial-state : board, action : () -> <board-state | e> a) : e a
  var current-board-state := initial-state

  with handler
    fun get-board() current-board-state
    fun set-board(new-board) current-board-state := new-board

  action()

fun perform-turn(current-action : action, current-player : player) : board-state ()
  val current-opponent = current-player.opponent

  match current-action
    Move(Figure(x, y, z), to-location) -> set-board(Board(Cons(Figure(x, y, to-location), get-board().figures.remove(fn(current) current.figure-location == z || current.figure-location == to-location))))
    KingsideCastling                   -> () // TODO
    QueensideCastling                  -> () // TODO
    _                                  -> ()

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

fun validate-kingside-castling(current-board : board, current-player : player) : bool
  False // TODO

fun validate-queenside-castling(current-board : board, current-player : player) : bool
  False // TODO

fun is-in-check(current-board : board, current-player : player) : bool
  match current-board.figures.find(fn(current) current.figure-type == King() && current.figure-player == current-player)
    Just(Figure(_, _, current-location)) -> is-threatened(current-location, current-board, current-player.opponent)
    Nothing                              -> False

fun has-valid-moves(current-board : board, current-player : player) : bool
  fun has-valid-moves-by-figure(current-figures : list<figure>) : bool
    match current-figures
      Cons(head, tail)
        | is-cons(valid-moves(head, current-board).filter(fn(current) validate-input-turn(Move(head, current), current-board, current-player))) -> True
        | _                                                                                                                                     -> has-valid-moves-by-figure(tail)
      _                                                                                                                                         -> False

  has-valid-moves-by-figure(current-board.figures.filter(fn(current) current.figure-player == current-player))

fun validate-input-turn(current-action : action, current-board : board, current-player : player) : bool
  match current-action
    Move(x, to-location) ->
      match valid-moves(x, current-board).find(fn(current) current == to-location)
        Just(_) ->
          with handle-board-state(current-board)
          perform-turn(current-action, current-player)
          !is-in-check(get-board(), current-player)
        Nothing -> False
    KingsideCastling     -> validate-kingside-castling(current-board, current-player)
    QueensideCastling    -> validate-queenside-castling(current-board, current-player)
    _                    -> True

fun input-turn(current-board : board, current-player : player, invalid-input-warning : string) : <div, console, read-input-turn> action
  print(current-player.show ++ "'s turn: ")

  match read-input-turn(current-player)
    Just(x) | validate-input-turn(x, current-board, current-player) -> x
    _                                                               ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-turn(current-board, current-player, invalid-input-warning)

pub fun turn(current-player : player) : <div, console, board-state, read-input-turn> maybe<player>
  println(get-board().show)
  println("")
  
  val current-action = input-turn(get-board(), current-player, "Invalid input!")
  println("")

  perform-turn(current-action, current-player)

  val current-opponent = current-player.opponent

  match current-action
    Surrender -> Just(current-opponent)
    DrawOffer -> turn(current-opponent) // TODO
    _         ->
      if !has-valid-moves(get-board(), current-opponent) &&
         !validate-kingside-castling(get-board(), current-opponent) &&
         !validate-queenside-castling(get-board(), current-opponent)
      then
        println(get-board().show)
        println("")

        if is-in-check(get-board(), current-opponent) then Just(current-player) else Nothing
      else
        turn(current-opponent)
