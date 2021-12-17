% Automated Theorem Proving
% Wangs Algorithm

% Define operators.
:-op(700,xfy,<->).
:-op(700,xfy,->).
:-op(600,xfy,v).
:-op(600,xfy,&).
:-op(500,fy,!).

% Main call.
prove([],[]).
prove([L|P],[R|A]):-
	nl, ansi_format([bold],'Statement: ',[]), write(L), write(' |= '), write(R), nl, nl,
	ansi_format([bold],'Attempting proof!',[]), nl, nl,
	wang(L,R),
	prove(P,A).

% Procedure of Wang to prove theorem.
wang(L,R):-
	rules(L,R,[],0), nl,
	ansi_format([bold,fg(green)], 'Result: The given theorem is true.',[]), nl, nl;
	ansi_format([bold, fg(red)],'Proof failed for current step!',[]), nl, nl,
	ansi_format([bold,fg(red)], 'Result: The given theorem is false.',[]), nl, nl.

% Move negations from left to right.
rules(L,R,S,T):-
	member(!X,L),
	select(!X,L,Ld),
	append(S,[[['*Rule 1L                 '],[Ld,' |= ',[X|R]],T]],Sa),
	rules(Ld,[X|R],Sa,T).

% Move negations from right to left.
rules(L,R,S,T):-
	member(!X,R),
	select(!X,R,Rd),
	append(S,[[['*Rule 1R                 '],[[X|L],' |= ',Rd],T]],Sa),
	rules([X|L],Rd,Sa,T).

% Replace conjunction by commas on the left.
rules(L,R,S,T):-
	member(X & Y,L),
	select(X & Y,L,Ld),
	append(S,[[['*Rule 2                  '],[[X,Y|Ld],' |= ',R],T]],Sa),
	rules([X,Y|Ld],R,Sa,T).

% Replace disjunction by commas on the right.
rules(L,R,S,T):-
	member(X v Y,R),
	select(X v Y,R,Rd),
	append(S,[[['*Rule 3                  '],[L,' |= ',[X,Y|Rd]],T]],Sa),
	rules(L,[X,Y|Rd],Sa,T).

% Branch disjunction on the left.
rules(L,R,S,T):-
	member(X v Y,L),
	select(X v Y,L,Ld),
	Ta is T + 1,
	append(S,[[['*Rule 4a - Branch Level ',T],[[X|Ld],' |= ',R],T]],Sa),
	rules([X|Ld],R,Sa,Ta),
	Tb is T + 1,
	append([],[[['*Rule 4b - Branch Level ',T],[[Y|Ld],' |= ',R],T]],Sb),
	rules([Y|Ld],R,Sb,Tb).

% Branch conjunction on the right.
rules(L,R,S,T):-
	member(X & Y,R),
	select(X & Y,R,Rd),
	append(S,[[['*Rule 5a - Branch Level ',T],[L,' |= ',[X|Rd]],T]],Sa),
	Ta is T + 1,
	rules(L,[X|Rd],Sa,Ta),
	Tb is T + 1,
	append([],[[['*Rule 5b - Branch Level ',T],[L,' |= ',[Y|Rd]],T]],Sb),
	rules(L,[Y|Rd],Sb,Tb).

% Replace implication on the left.
rules(L,R,S,T):-
	member(X -> Y,L),
	select(X -> Y,L,Ld),
	append(S,[[['*Rule 6L                 '],[[!X v Y|Ld],' |= ',R],T]],Sa),
	rules([!X v Y|Ld],R,Sa,T).

% Replace implication on the right.
rules(L,R,S,T):-
	member(X -> Y,R),
	select(X -> Y,R,Rd),
  append(S,[[['*Rule 6R                 '],[L,' |= ',[!X v Y|Rd]],T]],Sa),
	rules(L,[!X v Y|Rd],Sa,T).

% Replace equivalence on the left.
rules(L,R,S,T):-
	member(X <-> Y,L),
	select(X <-> Y,L,Ld),
	append(S,[[['*Rule 7L                 '],[[(X -> Y) & (Y -> X)|Ld],' |= ',R],T]],Sa),
	rules([(X -> Y) & (Y -> X)|Ld],R,Sa,T).

% Replace equivalence on the right.
rules(L,R,S,T):-
	member(X <-> Y,R),
	select(X <-> Y,R,Rd),
	append(S,[[['*Rule 7R                 '],[L,' |= ',[(X -> Y) & (Y -> X)|Rd]],T]],Sa),
	rules(L,[(X -> Y) & (Y -> X)|Rd],Sa,T).

% Finally compare both sides.
rules(L,R,S,T):-
	append(S,[[['*Tautology?              '],[L,' |= ',R], T]],Sa),
	member(X,L),
	member(X,R),
	append(Sa,[[['*True.                   '],[],T]],Sb),
	printprove(Sb).

% If theorem is true then print prove.
printprove([]).
printprove([[P,Q,T]|S]):-
  tab(T*5), printlist(P), tab(40 - T*5), printlist(Q), nl,
	printprove(S).

% Helper for printing list recursively.
printlist([]).
printlist([H|T]):-
	write(H),
	printlist(T).
