module game/game

pub import game/turn/turn

pub fun game() : <div, console, exn> maybe<player>
  // println("   || A | B | C | D | E | F | G | H ||   ")
  // println("===++===+===+===+===+===+===+===+===++===")
  // println(" 8 || r | n | b | q | k | b | n | r || 8 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 7 || p | p | p | p | p | p | p | p || 7 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 6 ||   |   |   |   |   |   |   |   || 6 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 5 ||   |   |   |   |   |   |   |   || 5 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 4 ||   |   |   |   |   |   |   |   || 4 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 3 ||   |   |   |   |   |   |   |   || 3 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 2 || P | P | P | P | P | P | P | P || 2 ")
  // println("---++---+---+---+---+---+---+---+---++---")
  // println(" 1 || R | N | B | Q | K | B | N | R || 1 ")
  // println("===++===+===+===+===+===+===+===+===++---")
  // println("   || A | B | C | D | E | F | G | H ||   ")

  with handle-board-state(Board())
  with handle-read-input-turn
  with handle-read-input-pawn-promotion
  with handle-read-input-draw-offer
  turn(White)
