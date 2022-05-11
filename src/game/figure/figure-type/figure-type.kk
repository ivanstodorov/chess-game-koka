module game/figure/figure-type/figure-type

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
    (Rook,         Rook)         -> True
    (Queen,        Queen)        -> True
    (King,         King)         -> True
    _                            -> False
