module game/turn/turn

pub import game/board/board

import std/os/readline

val synonyms-for-surrender = ["good game", "gg", "forfait", "ff"]
val synonyms-for-draw = ["remis", "draw", "tie"]
val synonyms-for-accept = ["accept", "yes", "y"]
val synonyms-for-reject = ["reject", "no", "n"]

type action
  Move(selected-figure : figure, to : location)
  KingsideCastling(current-player : player)
  QueensideCastling(current-player : player)
  DrawOffer
  Surrender

pub effect fun read-input-draw-offer() : maybe<bool>

pub fun handle-read-input-draw-offer(action : () -> <console, exn, read-input-draw-offer | e> a) : <console, exn | e> a
  with fun read-input-draw-offer()
    val temp = readline()

    if is-empty(temp) then return Nothing

    val input = temp.to-lower

    if is-just(synonyms-for-accept.find(fn(current) current == input)) then return Just(True)
    if is-just(synonyms-for-reject.find(fn(current) current == input)) then return Just(False)

    Nothing

  action()

fun input-draw-offer(current-player : player, invalid-input-warning : string) : <div, console, read-input-draw-offer> bool
  println(current-player.show ++ " offered a draw.")
  print(current-player.opponent.show ++ "'s response: ")

  match read-input-draw-offer()
    Just(x) -> x
    _       ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-draw-offer(current-player, invalid-input-warning)

pub effect board-state
  fun get-board() : board
  fun set-board(new-board : board) : ()

pub fun handle-board-state(initial-state : board, action : () -> <board-state | e> a) : e a
  var current-board-state := initial-state

  with handler
    fun get-board() current-board-state
    fun set-board(new-board) current-board-state := new-board

  action()

fun perform-turn(current-action : action) : board-state ()
  fun change-board(new-figure : figure, removal-condition : (figure) -> bool) : board-state ()
    set-board(Board(Cons(new-figure, get-board().figures.remove(removal-condition))))

  match current-action
    Move(Figure(temp, current-player, current-location), to-location) ->
      fun removal-condition(current : figure) : bool
        current.figure-location == current-location || current.figure-location == to-location

      match temp
        Pawn()              ->
          if to-location == advance-pawn-two-ranks(current-location, current-player)
          then return change-board(Figure(Pawn(True, True), current-player, to-location), removal-condition)

          if to-location == pawn-takes-right(current-location, current-player) &&
            can-pawn-en-passant-right(current-location, get-board(), current-player)
          then return change-board(Figure(Pawn(True, False), current-player, to-location)) fn(current : figure)
            removal-condition(current) || current.figure-location == right-en-passant-target(current-location, current-player)

          if to-location == pawn-takes-left(current-location, current-player) &&
            can-pawn-en-passant-left(current-location, get-board(), current-player)
          then return change-board(Figure(Pawn(True, False), current-player, to-location)) fn(current : figure)
            removal-condition(current) || current.figure-location == left-en-passant-target(current-location, current-player)

          change-board(Figure(Pawn(True, False), current-player, to-location), removal-condition)
          // TODO (Add pawn promotion)
        Rook()              ->
          change-board(Figure(Rook(True), current-player, to-location), removal-condition)
        King()              ->
          change-board(Figure(King(True), current-player, to-location), removal-condition)
        current-figure-type ->
          change-board(Figure(current-figure-type, current-player, to-location), removal-condition)
    KingsideCastling(_current-player)                                 -> () // TODO
    QueensideCastling(_current-player)                                -> () // TODO
    _                                                                 -> ()

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

    if input == "0-0" || input == "O-O" then return Just(KingsideCastling(current-player))
    if input == "0-0-0" || input == "O-O-O" then return Just(QueensideCastling(current-player))
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
        | is-cons(valid-moves(head, current-board).filter(fn(current) validate-input-turn(Move(head, current), current-board))) -> True
        | _                                                                                                                     -> has-valid-moves-by-figure(tail)
      _                                                                                                                         -> False

  has-valid-moves-by-figure(current-board.figures.filter(fn(current) current.figure-player == current-player))

fun validate-input-turn(current-action : action, current-board : board, can-offer-draw : bool = True) : bool
  match current-action
    Move(x, to-location)              ->
      match valid-moves(x, current-board).find(fn(current) current == to-location)
        Just(_) ->
          with handle-board-state(current-board)
          perform-turn(current-action)
          !is-in-check(get-board(), x.figure-player)
        Nothing -> False
    KingsideCastling(current-player)  -> validate-kingside-castling(current-board, current-player)
    QueensideCastling(current-player) -> validate-queenside-castling(current-board, current-player)
    DrawOffer                         -> can-offer-draw
    _                                 -> True

fun input-turn(current-board : board, current-player : player, invalid-input-warning : string, can-offer-draw : bool = True) : <div, console, read-input-turn> action
  print(current-player.show ++ "'s turn: ")

  match read-input-turn(current-player)
    Just(x) | validate-input-turn(x, current-board, can-offer-draw) -> x
    _                                                                               ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-turn(current-board, current-player, invalid-input-warning, can-offer-draw)

fun remove-en-passant(figures : list<figure>, current-player : player) : list<figure>
  match figures
    Cons(Figure(Pawn(x, True), y, z), tail) 
      | y == current-player -> Cons(Figure(Pawn(x, False), y, z), remove-en-passant(tail, current-player))
    Cons(head, tail)        -> Cons(head, remove-en-passant(tail, current-player))
    _                       -> Nil

pub fun turn(current-player : player, can-offer-draw : bool = True) : <div, console, board-state, read-input-turn, read-input-draw-offer> maybe<player>
  println(get-board().show)
  println("")
  
  val current-action = input-turn(get-board(), current-player, "Invalid input!", can-offer-draw)
  println("")

  perform-turn(current-action)

  val current-opponent = current-player.opponent

  match current-action
    Surrender -> Just(current-opponent)
    DrawOffer -> 
      val response = input-draw-offer(current-player, "Invalid input!")
      println("")
      
      if response then Nothing else turn(current-player, False)
    _         ->
      if !has-valid-moves(get-board(), current-opponent) &&
         !validate-kingside-castling(get-board(), current-opponent) &&
         !validate-queenside-castling(get-board(), current-opponent)
      then
        println(get-board().show)
        println("")

        if is-in-check(get-board(), current-opponent) then Just(current-player) else Nothing
      else
        set-board(Board(get-board().figures.remove-en-passant(current-opponent)))
        turn(current-opponent)
