module game/figure/figure

import figure-type/figure-type
import game/player/player
import game/board/location/location

pub struct figure
  figure-type     : figure-type
  figure-player   : player
  figure-location : location

pub fun (==)(x : figure, y : figure) : bool
  x.figure-type == y.figure-type && x.figure-player == y.figure-player && x.figure-location == y.figure-location

pub fun (===)(x : figure, y : figure) : bool
  x.figure-type === y.figure-type && x.figure-player == y.figure-player && x.figure-location == y.figure-location

pub fun show(x : figure) : string
  match x
    Figure(Pawn,   White, _) -> "P"
    Figure(Pawn,   Black, _) -> "p"
    Figure(Knight, White, _) -> "N"
    Figure(Knight, Black, _) -> "n"
    Figure(Bishop, White, _) -> "B"
    Figure(Bishop, Black, _) -> "b"
    Figure(Rook,   White, _) -> "R"
    Figure(Rook,   Black, _) -> "r"
    Figure(Queen,  White, _) -> "Q"
    Figure(Queen,  Black, _) -> "q"
    Figure(King,   White, _) -> "K"
    Figure(King,   Black, _) -> "k"
    _                        -> " "
