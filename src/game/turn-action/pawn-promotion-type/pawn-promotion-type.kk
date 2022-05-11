module game/turn-action/pawn-promotion-type/pawn-promotion-type

import game/figure/figure-type/figure-type

pub type pawn-promotion-type
  PromoteToKnight
  PromoteToBishop
  PromoteToRook
  PromoteToQueen

pub fun pawn-promotion-to-figure-type(current-pawn-promotion : pawn-promotion-type) : figure-type
  match current-pawn-promotion 
    PromoteToKnight -> Knight
    PromoteToBishop -> Bishop
    PromoteToRook   -> Rook(True)
    _               -> Queen
