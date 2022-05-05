module game/player/player

pub type player
  White
  Black

pub fun show(player : player) : string
  match player
    White -> "White player"
    Black -> "Black player"
