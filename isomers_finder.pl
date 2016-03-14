
%============================================================================
% Namer       : isomers-finder
% Author      : Ahmed Ashraf Awwad 
% ID          : 31-14959
% Version     : 1.0
% Copyright   : MIT
%============================================================================

%------------------------------First Point-------------------------------------------

build_straight_chain_alkane(1,[carb(c,h,h,h)]).
build_straight_chain_alkane(X,[carb(c,h,h,c)|T]):-
		X>1,X2 is X-1,build_straight_chain_alkane(X2,T).
straight_chain_alkane(1,[carb(h,h,h,h)]).
straight_chain_alkane(X,[carb(h,h,h,c)|T]):-
		X>1,X2 is X-1,build_straight_chain_alkane(X2,T).	
%-------------------------------Second Point------------------------------------------


%-------------------------------Helpers-----------------------------------------------
branch_name(S,N):- 
		HS is S*2+1,atomic_list_concat([c,S,h,HS],N).

branch_number(S,N,S):- 
		branch_name(S,N).

branch_number(S,N,Z):- 
  		S1 is S+1 , branch_name(S,N1),N \= N1,branch_number(S1,N,Z).

min(A,B,B):-
 		A>=B.

min(A,B,A):-
 		A<B.
check_longest_chain(_,[]).

check_longest_chain(N,[carb(c,A,B,_)|T]):-
		N1 is N+1 , ((B=h, A\=h ,branch_number(1,A,Z),O1 is N+Z+1,
		length(T,Y),O2 is N+Y+1 ,min(O1,O2,O1));
		(B \= h , branch_number(1,B,Z),O1 is N+Z+1,length(T,Y),O2 is N+Y+1 ,
		min(O1,O2,O1);(B=h,A=h))),check_longest_chain(N1,T).

loop(Q,N,T,N):-
		Q>=N,N \=0,branch_name(N,T).

loop(Q,N,T,B):-
		N2 is N+1,Q>=N2,loop(Q,N2,T,B).

%-------------------------------Builders-----------------------------------------------

build2(_,1,[carb(c,h,h,h)]).

build2(Qc,Q,[carb(c,A,B,c)|T]):-
		Q>1,(A=h,B=h,Qm is Q-1,Qr is Qc+1,build2(Qr,Qm,T)).


build2(Qc,Q,[carb(c,A,B,c)|T]):-
		Q>1,(R is Qc+1,Qm is Q-1,Qh is Qm/2,min(Qc,Qh,U),B=h,
		loop(U,0,A,Q2),Qd is Qm-Q2,build2(R,Qd,T));
		(R is Qc+1,Qm is Q-1,Qh is Qm / 2,min(Qc,Qh,U),
		loop(U,0,B,Q2),Qd is Qm-Q2,Qt is Qd / 2,min(Qt,Q2,F),
       S1 is R+Q2 ,loop(F,0,A,Q3),Qf is Qd-Q3 ,S2 is R + Qf,min(S1,S2,S1) , build2(R,Qf,T)).

branched_alkane(Q,[carb(h,h,h,c)|T]):- 
	   Q > 3,X is Q-1,build2(1,X,T),length(T,K),K\=X ,check_longest_chain(1,T).

%-------------------------------Third Point------------------------------------------

%-------------------------------Helpers------------------------------------------
distinct([],[]).

distinct([H|T],C) :-
		(reverse(H, Z), drop(Z,X),member(X,T),!,distinct(T,C)). 

distinct([H|T],[H|C]) :- reverse(H, Z), drop(Z,X), \+member(X,T),
		 distinct(T,C).

drop2([carb(h,h,h,c)|[]],[carb(c,h,h,h)|[]]).

drop2([H|T],[H|T2]):-T \=[] ,drop2(T,T2).

drop([_|T],[carb(h,h,h,c)|T2]):-
		drop2(T,T2).


%-------------------------------Builders------------------------------------------

isomers(Q,[T2|A]):-
	findall(H, branched_alkane(Q,H),R),
	reverse(R,T),straight_chain_alkane(Q,T2),distinct(T,A).

%-------------------------------End Of Stroy------------------------------------------

