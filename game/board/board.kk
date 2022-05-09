module game/board/board

pub import game/figure/figure

val board-rows = 8
val board-columns = 8

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
  figures : list<figure> = [Figure(Pawn(), White, (6, 0)), Figure(Pawn(), White, (6, 1)), Figure(Pawn(), White, (6, 2)), Figure(Pawn(), White, (6, 3)),
                            Figure(Pawn(), White, (6, 4)), Figure(Pawn(), White, (6, 5)), Figure(Pawn(), White, (6, 6)), Figure(Pawn(), White, (6, 7)),
                            Figure(Knight, White, (7, 1)), Figure(Knight, White, (7, 6)),
                            Figure(Bishop, White, (7, 2)), Figure(Bishop, White, (7, 5)),
                            Figure(Rook(), White, (7, 0)), Figure(Rook(), White, (7, 7)),
                            Figure(Queen, White, (7, 3)),
                            Figure(King(), White, (7, 4)),
                            Figure(Pawn(), Black, (1, 0)), Figure(Pawn(), Black, (1, 1)), Figure(Pawn(), Black, (1, 2)), Figure(Pawn(), Black, (1, 3)),
                            Figure(Pawn(), Black, (1, 4)), Figure(Pawn(), Black, (1, 5)), Figure(Pawn(), Black, (1, 6)), Figure(Pawn(), Black, (1, 7)),
                            Figure(Knight, Black, (0, 1)), Figure(Knight, Black, (0, 6)),
                            Figure(Bishop, Black, (0, 2)), Figure(Bishop, Black, (0, 5)),
                            Figure(Rook(), Black, (0, 0)), Figure(Rook(), Black, (0, 7)),
                            Figure(Queen, Black, (0, 3)),
                            Figure(King(), Black, (0, 4))]

pub fun find-figure(current-board : board, target-location : location, current-player : maybe<player> = Nothing) : maybe<figure>
  fun helper(xs : list<figure>) : maybe<figure>
    match xs
      Cons(y, ys)
        | y.figure-location == target-location ->
          match current-player
            Just(z)
              | y.figure-player == z -> Just(y)
              | _                    -> helper(ys)
            Nothing                  -> Just(y)
        | _                                    -> helper(ys)
      _                                        -> Nothing

  helper(current-board.figures)

pub fun show(x : board) : string
  fun show-row(row-index : int) : string
    fun show-location(column-index : int) : string
      match find-figure(x, (row-index, column-index))
        Just(y) -> y.show
        _       -> " "

    var result := " " ++ (board-rows - row-index).show ++ " ||"

    var current-column := 0
    repeat(board-columns)
      result := result ++ " " ++ show-location(current-column) ++ " "
      current-column := current-column + 1
      if current-column < board-columns then result := result ++ "|"

    result := result ++ "|| " ++ (board-rows - row-index).show ++ " "
    result

  var result := "   || A | B | C | D | E | F | G | H ||   \n"
  result := result ++ "===++===+===+===+===+===+===+===+===++===\n"

  var current-row := 0
  repeat(board-rows)
    result := result ++ show-row(current-row) ++ "\n"
    current-row := current-row + 1
    if current-row < board-rows then result := result ++ "---++---+---+---+---+---+---+---+---++---\n"

  result := result ++ "===++===+===+===+===+===+===+===+===++---\n"
  result := result ++ "   || A | B | C | D | E | F | G | H ||   "
  result

fun advance-pawn-one-rank(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst - 1, current-location.snd)
    _     -> (current-location.fst + 1, current-location.snd)

pub fun advance-pawn-two-ranks(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst - 2, current-location.snd)
    _     -> (current-location.fst + 2, current-location.snd)

pub fun pawn-takes-right(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst - 1, current-location.snd + 1)
    _     -> (current-location.fst + 1, current-location.snd - 1)

pub fun pawn-takes-left(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst - 1, current-location.snd - 1)
    _     -> (current-location.fst + 1, current-location.snd + 1)

pub fun right-en-passant-target(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst, current-location.snd + 1)
    _     -> (current-location.fst, current-location.snd - 1)

pub fun left-en-passant-target(current-location : location, current-player : player) : location
  match current-player
    White -> (current-location.fst, current-location.snd - 1)
    _     -> (current-location.fst, current-location.snd + 1)

pub fun can-pawn-take-right(current-location : location, current-board : board, current-player : player) : bool
  is-just(find-figure(current-board, pawn-takes-right(current-location, current-player), Just(current-player.opponent)))

pub fun can-pawn-take-left(current-location : location, current-board : board, current-player : player) : bool
  is-just(find-figure(current-board, pawn-takes-left(current-location, current-player), Just(current-player.opponent)))

pub fun can-pawn-en-passant-right(current-location : location, current-board : board, current-player : player) : bool
  match find-figure(current-board, right-en-passant-target(current-location, current-player), Just(current-player.opponent))
    Just(Figure(Pawn(_, True), _, _)) -> True
    _                                 -> False

pub fun can-pawn-en-passant-left(current-location : location, current-board : board, current-player : player) : bool  
  match find-figure(current-board, left-en-passant-target(current-location, current-player), Just(current-player.opponent))
    Just(Figure(Pawn(_, True), _, _)) -> True
    _                                 -> False

pub fun valid-moves(current-figure : figure, current-board : board) : list<location>
  fun validate-location(x : location) : bool
    0 <= x.fst && x.fst < board-rows && 0 <= x.snd && x.snd < board-columns && is-nothing(find-figure(current-board, x, Just(current-figure.figure-player)))

  fun move(x : location, move-direction : direction) : list<location>
    var result := Nil

    for-while(1, board-rows - 1) fn(i)
      val current = match move-direction
        North     -> (x.fst - i, x.snd)
        NorthEast -> (x.fst - i, x.snd + i)
        East      -> (x.fst, x.snd + i)
        SouthEast -> (x.fst + i, x.snd + i)
        South     -> (x.fst + i, x.snd)
        SouthWest -> (x.fst + i, x.snd - i)
        West      -> (x.fst, x.snd - i)
        NorthWest -> (x.fst - i, x.snd - i)

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
      filter([(current-location.fst - 2, current-location.snd - 1),
              (current-location.fst - 2, current-location.snd + 1),
              (current-location.fst + 2, current-location.snd - 1),
              (current-location.fst + 2, current-location.snd + 1),
              (current-location.fst - 1, current-location.snd - 2),
              (current-location.fst - 1, current-location.snd + 2),
              (current-location.fst + 1, current-location.snd - 2),
              (current-location.fst + 1, current-location.snd + 2)], validate-location)
    Figure(Bishop,             _,              current-location) ->
      move(current-location, NorthEast) ++ move(current-location, SouthEast) ++ move(current-location, SouthWest) ++ move(current-location, NorthWest)
    Figure(Rook(),             _,              current-location) ->
      move(current-location, North) ++ move(current-location, East) ++ move(current-location, South) ++ move(current-location, West)
    Figure(Queen,              _,              current-location) ->
      move(current-location, North) ++ move(current-location, NorthEast) ++ move(current-location, East) ++ move(current-location, SouthEast) ++
      move(current-location, South) ++ move(current-location, SouthWest) ++ move(current-location, West) ++ move(current-location, NorthWest)
    Figure(King(_),            _,              current-location) ->
      filter([(current-location.fst - 1, current-location.snd),
              (current-location.fst - 1, current-location.snd + 1),
              (current-location.fst, current-location.snd + 1),
              (current-location.fst + 1, current-location.snd + 1),
              (current-location.fst + 1, current-location.snd),
              (current-location.fst + 1, current-location.snd - 1),
              (current-location.fst, current-location.snd - 1),
              (current-location.fst - 1, current-location.snd - 1)], validate-location)

pub fun is-threatened(current-location : location, current-board : board, current-player : player) : bool
  fun is-threatened-by-figure(current-figures : list<figure>) : bool
    match current-figures
      Cons(head, tail)
        | is-just(valid-moves(head, current-board).find(fn(current) current == current-location)) -> True
        | _                                                                                       -> is-threatened-by-figure(tail)
      _                                                                                           -> False

  is-threatened-by-figure(current-board.figures.filter(fn(current) current.figure-player == current-player))
