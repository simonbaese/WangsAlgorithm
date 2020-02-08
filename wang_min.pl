% Automated Theorem Proving
% Wang's Algorithm

% Define operators.
:-op(700,xfy,<->).
:-op(700,xfy,->).
:-op(600,xfy,v).
:-op(600,xfy,&).
:-op(500,fy,!).

% Main call.
prove([],[]):-nl.
prove([L|P],[R|A]):-
	nl, write(L), write(' |= '), write(R), nl,
	wang(L,R),
	prove(P,A).

% Procedure of Wang to prove theorem.
wang(L,R):-
	rules(L,R),
	write('TRUE'), nl.
wang(_,_):-
	write('FALSE'), nl.

% Move negations from left to right.
rules(L,R):-
	member(!X,L),
	delete(L,!X,Ld),
	rules(Ld,[X|R]).

% Move negations from right to left.
rules(L,R):-
	member(!X,R),
	delete(R,!X,Rd),
	rules([X|L],Rd).

% Replace conjunction by commas on the left.
rules(L,R):-
	member(X & Y,L),
	delete(L,X & Y,Ld),
	rules([X,Y|Ld],R).

% Replace disjunction by commas on the right.
rules(L,R):-
	member(X v Y,R),
	delete(R,X v Y,Rd),
	rules(L,[X,Y|Rd]).

% Branch disjunction on the left.
rules(L,R):-
	member(X v Y,L),
	delete(L,X v Y,Ld),
	rules([X|Ld],R),
	rules([Y|Ld],R).

% Branch conjunction on the right.
rules(L,R):-
	member(X & Y,R),
	delete(R,X & Y, Rd),
	rules(L,[X|Rd]),
	rules(L,[Y|Rd]).

% Replace implication on the left.
rules(L,R):-
	member(X -> Y,L),
	delete(L,X -> Y,Ld),
	rules([!X v Y|Ld],R).

% Replace implication on the right.
rules(L,R):-
	member(X -> Y,R),
	delete(R,X -> Y,Rd),
	rules(L,[!X v Y|Rd]).

% Replace equivalence on the left.
rules(L,R):-
	member(X <-> Y,L),
	delete(L,X <-> Y,Ld),
	rules([(X -> Y) & (Y -> X)|Ld],R).

% Replace equivalence on the right.
rules(L,R):-
	member(X <-> Y,R),
	delete(R,X <-> Y,Rd),
	rules(L,[(X -> Y) & (Y -> X)|Rd]).

% Finally compare both sides.
rules(L,R):-
	member(X,L),
	member(X,R).
