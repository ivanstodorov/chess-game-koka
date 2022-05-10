module main-menu/main-menu

import main-menu-action/main-menu-action
import effects/read-input-main-menu

fun input-main-menu(invalid-input-warning : string) : <div, console, read-input-main-menu> main-menu-action
  print("Input: ")

  match read-input-main-menu()
    Just(x) -> x
    _       -> 
      println("\n" ++ invalid-input-warning ++ "\n")
      input-main-menu(invalid-input-warning)

pub fun main-menu() : <console, exn, div> main-menu-action
  with handle-read-input-main-menu
  println("Main menu:")
  println("1. New game")
  println("2. Quit")
  println("")

  input-main-menu("Invalid input!")
