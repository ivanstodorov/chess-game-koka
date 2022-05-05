module game/turn/turn

pub import game/board/board
import std/os/readline

type turn-action
  Move

pub effect fun read-input-turn() : maybe<turn-action>

pub fun handle-read-input-turn(action : () -> <console, exn, read-input-turn | e> a) : <console, exn | e> a
  with fun read-input-turn()
    // Implement a proper handler for reading user input
    val input = readline()
    if input == "" then Nothing else Just(Move)

  action()

pub effect fun perform-action-turn(player : player, turn-action : turn-action, board : board) : either<player, maybe<player>>

pub fun handle-perform-action-turn(action : () -> <perform-action-turn | e> a) : e a
  with fun perform-action-turn(player, turn-action, board)
    // Implement the handler for performing an action
    match player
      White -> Left(Black)
      Black -> Left(White)

  action()

fun input-turn(player : player, invalid-input-warning : string) : <div, console, read-input-turn> turn-action
  print(player.show ++ "'s turn: ")

  match read-input-turn()
    Just(x) -> x
    _       ->
      println("\n" ++ invalid-input-warning ++ "\n")
      input-turn(player, invalid-input-warning)

pub fun turn(player : player, board : board) : <div, console, perform-action-turn, read-input-turn> maybe<player>
  println(board.show)
  println("")

  val action = input-turn(player, "Invalid input!")
  println("")

  match perform-action-turn(player, action, board)
    Left(x)  -> turn(x, board)
    Right(x) -> x
