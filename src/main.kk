module main

import application/application
import effects-and-handlers/user-input

pub fun main() : <console, div, exn> ()
  with read-input
  run()
