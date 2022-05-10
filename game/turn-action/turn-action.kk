module game/turn-action/turn-action

import castling-type/castling-type
import game/board/location/location
import game/figure/figure
import game/player/player

pub type action
  Move(selected-figure : figure, to : location)
  Castling(castling-type : castling-type, current-player : player)
  DrawOffer
  Surrender
