module game/board/board

pub import game/figure/figure

val board-rows = 8
val board-columns = 8

pub struct board
  figures : list<figure> = [Figure(Pawn(), White, (6, 0)), Figure(Pawn(), White, (6, 1)), Figure(Pawn(), White, (6, 2)), Figure(Pawn(), White, (6, 3)),
                            Figure(Pawn(), White, (6, 4)), Figure(Pawn(), White, (6, 5)), Figure(Pawn(), White, (6, 6)), Figure(Pawn(), White, (6, 7)),
                            Figure(Knight, White, (7, 1)), Figure(Knight, White, (7, 6)),
                            Figure(Bishop, White, (7, 2)), Figure(Bishop, White, (7, 5)),
                            Figure(Rook(queenside-castling=True), White, (7, 0)), Figure(Rook(kingside-castling=True), White, (7, 7)),
                            Figure(Queen, White, (7, 3)),
                            Figure(King(), White, (7, 4)),
                            Figure(Pawn(), Black, (1, 0)), Figure(Pawn(), Black, (1, 1)), Figure(Pawn(), Black, (1, 2)), Figure(Pawn(), Black, (1, 3)),
                            Figure(Pawn(), Black, (1, 4)), Figure(Pawn(), Black, (1, 5)), Figure(Pawn(), Black, (1, 6)), Figure(Pawn(), Black, (1, 7)),
                            Figure(Knight, Black, (0, 1)), Figure(Knight, Black, (0, 6)),
                            Figure(Bishop, Black, (0, 2)), Figure(Bishop, Black, (0, 5)),
                            Figure(Rook(queenside-castling=True), Black, (0, 0)), Figure(Rook(kingside-castling=True), Black, (0, 7)),
                            Figure(Queen, Black, (0, 3)),
                            Figure(King(), Black, (0, 4)),]

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
