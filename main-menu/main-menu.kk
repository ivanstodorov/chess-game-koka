module main-menu/main-menu

import std/os/readline

pub type main-menu-action
  NewGameAction
  QuitAction

effect fun read-input-main-menu() : maybe<main-menu-action>

fun handle-read-input-main-menu(action : () -> <console, exn, read-input-main-menu | e> a) : <console, exn | e> a
  with fun read-input-main-menu()
    val input = readline()

    if input == "1" then return Just(NewGameAction)
    if input == "2" then return Just(QuitAction)

    Nothing

  action()

fun input-main-menu(invalid-input-warning : string) : <div, console, read-input-main-menu> main-menu-action
  print("Input: ")

  match read-input-main-menu()
    Just(x) -> x
    _       -> 
      println("\n" ++ invalid-input-warning ++ "\n")
      input-main-menu(invalid-input-warning)

pub fun main-menu() : <console, exn, div> main-menu-action
  println("Main menu:")
  println("1. New game")
  println("2. Quit")
  println("")

  with handle-read-input-main-menu
  input-main-menu("Invalid input!")
