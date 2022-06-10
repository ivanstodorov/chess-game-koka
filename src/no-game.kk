module shortest-world-chapmionship-game

import application/application
import effects-and-handlers/execution-method

pub fun main() : <console, div, exn> ()
  with simulation-without-printing(["2"])
  run()
