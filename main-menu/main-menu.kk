module main-menu/main-menu

import effects-and-handlers/read-input-main-menu
import main-menu-action/main-menu-action

val default-invalid-input-warning : string = "Invalid input!"

fun show-main-menu() : string
  var result : string := "Main menu:\n"
  result := result ++ "1. New game\n"
  result := result ++ "2. Quit"
  result

fun input-main-menu(invalid-input-warning : string = default-invalid-input-warning) : <console, div, read-input-main-menu> main-menu-action
  print("Input: ")

  match read-input-main-menu()
    Just(x) -> x
    _       ->
      // println("\n" ++ show-main-menu()) // Prints the main menu after an invalid input.
      println("\n" ++ invalid-input-warning ++ "\n")
      input-main-menu(invalid-input-warning)

pub fun main-menu() : <console, div, read-input-main-menu> main-menu-action
  println(show-main-menu())
  println("")

  input-main-menu()
