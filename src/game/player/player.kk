module game/player/player

pub type player
  White
  Black

pub fun (==)(x : player, y : player) : bool
  match (x, y)
    (White, White) -> True
    (Black, Black) -> True
    _              -> False

pub fun (!=)(x : player, y : player) : bool
  !(x == y)

pub fun show(x : player) : string
  match x
    White -> "White"
    _     -> "Black"

pub fun opponent(x : player) : player
  match x
    White -> Black
    _     -> White
