:- ensure_loaded('data.pl').

% password(+CurrentDialPosition, +ListOfMoves, +CurrentPasswordCounter, -FinalPassword)
password(_, [], Password, Password).
password(CurrentPos, [Move | ListMoves], Password, Answer) :-
    apply_move(CurrentPos, Move, NextPos),
    calculate_new_password(CurrentPos, Move, NextPos, Password, NewPassword),
    password(NextPos, ListMoves, NewPassword, Answer).

% calculate_new_password(+CurrentPos, +Move, +NextPos, +Password, -NewPassword)
calculate_new_password(CurrentPos, Move, NextPos, Password, NewPassword) :-
    AuxRotations is Move // 100,
    CompleteRotations is abs(AuxRotations),
    extra_rotation(CurrentPos, NextPos, Move, ExtraRotation),
    NewPassword is Password + CompleteRotations + ExtraRotation.

% extra_rotation(+CurrentPos, +NextPos, +Move, -ExtraRotation)
extra_rotation(CurrentPos, 0, _,  1) :-
    CurrentPos \= 0.
extra_rotation(0, NextPos, _, 0) :-
    NextPos \= 0.
extra_rotation(CurrentPos, NextPos, _, 0) :-
    CurrentPos =:= NextPos.
extra_rotation(_, _, 0, 0).
%% moving right
extra_rotation(CurrentPos, NextPos, Move, 1) :-
    Move > 0,
    CurrentPos > NextPos.
extra_rotation(CurrentPos, NextPos, Move, 0) :-
    Move > 0,
    CurrentPos < NextPos.
%% moving left
extra_rotation(CurrentPos, NextPos, Move, 1) :-
    Move < 0,
    CurrentPos < NextPos.
extra_rotation(CurrentPos, NextPos, Move, 0) :-
    Move < 0,
    CurrentPos > NextPos.

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

% part2
part2 :-
    input_moves2(RawMoves),
    parse_moves(RawMoves, Moves),
    password(50, Moves, 0, Password),
    nl,
    write(Password).
