module effects-and-handlers/read-input-draw-offer

import effects-and-handlers/execution-method

val synonyms-for-accept : list<string> = ["accept", "yes", "y"]
val synonyms-for-reject : list<string> = ["reject", "no", "n"]

pub effect fun read-input-draw-offer() : maybe<bool>

pub fun handle-read-input-draw-offer(action : () -> <execution-method, read-input-draw-offer | e> a) : <execution-method | e> a
  with fun read-input-draw-offer()
    val temp : string = user-input()

    if is-empty(temp) then return Nothing

    val input : string = temp.to-lower

    if is-just(synonyms-for-accept.find(fn(current : string) current == input)) then return Just(True)
    if is-just(synonyms-for-reject.find(fn(current : string) current == input)) then return Just(False)

    Nothing

  action()
