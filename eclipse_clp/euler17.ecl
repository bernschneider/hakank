%
% Problem 17
% """
% If the numbers 1 to 5 are written out in words: one, two, three,
% four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
%
% If all the numbers from 1 to 1000 (one thousand) inclusive were 
% written out in words, how many letters would be used?
%
% NOTE: Do not count spaces or hyphens. For example, 342 (three 
% hundred and forty-two) contains 23 letters and 115 (one hundred and
% fifteen) contains 20 letters. The use of "and" when writing out
% numbers is in compliance with British usage.
% """
% 
% Answer: 21124
% (0.0s)
% 

:- lib(util).

go :-
  problem17,
  problem17b.

digit(1,"one").
digit(2,"two").
digit(3,"three").
digit(4,"four").
digit(5,"five").
digit(6,"six").
digit(7,"seven").
digit(8,"eight").
digit(9,"nine").

teens(10,"ten").
teens(11,"eleven").
teens(12,"twelve").
teens(13,"thirteen").
teens(14,"fourteen").
teens(15,"fifteen").
teens(16,"sixteen").
teens(17,"seventeen").
teens(18,"eighteen").
teens(19,"nineteen").

tens(20,"twenty").
tens(30,"thirty").
tens(40,"forty").
tens(50,"fifty").
tens(60,"sixty").
tens(70,"seventy").
tens(80,"eighty").
tens(90,"ninety").

hundred(100,"onehundred").
thousand(1000,"onethousand").

% fix
spell(0, "") :- !.

% 1..10
spell(N,Spell) :-
        N > 0,
        N < 10, !,
        digit(N,Spell), !.

% 10..19
spell(N, Spell) :-
        N > 9,
        N < 20,
        teens(N,Spell), !.

% 20..99
spell(N, Spell) :-
        N >= 20,
        N < 100,
        D is 10*(N//10),
        tens(D,Ten),
        M is N mod 10,
        (M > 0 -> digit(M, One) ; One = ""),
        concat_string([Ten,One],Spell), !.

% 100.999
spell(N, Spell) :-
        N >= 100,
        N < 1000,
        Hundred is (N//100),
        digit(Hundred,Hundred1),
        M is N mod 100,
        spell(M, Ones),
        ( M > 0 -> AndStr = "and" ; AndStr = ""),
        concat_string([Hundred1,"hundred",AndStr,Ones],Spell), !.

% 1000
spell(1000, "onethousand") :- !.

% (0.0s)
problem17 :-
        ( for(I,1,1000),
          fromto(Res,Out,In,[]) do 
              spell(I,Spell), 
              Out = [Spell|In]
        ), 
        concat_string(Res,S), 
        string_length(S,Len),
        writeln(Len).

% using findall and between
% (0.00s)
problem17b :-
        findall(Spell, 
                (between(1,1000,N), spell(N,Spell)), 
                L),
        concat_string(L, Str),
        string_length(Str, Len),
        writeln(Len).

