% Automated Theorem Proving
% Wangs Algorithm

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
	write('TRUE').
wang(_,_):-
	write('FALSE').

% Move negations from left to right.
rules(L,R):-
	member(!X,L),
	select(!X,L,Ld),
	rules(Ld,[X|R]).

% Move negations from right to left.
rules(L,R):-
	member(!X,R),
	select(!X,R,Rd),
	rules([X|L],Rd).

% Replace conjunction by commas on the left.
rules(L,R):-
	member(X & Y,L),
	select(X & Y,L,Ld),
	rules([X,Y|Ld],R).

% Replace disjunction by commas on the right.
rules(L,R):-
	member(X v Y,R),
	select(X v Y,R,Rd),
	rules(L,[X,Y|Rd]).

% Branch disjunction on the left.
rules(L,R):-
	member(X v Y,L),
	select(X v Y,L,Ld),
	rules([X|Ld],R),
	rules([Y|Ld],R).

% Branch conjunction on the right.
rules(L,R):-
	member(X & Y,R),
	select(X & Y,R,Rd),
	rules(L,[X|Rd]),
	rules(L,[Y|Rd]).

% Replace implication on the left.
rules(L,R):-
	member(X -> Y,L),
	select(X -> Y,L,Ld),
	rules([!X v Y|Ld],R).

% Replace implication on the right.
rules(L,R):-
	member(X -> Y,R),
	select(X -> Y,R,Rd),
	rules(L,[!X v Y|Rd]).

% Replace equivalence on the left.
rules(L,R):-
	member(X <-> Y,L),
	select(X <-> Y,L,Ld),
	rules([(X -> Y) & (Y -> X)|Ld],R).

% Replace equivalence on the right.
rules(L,R):-
	member(X <-> Y,R),
	select(X <-> Y,R,Rd),
	rules(L,[(X -> Y) & (Y -> X)|Rd]).

% Finally compare both sides.
rules(L,R):-
	member(X,L),
	member(X,R).
