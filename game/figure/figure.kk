module game/figure/figure

pub import game/figure/location/location
pub import game/player/player

pub type figure-type
  Pawn(en-passant : bool = False)
  Knight
  Bishop
  Rook(kingside-castling : bool = False, queenside-castling : bool = False)
  Queen
  King(castling : bool = True)

pub struct figure
  figure-type     : figure-type
  figure-player   : player
  figure-location : location

pub fun show(x : figure) : string
  match x
    Figure(Pawn(_),    White, _) -> "P"
    Figure(Pawn(_),    Black, _) -> "p"
    Figure(Knight,     White, _) -> "N"
    Figure(Knight,     Black, _) -> "n"
    Figure(Bishop,     White, _) -> "B"
    Figure(Bishop,     Black, _) -> "b"
    Figure(Rook(_, _), White, _) -> "R"
    Figure(Rook(_, _), Black, _) -> "r"
    Figure(Queen,      White, _) -> "Q"
    Figure(Queen,      Black, _) -> "q"
    Figure(King(_),    White, _) -> "K"
    Figure(King(_),    Black, _) -> "k"
    _                            -> " "
