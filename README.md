# Isomers_finder  with prolog!


##The method of thinking  :

###part A :-

  I build it using greedy Approach which the first carbon is carb(h,h,h,c) and any N-2 carbons are carb(c,h,h,c)  ..(where N is the number of total Carbon atoms )and the last one is carb(c,h,h,h) ...but there is one special case which the N ==1 so i handle this. (more details in the predicates description).

###Part B :-
  I am generat some possible N-carbons’ permutations (where N is the total number of Carbon) and filter them to undergo the rules of branched_alkane stated in the project description ...mainly i have Three possible movements (stats) for a Carbon atom which is not the first nor the last Carb(_,U,D,_)...the stats are :-
    * Put Carbons in the U.
    * Put Carbons in the U and D (where Nu<=Nd).
    * Don’t put Carbons (U =D=h).
for the last state we can find a special Case which all carbons undergo the last stat (give me straight chain alkane) i handle this .
Lets Go for the first two stats ……..How Can i decide the possible Nu and Nd ??:--
Assume :
  * N  is the total number of Carbon
  * Nc is number of Carbon in the main chain (Longest one).
  * Nb is the number of Carbon befor the ith Carbon.
  * Na is the number of Carbon after the ith Carbon.
  * Fact Na+Nb+1 = Nc (where 1 is  ith Carbon).
  * Nu is the number of Carbons in the top brunch of ith Carbon.
  * Nd is the number of Carbons in the Down branch of ith Carbon.
  * Cr is the number of Carbons remained to build the chain at ith Carbon where Nu=0.

if we apply the rules of branched_alkane in the stats:-

  * Nu<=Na and Nu<=Nb so Nu<=min(Na,Nb) if i assume that i am at ith Carbon the i am sure of the value of Nb (i already build it) but i am don’t build Na.
  we have now two possible scenarios the first one is that No Na Carbons will
  Carry a Carbon so Nu<=Cr/2 (satisfy the rules )...this is good one but the unwanted scenario that some of Na Carry Carbon which make Nu>Na this don’t undergo the rules so i used a helper method to remove them.
  Ex @ N = 10 this is one of the unwanted output :-
  [carb(h,h,h,c),carb(c,h,h,c),carb(c,h,h,c),carb(c,c3h7,h,c),carb(c,c1h3,h,c),carb(c,h,h,h)]
  so  i made a method which filter the output and test that the main branch keep the longest branch .

 * Nu<=Nd and Nd<=Na and Nd<=Nb for that i take for the Down branch first for it’s possible Carbons and loop for the up to give it all possible carbons less than the down and make sure the Down is <= the Cr  …. but the same problem take Place we don’t know Na this is the source of unwanted output.
###Part C :-
I find all the solution of the N and put them in set and delete the mirrors from the set  using helper methods .

##Methods
###Part A :-
    - Helpers :-
        - build_straight_chain_alkane :- which put the N-2 Carbons “carb(c,h,h,c)” and last one “carb(c,h,h,h)” .
        - Base_Case:- Cr is 1
        - Parameters (Cr_sofar,[H|T]).
    - Builders :-
        - straight_chain_alkane :- it call”build_straight_chain_alkane” if N >1 else it return “carb(h,h,h,h)”.
###Part B :-
    - Helpers :-
      - branch_name:- which take N and give T  it’s chemical formula based on Hydrogen atoms .
      - branch_number:-which take the C-H compound and give  the number of carbon.
      - min:- which find the min between two numbers
      - check_longest_chain :- test the output of the main builder
      it will true if and only if the main branch is longest branch.
      - loop:- which generate the branch_names form 0 to n

    - Builders :-
      - build2_Base :-which put carb(c,h,h,h) at the end when Cr = 1
      - build2_First stat:- it put Up and Down with h
      - build2_Second stat:- it put for Up branch the possible Carbon and for Down h.
      - build2_third stat :- it Assen Nd with range of possible values and Nu take from the remain to keep the constraints fulfill and must keep the condition that Nd >=Nu.
      - branched_alkane:- only work When N >3 and it filter the output of the Build2 by using check_longest_chain to get rid of unwanted outputs and length(T,M),M\=N-1 to get rid of unwanted straight chain .
###Part C :-
    - Helpers :-
      - distinct :- which remove mirrors from the list it recurse on the list if the mirror of H is fund it Don’t take it and i used ! to Cut the operation.
      - drop2 :- it Change first and the last Carbon to fit the reversed list to get a fine output when i call member.
    - Builders :-
      - isomers :- it find all possible branched alkane and get the output of the distinct helper when it take set Of Solution as input and Concatenate the ans with the Straight Chain of N.
