module main-menu/main-menu

import main-menu-action/main-menu-action

import std/os/readline

val default-invalid-input-warning : string = "Invalid input!"

fun show-main-menu() : string
  var result : string := "Main menu:\n"
  result := result ++ "1. New game\n"
  result := result ++ "2. Quit"
  result

fun read-input-main-menu(inputs : ref<h, list<string>>, should-print : bool) : <console, exn, read<h>, write<h>> maybe<main-menu-action>
  val input : string = match !inputs
    Cons(x, xs) ->
      inputs := xs
      if should-print then println(x)
      x
    _          -> readline()

  if input == "1" then return Just(NewGameAction)
  if input == "2" then return Just(QuitAction)

  Nothing

fun input-main-menu(inputs : ref<h, list<string>>, should-print : bool, invalid-input-warning : string = default-invalid-input-warning) : <console, div, exn, read<h>, write<h>> main-menu-action
  if should-print then print("Input: ")

  match read-input-main-menu(inputs, should-print)
    Just(x) -> x
    _       ->
      // if should-print then println("\n" ++ show-main-menu()) // Prints the main menu after an invalid input.
      if should-print then println("\n" ++ invalid-input-warning ++ "\n")
      input-main-menu(inputs, should-print, invalid-input-warning)

pub fun main-menu(inputs : ref<h, list<string>>, should-print : bool) : <console, div, exn, read<h>, write<h>> main-menu-action
  if should-print then println(show-main-menu())
  if should-print then println("")

  input-main-menu(inputs, should-print)
