module main

import application/application
import effects-and-handlers/execution-method

pub fun main() : <console, div, exn> ()
  with normal-game
  run()
