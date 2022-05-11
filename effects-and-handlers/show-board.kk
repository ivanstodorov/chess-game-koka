module effects-and-handlers/show-board

import game/board/board
import game/figure/figure

pub effect fun show-board(current-board : board) : string

pub fun handle-show-board(action : () -> <show-board | e> a) : e a
  with fun show-board(current-board : board)
    fun show-row(row-index : int) : string
      fun show-location(column-index : int) : string
        match find-figure(current-board, (column-index, row-index))
          Just(y) -> y.show
          _       -> " "

      var result : string := " " ++ (row-index + 1).show ++ " ||"

      var current-column : int := 0
      repeat(board-columns)
        result := result ++ " " ++ show-location(current-column) ++ " "
        current-column := current-column + 1
        if current-column < board-columns then result := result ++ "|"

      result := result ++ "|| " ++ (row-index + 1).show ++ " "
      result

    var result : string := "   || A | B | C | D | E | F | G | H ||   \n"
    result := result ++ "===++===+===+===+===+===+===+===+===++===\n"

    var current-row : int := board-rows - 1
    repeat(board-rows)
      result := result ++ show-row(current-row) ++ "\n"
      current-row := current-row - 1
      if current-row >= 0 then result := result ++ "---++---+---+---+---+---+---+---+---++---\n"

    result := result ++ "===++===+===+===+===+===+===+===+===++---\n"
    result := result ++ "   || A | B | C | D | E | F | G | H ||   "
    result

  action()
