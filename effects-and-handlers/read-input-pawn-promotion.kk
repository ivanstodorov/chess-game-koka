module effects-and-handlers/read-input-pawn-promotion

import game/turn-action/pawn-promotion-type/pawn-promotion-type

import std/os/readline

pub effect fun read-input-pawn-promotion() : maybe<pawn-promotion-type>

pub fun handle-read-input-pawn-promotion(action : () -> <console, exn, read-input-pawn-promotion | e> a) : <console, exn | e> a
  with fun read-input-pawn-promotion()
    val temp = readline()

    if is-empty(temp) then return Nothing

    val input = temp.to-lower

    if input == "knight" || input == "n" then return Just(PromoteToKnight)
    if input == "bishop" || input == "b" then return Just(PromoteToBishop)
    if input == "rook" || input == "r" then return Just(PromoteToRook)
    if input == "queen" || input == "q" then return Just(PromoteToQueen)

    Nothing
  
  action()
