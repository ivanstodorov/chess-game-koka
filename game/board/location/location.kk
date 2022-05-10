module game/board/location/location

pub alias location = (int, int)

pub fun (==)(x : location, y : location) : bool
  x.fst == y.fst && x.snd == y.snd
