module game/figure/figure

pub import game/figure/location/location
pub import game/player/player

pub type figure-type
  Pawn
  Knight
  Bishop
  Rook
  Queen
  King

pub struct figure
  figure-type     : figure-type
  figure-player   : player
  figure-location : location

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
