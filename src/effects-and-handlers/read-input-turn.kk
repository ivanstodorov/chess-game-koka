module effects-and-handlers/read-input-turn

import effects-and-handlers/user-input
import game/board/board
import game/figure/figure
import game/player/player
import game/turn-action/castling-type/castling-type
import game/turn-action/turn-action

val synonyms-for-draw : list<string> = ["remis", "draw", "tie"]
val synonyms-for-surrender : list<string> = ["good game", "gg", "forfait", "ff"]

pub effect fun read-input-turn(current-player : player, current-board : board) : maybe<turn-action>

pub fun handle-read-input-turn(action : () -> <read-input-turn, user-input | e> a) : <user-input | e> a
  fun parse-row(row : char) : maybe<int>
    match row
      '1' -> Just(0)
      '2' -> Just(1)
      '3' -> Just(2)
      '4' -> Just(3)
      '5' -> Just(4)
      '6' -> Just(5)
      '7' -> Just(6)
      '8' -> Just(7)
      _   -> Nothing

  fun parse-column(column : char) : maybe<int>
    match column
      'a' -> Just(0)
      'b' -> Just(1)
      'c' -> Just(2)
      'd' -> Just(3)
      'e' -> Just(4)
      'f' -> Just(5)
      'g' -> Just(6)
      'h' -> Just(7)
      _   -> Nothing

  with fun read-input-turn(current-player : player, current-board : board)
    val temp : string = user-input()

    if is-empty(temp) then return Nothing

    val input : string = temp.to-lower

    if input == "0-0" || input == "O-O" || input == "o-o" then return Just(Castling(Kingside, current-player))
    if input == "0-0-0" || input == "O-O-O" || input == "o-o-o" then return Just(Castling(Queenside, current-player))
    if is-just(synonyms-for-draw.find(fn(current : string) current == input)) then return Just(DrawOffer)
    if is-just(synonyms-for-surrender.find(fn(current : string) current == input)) then return Just(Surrender)

    match list(input)
      Cons(m, Cons(n, Cons(o, Cons(p, Nil)))) ->
        match ((parse-column(m), parse-row(n)), (parse-column(o), parse-row(p)))
          ((Just(q), Just(r)), (Just(s), Just(t))) -> 
            match find-figure(current-board, (q, r), Just(current-player))
              Just(x) -> Just(Move(x, (s, t)))
              _       -> Nothing
          _                                        -> Nothing
      _                                       -> Nothing

  action()
