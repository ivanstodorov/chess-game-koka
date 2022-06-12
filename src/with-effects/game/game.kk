module game/game

import board/board
import board/location/location
import effects-and-handlers/execution-method
import effects-and-handlers/read-input-draw-offer
import effects-and-handlers/read-input-pawn-promotion
import effects-and-handlers/read-input-turn
import effects-and-handlers/show-board
import figure/figure
import figure/figure-type/figure-type
import game-state/game-state
import player/player
import turn-action/castling-type/castling-type
import turn-action/pawn-promotion-type/pawn-promotion-type
import turn-action/turn-action

val default-invalid-input-warning : string = "Invalid input!"

fun remove-en-passant(figures : list<figure>, current-player : player) : list<figure>
  match figures
    Cons(Figure(Pawn(x, True), y, z), tail) 
      | y == current-player -> Cons(Figure(Pawn(x, False), y, z), remove-en-passant(tail, current-player))
    Cons(head, tail)        -> Cons(head, remove-en-passant(tail, current-player))
    _                       -> Nil

fun has-valid-moves(current-board : board, current-player : player) : bool
  fun has-valid-moves-by-figure(current-figures : list<figure>) : bool
    match current-figures
      Cons(head, tail)
        | is-cons(valid-moves(head, current-board).filter(fn(current : location) validate-input-turn(Move(head, current), current-board))) -> True
        | _                                                                                                                                -> has-valid-moves-by-figure(tail)
      _                                                                                                                                    -> False

  has-valid-moves-by-figure(current-board.figures.filter(fn(current : figure) current.figure-player == current-player))

fun input-draw-offer(current-player : player, invalid-input-warning : string = default-invalid-input-warning) : <div, execution-method, read-input-draw-offer> bool
  custom-println(current-player.show ++ " offered a draw.")
  custom-print(current-player.opponent.show ++ "'s response: ")

  match read-input-draw-offer()
    Just(x) -> x
    _       ->
      custom-println("\n" ++ invalid-input-warning ++ "\n")
      input-draw-offer(current-player, invalid-input-warning)

fun input-pawn-promotion(current-location : location, current-player : player, invalid-input-warning : string = default-invalid-input-warning) : <div, execution-method, read-input-pawn-promotion> pawn-promotion-type
  fun parse-location(x : location) : maybe<string>
    fun parse-row(row : int) : maybe<string>
      match row
        0 -> Just("1")
        1 -> Just("2")
        2 -> Just("3")
        3 -> Just("4")
        4 -> Just("5")
        5 -> Just("6")
        6 -> Just("7")
        7 -> Just("8")
        _ -> Nothing

    fun parse-column(column : int) : maybe<string>
      match column
        0 -> Just("A")
        1 -> Just("B")
        2 -> Just("C")
        3 -> Just("D")
        4 -> Just("E")
        5 -> Just("F")
        6 -> Just("G")
        7 -> Just("H")
        _ -> Nothing

    match (parse-column(x.fst), parse-row(x.snd))
      (Just(y), Just(z)) -> Just(y ++ z)
      _                  -> Nothing

  match parse-location(current-location)
    Just(x) -> custom-println("Pawn promotion at square " ++ x ++ ":")
    _       -> custom-println("Pawn promotion:")

  custom-print("Should the pawn be replaced with a knight (" ++ Figure(Knight, current-player, current-location).show ++
               "), bishop (" ++ Figure(Bishop, current-player, current-location).show ++
               "), rook (" ++ Figure(Rook(True), current-player, current-location).show ++
               ") or queen (" ++ Figure(Queen, current-player, current-location).show ++
               "): ")

  match read-input-pawn-promotion()
    Just(x) -> x
    _       ->
      custom-println("\n" ++ invalid-input-warning ++ "\n")
      input-pawn-promotion(current-location, current-player, invalid-input-warning)

fun perform-turn(current-board : ref<h, board>, current-action : turn-action) : <read<h>, write<h>> ()
  fun change-board(board : ref<h, board>, new-figure : figure, removal-condition : (figure) -> bool) : <read<h>, write<h>> ()
    board := Board(Cons(new-figure, (!board).figures.remove(removal-condition)))

  match current-action
    Move(Figure(temp, current-player, current-location), to-location) ->
      fun removal-condition(current : figure) : bool
        current.figure-location == current-location || current.figure-location == to-location

      match temp
        Pawn()              ->
          if to-location == advance-pawn(advance-pawn(current-location, current-player), current-player)
          then return change-board(current-board, Figure(Pawn(True, True), current-player, to-location), removal-condition)

          if to-location == pawn-takes-right(current-location, current-player) &&
            can-pawn-en-passant-right(current-location, !current-board, current-player)
          then return change-board(current-board, Figure(Pawn(True, False), current-player, to-location)) fn(current : figure) : bool
            removal-condition(current) || current.figure-location == right-en-passant-target(current-location, current-player)

          if to-location == pawn-takes-left(current-location, current-player) &&
            can-pawn-en-passant-left(current-location, !current-board, current-player)
          then return change-board(current-board, Figure(Pawn(True, False), current-player, to-location)) fn(current : figure) : bool
            removal-condition(current) || current.figure-location == left-en-passant-target(current-location, current-player)

          change-board(current-board, Figure(Pawn(True, False), current-player, to-location), removal-condition)
        Rook()              ->
          change-board(current-board, Figure(Rook(True), current-player, to-location), removal-condition)
        King()              ->
          change-board(current-board, Figure(King(True), current-player, to-location), removal-condition)
        current-figure-type ->
          change-board(current-board, Figure(current-figure-type, current-player, to-location), removal-condition)
    Castling(current-castling-type, current-player)                   ->
      val king-start-location : location = get-king-start-location-for-castling(current-castling-type, current-player)
      val king-destination : location = get-king-destination-for-castling(current-castling-type, current-player)

      change-board(current-board, Figure(King(True), current-player, king-destination)) fn(current : figure) : bool
        current.figure-location == king-start-location || current.figure-location == king-destination

      val rook-start-location : location = get-rook-start-location-for-castling(current-castling-type, current-player)
      val rook-destination : location = get-rook-destination-for-castling(current-castling-type, current-player)

      change-board(current-board, Figure(Rook(True), current-player, rook-destination)) fn(current : figure) : bool
        current.figure-location == rook-start-location || current.figure-location == rook-destination
    _                                                                 -> ()

fun get-king-start-location-for-castling(current-castling-type : castling-type, current-player : player) : location
  match current-player
    White -> (4, 0)
    _     -> (4, 7)

fun get-king-destination-for-castling(current-castling-type : castling-type, current-player : player) : location
  match current-player
    White ->
      match current-castling-type
        Kingside -> (6, 0)
        _        -> (2, 0)
    _     ->
      match current-castling-type
        Kingside -> (6, 7)
        _        -> (2, 7)

fun get-rook-start-location-for-castling(current-castling-type : castling-type, current-player : player) : location
  match current-player
    White ->
      match current-castling-type
        Kingside -> (7, 0)
        _        -> (0, 0)
    _     ->
      match current-castling-type
        Kingside -> (7, 7)
        _        -> (0, 7)

fun get-rook-destination-for-castling(current-castling-type : castling-type, current-player : player) : location
  match current-player
    White ->
      match current-castling-type
        Kingside -> (5, 0)
        _        -> (3, 0)
    _     ->
      match current-castling-type
        Kingside -> (5, 7)
        _        -> (3, 7)

fun get-critical-locations-for-castling(current-castling-type : castling-type, current-player : player) : list<location>
  match current-player
    White ->
      match current-castling-type
        Kingside -> [(5, 0), (6, 0)]
        _        -> [(2, 0), (3, 0)]
    _     ->
      match current-castling-type
        Kingside -> [(5, 7), (6, 7)]
        _        -> [(2, 7), (3, 7)]

fun validate-castling(current-castling-type : castling-type, current-board : board, current-player : player) : bool
  if is-in-check(current-board, current-player) then return False

  match(find-figure(current-board, get-king-start-location-for-castling(current-castling-type, current-player), Just(current-player)),
        find-figure(current-board, get-rook-start-location-for-castling(current-castling-type, current-player), Just(current-player)))
    (Just(Figure(King(False), x, _)), Just(Figure(Rook(False), y, _)))
      | x == current-player && y == current-player ->
        is-nil(get-critical-locations-for-castling(current-castling-type, current-player).filter fn(current : location) : bool
          is-just(find-figure(current-board, current)) || is-threatened(current, current-board, current-player.opponent)
        )
    _                                              -> False

fun is-in-check(current-board : board, current-player : player) : bool
  match current-board.figures.find(fn(current : figure) current.figure-type == King() && current.figure-player == current-player)
    Just(Figure(_, _, current-location)) -> is-threatened(current-location, current-board, current-player.opponent)
    _                                    -> False

fun validate-input-turn(current-action : turn-action, current-board : board, can-offer-draw : bool = True) : bool
  match current-action
    Move(x, to-location)                            ->
      match valid-moves(x, current-board).find(fn(current : location) current == to-location)
        Just(_) ->
          val test-board = ref(current-board)
          perform-turn(test-board, current-action)
          !is-in-check(!test-board, x.figure-player)
        _       -> False
    Castling(current-castling-type, current-player) -> validate-castling(current-castling-type, current-board, current-player)
    DrawOffer                                       -> can-offer-draw
    _                                               -> True

fun input-turn(current-board : board, current-player : player, can-offer-draw : bool = True, invalid-input-warning : string = default-invalid-input-warning) : <div, execution-method, read-input-turn> turn-action
  custom-print(current-player.show ++ "'s turn: ")

  match read-input-turn(current-player, current-board)
    Just(x)
      | validate-input-turn(x, current-board, can-offer-draw) -> x
    _                                                         ->
      // custom-println("\n" ++ current-board.show) // Prints the board after an invalid input.
      custom-println("\n" ++ invalid-input-warning ++ "\n")
      input-turn(current-board, current-player, can-offer-draw, invalid-input-warning)

fun turn(current-board : ref<h, board>, current-player : player, current-history : ref<h, list<game-state>>, can-offer-draw : bool = True) : <div, execution-method, read<h>, read-input-draw-offer, read-input-pawn-promotion, read-input-turn, show-board, write<h>> maybe<player>
  custom-println(show-board(!current-board))
  custom-println("")
  
  val current-action : turn-action = input-turn(!current-board, current-player, can-offer-draw)
  custom-println("")

  match current-action
    Move(Figure(Pawn, _, _), _) -> current-history := []
    Move(_, to-location)        -> if is-just(find-figure(!current-board, to-location, Just(current-player.opponent))) then current-history := []
    _                           -> ()

  perform-turn(current-board, current-action)

  val current-opponent : player = current-player.opponent

  match current-action
    Surrender -> Just(current-opponent)
    DrawOffer -> 
      val response : bool = input-draw-offer(current-player)
      custom-println("")
      
      if response then Nothing else turn(current-board, current-player, current-history, False)
    _         ->
      match check-for-pawn-promotion(!current-board, current-player)
        Just(current-location) ->
          val new-figure : figure = Figure(pawn-promotion-to-figure-type(input-pawn-promotion(current-location, current-player)), current-player, current-location)
          custom-println("")

          current-board := Board(Cons(new-figure, (!current-board).figures.remove(fn(current : figure) current.figure-location == current-location)))
        _                      -> ()

      if !has-valid-moves(!current-board, current-opponent) &&
         !validate-castling(Kingside, !current-board, current-opponent) &&
         !validate-castling(Queenside, !current-board, current-opponent)
      then
        custom-println(show-board(!current-board))
        custom-println("")

        return if is-in-check(!current-board, current-opponent) then Just(current-player) else Nothing

      current-board := Board((!current-board).figures.remove-en-passant(current-opponent))

      current-history := Cons(Game-state(current-opponent,
                                         !current-board,
                                         validate-castling(Kingside, !current-board, White),
                                         validate-castling(Kingside, !current-board, Black),
                                         validate-castling(Queenside, !current-board, White),
                                         validate-castling(Queenside, !current-board, Black)),
                              !current-history)

      fun count-occurences(current-game-state : game-state, history : list<game-state>) : int
        match history
          Cons(head, tail)
            | head == current-game-state -> 1 + count-occurences(current-game-state, tail)
            | _                          -> count-occurences(current-game-state, tail)
          _                              -> 1

      if (!current-history).length > 100 || is-cons((!current-history).map-peek(count-occurences).filter(fn(current : int) current >= 3))
      then
        custom-println(show-board(!current-board))
        custom-println("")

        return Nothing

      turn(current-board, current-opponent, current-history)

pub fun game(initial-player : player) : <div, execution-method, read-input-draw-offer, read-input-pawn-promotion, read-input-turn, show-board> maybe<player>
  turn(ref(Board()), initial-player, ref([Game-state(initial-player, Board(), False, False, False, False)]))
