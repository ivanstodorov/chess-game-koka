module shortest-world-chapmionship-game

import application/application
import effects-and-handlers/execution-method

pub fun main() : <console, div, exn> ()
  with simulation-with-printing(["1",
                                 "d2d4", "g8f6", // 1
                                 "c2c4", "g7g6", // 2
                                 "f2f3", "c7c5", // 3
                                 "d4d5", "d7d6", // 4
                                 "e2e4", "f8g7", // 5
                                 "g1e2", "o-o", // 6
                                 "e2c3", "f6h5", // 7
                                 "c1g5", "g7f6", // 8
                                 "g5f6", "e7f6", // 9
                                 "d1d2", "f6f5", // 10
                                 "e4f5", "c8f5", // 11
                                 "g2g4", "f8e8", // 12
                                 "e1d1", "f5b1", // 13
                                 "a1b1", "d8f6", // 14
                                 "g4h5", "f6f3", // 15
                                 "d1c2", "f3h1", // 16
                                 "d2f2", "gg", // 17
                                 "2"])
  run()
