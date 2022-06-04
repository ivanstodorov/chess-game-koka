module effects-and-handlers/read-input-main-menu

import effects-and-handlers/execution-method
import main-menu/main-menu-action/main-menu-action

pub effect fun read-input-main-menu() : maybe<main-menu-action>

pub fun handle-read-input-main-menu(action : () -> <execution-method, read-input-main-menu | e> a) : <execution-method | e> a
  with fun read-input-main-menu()
    val input : string = user-input()

    if input == "1" then return Just(NewGameAction)
    if input == "2" then return Just(QuitAction)

    Nothing

  action()
