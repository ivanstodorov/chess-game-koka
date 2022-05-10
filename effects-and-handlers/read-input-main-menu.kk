module effects-and-handlers/read-input-main-menu

import main-menu/main-menu-action/main-menu-action

import std/os/readline

pub effect fun read-input-main-menu() : maybe<main-menu-action>

pub fun handle-read-input-main-menu(action : () -> <console, exn, read-input-main-menu | e> a) : <console, exn | e> a
  with fun read-input-main-menu()
    val input = readline()

    if input == "1" then return Just(NewGameAction)
    if input == "2" then return Just(QuitAction)

    Nothing

  action()
