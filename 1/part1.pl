:- ensure_loaded('data.pl').

% password(+CurrentDialPosition, +ListOfMoves, +CurrentPasswordCounter, -FinalPassword)
password(_, [], Password, Password).
password(CurrentPos, [Move | ListMoves], Password, Answer) :-
    apply_move(CurrentPos, Move, NextPos),
    recursive_password(NextPos, ListMoves, Password, Answer).

% recursive_password(+MovedToDialPosition, +ListOfMoves, +CurrentPasswordCounter, -FinalPassword)
recursive_password(0, ListMoves, Password, Answer) :-
    NewPassword is Password + 1,
    password(0, ListMoves, NewPassword, Answer).
recursive_password(Pos, ListMoves, Password, Answer) :-
    Pos \= 0,
    password(Pos, ListMoves, Password, Answer).

% apply_move(+CurrentDialPosition, +Move, -NextDialPosition)
% Move is the number of steps to move (left < 0, right > 0)
apply_move(CurrentPos, Move, NextPos) :-
    AuxPos is CurrentPos + Move,
    NextPos is AuxPos mod 100.

% parse_moves(+RawMoves, -Moves)
parse_moves([], []).
parse_moves([RawMove | RawMoves], [Move | Moves]) :-
    % Extract the first char from RawMove into SideChar, and leave the rest on StepsStr
    string_chars(RawMove, [SideChar | StepsStr]),
    % Converts the string to int (StepsStr -> Steps) 
    number_string(Steps, StepsStr),
    % Uses the SideChar to decide whether Steps is Negative (L) or Positive (R)
    apply_sign(SideChar, Steps, Move),
    parse_moves(RawMoves, Moves).

% apply_sign(+Side, +Steps, -Move)
apply_sign('L', Steps, Move) :-
    Move is -Steps.
apply_sign('R', Steps, Move) :-
    Move is +Steps.

% part1
part1 :-
    input_moves2(RawMoves),
    parse_moves(RawMoves, Moves),
    password(50, Moves, 0, Password),
    nl,
    write(Password).
