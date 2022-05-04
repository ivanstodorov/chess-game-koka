module game/game

import std/os/readline

pub type player
  White
  Black

type figure-type
  Pawn
  Knight
  Bishop
  Rook
  Queen
  King

struct figure
  figure-type : figure-type
  player      : player
  location    : (int, int)

fun show(figure : figure) : string
  match figure
    Figure(Pawn,   White, _) -> "P"
    Figure(Pawn,   Black, _) -> "p"
    Figure(Knight, White, _) -> "N"
    Figure(Knight, Black, _) -> "n"
    Figure(Bishop, White, _) -> "B"
    Figure(Bishop, Black, _) -> "b"
    Figure(Rook,   White, _) -> "R"
    Figure(Rook,   Black, _) -> "r"
    Figure(Queen,  White, _) -> "Q"
    Figure(Queen,  Black, _) -> "q"
    Figure(King,   White, _) -> "K"
    Figure(King,   Black, _) -> "k"
    _                        -> " "

struct board
  rows : int = 8
  columns : int = 8
  figures : list<figure> = [Figure(Pawn, White, (6, 0)), Figure(Pawn, White, (6, 1)), Figure(Pawn, White, (6, 2)), Figure(Pawn, White, (6, 3)),
                            Figure(Pawn, White, (6, 4)), Figure(Pawn, White, (6, 5)), Figure(Pawn, White, (6, 6)), Figure(Pawn, White, (6, 7)),
                            Figure(Knight, White, (7, 1)), Figure(Knight, White, (7, 6)),
                            Figure(Bishop, White, (7, 2)), Figure(Bishop, White, (7, 5)),
                            Figure(Rook, White, (7, 0)), Figure(Rook, White, (7, 7)),
                            Figure(Queen, White, (7, 3)),
                            Figure(King, White, (7, 4)),
                            Figure(Pawn, Black, (1, 0)), Figure(Pawn, Black, (1, 1)), Figure(Pawn, Black, (1, 2)), Figure(Pawn, Black, (1, 3)),
                            Figure(Pawn, Black, (1, 4)), Figure(Pawn, Black, (1, 5)), Figure(Pawn, Black, (1, 6)), Figure(Pawn, Black, (1, 7)),
                            Figure(Knight, Black, (0, 1)), Figure(Knight, Black, (0, 6)),
                            Figure(Bishop, Black, (0, 2)), Figure(Bishop, Black, (0, 5)),
                            Figure(Rook, Black, (0, 0)), Figure(Rook, Black, (0, 7)),
                            Figure(Queen, Black, (0, 3)),
                            Figure(King, Black, (0, 4)),]

fun find-figure(board : board, row : int, column : int) : maybe<figure>
  fun helper(figures : list<figure>) : maybe<figure>
    match figures
      Cons(Figure(figure-type, player, (x, y)), tail) -> if x == row && y == column then Just(Figure(figure-type, player, (x, y))) else helper(tail)
      _                                               -> Nothing

  helper(board.figures)

fun show(board : board) : string
  fun show-row(row-index : int) : string
    fun show-location(column-index : int) : string
      match find-figure(board, row-index, column-index)
        Just(x) -> x.show
        _       -> " "

    var result := " " ++ (board.rows - row-index).show ++ " ||"

    var current-column := 0
    repeat(board.columns)
      result := result ++ " " ++ show-location(current-column) ++ " "
      current-column := current-column + 1
      if current-column < board.columns then result := result ++ "|"

    result := result ++ "|| " ++ (board.rows - row-index).show ++ " "
    result

  var result := "   || A | B | C | D | E | F | G | H ||   \n"
  result := result ++ "===++===+===+===+===+===+===+===+===++===\n"

  var current-row := 0
  repeat(board.rows)
    result := result ++ show-row(current-row) ++ "\n"
    current-row := current-row + 1
    if current-row < board.rows then result := result ++ "---++---+---+---+---+---+---+---+---++---\n"

  result := result ++ "===++===+===+===+===+===+===+===+===++---\n"
  result := result ++ "   || A | B | C | D | E | F | G | H ||   "
  result

type player-turn-action
  Move
  Castling

effect fun read-input-player-turn() : maybe<player-turn-action>

fun handle-read-input-player-turn(action : () -> <console, exn, read-input-player-turn | e> a) : <console, exn | e> a
  with fun read-input-player-turn()
    // Implement a proper handler for reading user input
    val input = readline()
    if input == "" then Nothing else Just(Move)

  action()

fun input-player-turn(player : player, invalid-input-warning : string) : <div, console, read-input-player-turn> player-turn-action
  match player
    White -> print("White player turn: ")
    Black -> print("Black player turn: ")

  match read-input-player-turn()
    Just(x) -> x
    _       ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-player-turn(player, invalid-input-warning)

effect fun perform-action-player-turn(player : player, turn-action : player-turn-action, board : board) : either<player, maybe<player>>

fun handle-perform-action-player-turn(action : () -> <perform-action-player-turn | e> a) : e a
  with fun perform-action-player-turn(player, turn-action, board)
    // Implement the handler for performing an action
    match player
      White -> Left(Black)
      Black -> Left(White)

  action()

fun player-turn(player : player, board : board) : <div, console, perform-action-player-turn, read-input-player-turn> maybe<player>
  println(board.show)
  println("")

  val action = input-player-turn(player, "Invalid input!")
  println("")

  match perform-action-player-turn(player, action, board)
    Left(x)  -> player-turn(x, board)
    Right(x) -> x

pub fun game() : <div, console, exn> maybe<player>
  // println("   || A | B | C | D | E | F | G | H ||   ")
  // println("===++===+===+===+===+===+===+===+===++===")
  // println(" 8 || r | n | b | q | k | b | n | r || 8 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 7 || p | p | p | p | p | p | p | p || 7 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 6 ||   |   |   |   |   |   |   |   || 6 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 5 ||   |   |   |   |   |   |   |   || 5 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 4 ||   |   |   |   |   |   |   |   || 4 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 3 ||   |   |   |   |   |   |   |   || 3 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 2 || P | P | P | P | P | P | P | P || 2 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 1 || R | N | B | Q | K | B | N | R || 1 ")
  // println("===++===+===+===+===+===+===+===+===++---")
  // println("   || A | B | C | D | E | F | G | H ||   ")

  with handle-read-input-player-turn
  with handle-perform-action-player-turn
  player-turn(White, Board())
