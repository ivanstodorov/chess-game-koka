module effects-and-handlers/read-input-pawn-promotion

import effects-and-handlers/user-input
import game/turn-action/pawn-promotion-type/pawn-promotion-type

pub effect fun read-input-pawn-promotion() : maybe<pawn-promotion-type>

pub fun handle-read-input-pawn-promotion(action : () -> <read-input-pawn-promotion, user-input | e> a) : <user-input | e> a
  with fun read-input-pawn-promotion()
    val temp : string = user-input()

    if is-empty(temp) then return Nothing

    val input : string = temp.to-lower

    if input == "knight" || input == "n" then return Just(PromoteToKnight)
    if input == "bishop" || input == "b" then return Just(PromoteToBishop)
    if input == "rook" || input == "r" then return Just(PromoteToRook)
    if input == "queen" || input == "q" then return Just(PromoteToQueen)

    Nothing
  
  action()
