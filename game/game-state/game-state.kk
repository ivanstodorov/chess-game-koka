module game/game-state/game-state

import game/board/board
import game/player/player

pub struct game-state
  current-player : player
  current-board : board
  white-can-kingside-castle : bool
  black-can-kingside-castle : bool
  white-can-queenside-castle : bool
  black-can-queenside-castle : bool

pub fun (==)(x : game-state, y : game-state) : bool
  x.current-player == y.current-player &&
  x.current-board == y.current-board &&
  x.white-can-kingside-castle == y.white-can-kingside-castle &&
  x.black-can-kingside-castle == y.black-can-kingside-castle &&
  x.white-can-queenside-castle == y.white-can-queenside-castle &&
  x.black-can-queenside-castle == y.black-can-queenside-castle
