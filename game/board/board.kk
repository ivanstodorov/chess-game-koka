module game/board/board

import game/board/location/location
import game/figure/figure
import game/figure/figure-type/figure-type
import game/player/player

pub val board-rows = 8
pub val board-columns = 8

type direction
  North
  NorthEast
  East
  SouthEast
  South
  SouthWest
  West
  NorthWest

pub struct board
  figures : list<figure> = [Figure(Rook(), Black, (0, 7)), Figure(Knight, Black, (1, 7)), Figure(Bishop, Black, (2, 7)), Figure(Queen, Black, (3, 7)),
                            Figure(King(), Black, (4, 7)), Figure(Bishop, Black, (5, 7)), Figure(Knight, Black, (6, 7)), Figure(Rook(), Black, (7, 7)),
                            Figure(Pawn(), Black, (0, 6)), Figure(Pawn(), Black, (1, 6)), Figure(Pawn(), Black, (2, 6)), Figure(Pawn(), Black, (3, 6)),
                            Figure(Pawn(), Black, (4, 6)), Figure(Pawn(), Black, (5, 6)), Figure(Pawn(), Black, (6, 6)), Figure(Pawn(), Black, (7, 6)),
                            Figure(Pawn(), White, (0, 1)), Figure(Pawn(), White, (1, 1)), Figure(Pawn(), White, (2, 1)), Figure(Pawn(), White, (3, 1)),
                            Figure(Pawn(), White, (4, 1)), Figure(Pawn(), White, (5, 1)), Figure(Pawn(), White, (6, 1)), Figure(Pawn(), White, (7, 1)),
                            Figure(Rook(), White, (0, 0)), Figure(Knight, White, (1, 0)), Figure(Bishop, White, (2, 0)), Figure(Queen, White, (3, 0)),
                            Figure(King(), White, (4, 0)), Figure(Bishop, White, (5, 0)), Figure(Knight, White, (6, 0)), Figure(Rook(), White, (7, 0))]

pub fun (==)(x : board, y : board) : bool
  fun helper(xs : list<figure>, ys : list<figure>) : bool
    match xs
      Cons(head, tail)         ->
        match find-figure(Board(ys), head.figure-location, Just(head.figure-player))
          Just(z) | z === head -> helper(tail, ys.remove(fn(current) current === z))
          _                    -> False
      _                        -> is-nil(ys)

  helper(x.figures, y.figures)

pub fun find-figure(current-board : board, target-location : location, current-player : maybe<player> = Nothing) : maybe<figure>
  fun helper(xs : list<figure>) : maybe<figure>
    match xs
      Cons(y, ys)
        | y.figure-location == target-location ->
          match current-player
            Just(z)
              | y.figure-player == z -> Just(y)
              | _                    -> helper(ys)
            _                        -> Just(y)
        | _                                    -> helper(ys)
      _                                        -> Nothing

  helper(current-board.figures)

pub fun valid-moves(current-figure : figure, current-board : board) : list<location>
  fun validate-location(x : location) : bool
    0 <= x.fst && x.fst < board-columns && 0 <= x.snd && x.snd < board-rows && is-nothing(find-figure(current-board, x, Just(current-figure.figure-player)))

  fun move(x : location, move-direction : direction) : list<location>
    var result := Nil

    for-while(1, board-rows - 1) fn(i)
      val current = match move-direction
        North     -> (x.fst, x.snd + i)
        NorthEast -> (x.fst + i, x.snd + i)
        East      -> (x.fst + i, x.snd)
        SouthEast -> (x.fst + i, x.snd - i)
        South     -> (x.fst, x.snd - i)
        SouthWest -> (x.fst - i, x.snd - i)
        West      -> (x.fst - i, x.snd)
        NorthWest -> (x.fst - i, x.snd + i)

      if !validate-location(current) return Just(())

      match find-figure(current-board, current)
        Just(Figure(_, current-player, _)) ->
          if current-player != current-figure.figure-player then result := Cons(current, result)
          Just(())
        _                                  ->
          result := Cons(current, result)
          Nothing

    result

  match current-figure
    Figure(Pawn(has-moved, _), current-player, current-location) ->
      var result := [advance-pawn-one-rank(current-location, current-player)]

      if !has-moved
      then result := Cons(advance-pawn-two-ranks(current-location, current-player), result)
      
      if can-pawn-take-right(current-location, current-board, current-player) ||
          can-pawn-en-passant-right(current-location, current-board, current-player)
      then result := Cons(pawn-takes-right(current-location, current-player), result)
      
      if can-pawn-take-left(current-location, current-board, current-player) ||
          can-pawn-en-passant-left(current-location, current-board, current-player) 
      then result := Cons(pawn-takes-left(current-location, current-player), result)

      filter(result, validate-location)
    Figure(Knight,             _,              current-location) ->
      filter([(current-location.fst + 1, current-location.snd + 2),
              (current-location.fst + 2, current-location.snd + 1),
              (current-location.fst + 2, current-location.snd - 1),
              (current-location.fst + 1, current-location.snd - 2),
              (current-location.fst - 1, current-location.snd - 2),
              (current-location.fst - 2, current-location.snd - 1),
              (current-location.fst - 2, current-location.snd + 1),
              (current-location.fst - 1, current-location.snd + 2)], validate-location)
    Figure(Bishop,             _,              current-location) ->
      move(current-location, NorthEast) ++ move(current-location, SouthEast) ++ move(current-location, SouthWest) ++ move(current-location, NorthWest)
    Figure(Rook(),             _,              current-location) ->
      move(current-location, North) ++ move(current-location, East) ++ move(current-location, South) ++ move(current-location, West)
    Figure(Queen,              _,              current-location) ->
      move(current-location, North) ++ move(current-location, NorthEast) ++ move(current-location, East) ++ move(current-location, SouthEast) ++
      move(current-location, South) ++ move(current-location, SouthWest) ++ move(current-location, West) ++ move(current-location, NorthWest)
    Figure(King(_),            _,              current-location) ->
      filter([(current-location.fst, current-location.snd + 1),
              (current-location.fst + 1, current-location.snd + 1),
              (current-location.fst + 1, current-location.snd),
              (current-location.fst + 1, current-location.snd - 1),
              (current-location.fst, current-location.snd - 1),
              (current-location.fst - 1, current-location.snd - 1),
              (current-location.fst - 1, current-location.snd),
              (current-location.fst - 1, current-location.snd + 1)], validate-location)

pub fun is-threatened(current-location : location, current-board : board, current-player : player) : bool
  fun is-threatened-by-figure(current-figures : list<figure>) : bool
    match current-figures
      Cons(head, tail)
        | is-just(valid-moves(head, current-board).find(fn(current) current == current-location)) -> True
        | _                                                                                       -> is-threatened-by-figure(tail)
      _                                                                                           -> False

  is-threatened-by-figure(current-board.figures.filter(fn(current) current.figure-player == current-player))

pub fun check-for-pawn-promotion(current-board : board, current-player : player) : maybe<location>
  current-board
    .figures
    .filter-map(fn(current) if current.figure-type == Pawn() && current.figure-player == current-player then Just(current.figure-location) else Nothing)
    .find(fn(current) match current-player {
      White -> current.snd == board-rows - 1
      _     -> current.snd == 0})

fun advance-pawn-one-rank(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst, current-location.snd + 1)
    _     -> (current-location.fst, current-location.snd - 1)

pub fun advance-pawn-two-ranks(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst, current-location.snd + 2)
    _     -> (current-location.fst, current-location.snd - 2)

pub fun can-pawn-take-right(current-location : location, current-board : board, current-player : player) : bool
  is-just(find-figure(current-board, pawn-takes-right(current-location, current-player), Just(current-player.opponent)))

pub fun pawn-takes-right(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst + 1, current-location.snd + 1)
    _     -> (current-location.fst - 1, current-location.snd - 1)

pub fun can-pawn-take-left(current-location : location, current-board : board, current-player : player) : bool
  is-just(find-figure(current-board, pawn-takes-left(current-location, current-player), Just(current-player.opponent)))

pub fun pawn-takes-left(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst - 1, current-location.snd + 1)
    _     -> (current-location.fst + 1, current-location.snd - 1)

pub fun right-en-passant-target(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst + 1, current-location.snd)
    _     -> (current-location.fst - 1, current-location.snd)

pub fun can-pawn-en-passant-right(current-location : location, current-board : board, current-player : player) : bool
  match find-figure(current-board, right-en-passant-target(current-location, current-player), Just(current-player.opponent))
    Just(Figure(Pawn(_, True), _, _)) -> True
    _                                 -> False

pub fun left-en-passant-target(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst - 1, current-location.snd)
    _     -> (current-location.fst + 1, current-location.snd)

pub fun can-pawn-en-passant-left(current-location : location, current-board : board, current-player : player) : bool  
  match find-figure(current-board, left-en-passant-target(current-location, current-player), Just(current-player.opponent))
    Just(Figure(Pawn(_, True), _, _)) -> True
    _                                 -> False
