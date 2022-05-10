module game/figure/figure

pub import game/figure/location/location
pub import game/player/player

pub type figure-type
  Pawn(has-moved : bool = False, en-passant : bool = False)
  Knight
  Bishop
  Rook(has-moved : bool = False)
  Queen
  King(has-moved : bool = False)

pub fun (==)(x : figure-type, y : figure-type) : bool
  match (x, y)
    (Pawn,   Pawn)   -> True
    (Knight, Knight) -> True
    (Bishop, Bishop) -> True
    (Rook,   Rook)   -> True
    (Queen,  Queen)  -> True
    (King,   King)   -> True
    _                -> False

pub fun (===)(x : figure-type, y : figure-type) : bool
  match (x, y)
    (Pawn(ly, lz), Pawn(ry, rz)) -> ly == ry && lz == rz
    (Knight,       Knight)       -> True
    (Bishop,       Bishop)       -> True
    (Rook(ly),     Rook(ry))     -> ly == ry
    (Queen,        Queen)        -> True
    (King(ly),     King(ry))     -> ly == ry
    _                            -> False

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
