% 
% Skyscraper puzzle in MiniZinc.
% 
% http://www.puzzlepicnic.com/genre?flats
% http://www.puzzlepicnic.com/puzzle?909
%

% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc

include "globals.mzn"; 

int: n;
array[1..n] of var 1..n: cu; % column upper
array[1..n] of var 1..n: cl; % column lower
array[1..n] of var 1..n: rl; % row left
array[1..n] of var 1..n: rr; % row right

array[1..n, 1..n] of var 1..n: x;


%
% num_increasing:
% number of seen skyscrapes
% 
predicate num_skyscrapes(array[1..n] of var 1..n: y, var 1..n: num) =
    let {
        var 1..n: n_pos
    }
    in 
    y[n_pos] = n % identify position of n (the "stop value")
    /\
    num <= n_pos /\
    num <= n-y[1]+1 /\
    % count the number of cells where y[i] is larger than all y[1..i-1]
    num = 1 + sum(i in 2..n) (
                 bool2int(i<=n_pos/\sum([bool2int(y[i] > y[j]) | j in 1..i-1]) = i-1)
               )
;

%
% reverses an array from -> to
%
predicate reverse(array[1..n] of var 1..n: from, array[1..n] of var 1..n: to) =
   forall(i in 1..n) (
      to[i] = from[n-i+1]
   )

;

% arrays of 2d where both arguments are var int
predicate cp2d(array[int,int] of var int: x, array[int,int] of var int: y) =
  assert(index_set_1of2(x) = index_set_1of2(y) /\
         index_set_2of2(x) = index_set_2of2(y),
           "cp2d: x and y have different sizes",
     forall(i in index_set_1of2(x), j in index_set_2of2(x)) (
         y[i,j] = x[i,j]
    ) 
  )
; 


% solve satisfy;
solve :: int_search([x[i,j] | i,j in 1..n], first_fail, indomain_min, complete) satisfy;

constraint
    % It's a latin square
    forall(i in 1..n) (
       all_different([x[i,j] | j in 1..n]) % :: domain
       /\
       all_different([x[j,i] | j in 1..n]) % :: domain
    )
;

constraint
    % check the row and column constraints
     forall(i in 1..n) (
       let {
         array[1..n] of var 1..n: rl_a,
         array[1..n] of var 1..n: rr_a,
         array[1..n] of var 1..n: cu_a,
         array[1..n] of var 1..n: cl_a,
       }
       in 
       % rows
       forall(j in 1..n) (rl_a[j] = x[i,j])
       /\  
       num_skyscrapes(rl_a, rl[i]) /\
       reverse(rl_a, rr_a) /\
       num_skyscrapes(rr_a, rr[i])

       /\ % columns
       forall(j in 1..n) (cu_a[j] = x[j,i]) /\
       num_skyscrapes(cu_a, cu[i]) /\

       reverse(cu_a, cl_a) /\
       num_skyscrapes(cl_a, cl[i])
     )

;

%
% Puzzle:
%   1 2 2 3
% 1         4
% 3         2
% 2         2
% 3         1
%   3 2 2 1
% 
% Solution:
%   1 2 2 3
% 1 4 3 2 1 4 
% 3 1 2 4 3 2 
% 2 3 4 1 2 2 
% 3 2 1 3 4 1
%   3 2 2 1
%
% n = 4;
% cu = [1,2,2,3];
% cl = [3,2,2,1];
% rl = [1,3,2,3];
% rr = [4,2,2,1];

% http://www.puzzlepicnic.com/puzzle?900
%%cu = [_,_,_,_,_];
%%cl = [_,_,_,_,_];
% rl = [5,2,3,1,2];
% rr = [1,4,2,4,2];

% http://logicgames.blogspot.com/2008/06/skyscraper.html
% n = 4;
% cu = [_,1,2,_];
% cl = [_,_,_,_];
% rl = [_,3,3,_];
% rr = [_,_,2,_];


% From
% http://stackoverflow.com/questions/22096963/waffle-stacking-puzzle-algorithm
% n = 5;
% cu = [2,2,3,2,1];
% cl = [3,2,1,3,4];
% rl = [4,1,3,2,3];
% rr = [1,4,2,2,2];

% From 
% http://www.puzzlemix.com/playgrid.php?id=74166&type=sky&share=1
% (Skyscraper-5 87)
% n = 5;
% cu = [4,_,_,_,4];
% cl = [_,2,3,_,_];
% rl = [_,_,_,_,_];
% rr = [3,_,_,_,2];


% From http://www.brainbashers.com/showskyscraper.asp
% Apr 12 Easy 6x6
% Note: This instance has hints as well.
% (If no hints are given there are 60 solutions.)
% n = 6;
% cu = [4,2,1,2,2,3];
% cl = [2,2,4,3,2,1];
% rl = [3,2,2,2,1,4];
% rr = [4,2,3,3,3,1];

% % % given hints
% constraint
%   cp2d(x, array2d(1..n, 1..n,
% [
%   _,_,_,_,2,_,
%   _,_,2,_,_,_,
%   1,_,_,_,_,_,
%   _,_,_,6,_,_,
%   _,_,4,_,_,_,
%   _,_,1,_,_,_, 
% ]))
% ;


% http://www.brainbashers.com/showskyscraper.asp
% Nov 03 Hard 7x7 [Random]
% With hints
n = 7;
cu = [_,3,_,_,4,4,3];
cl = [5,4,_,3,_,_,2];
rl = [2,_,_,7,_,3,_];
rr = [_,3,3,_,2,_,_];

% % given hints
constraint
  cp2d(x, array2d(1..n, 1..n,
[
  _,_,_,_,_,_,_,
  _,_,_,_,_,3,_,
  _,_,_,_,_,_,_,
  _,_,_,_,_,_,_,
  _,_,_,_,_,_,_,
  _,_,_,2,_,_,_,
  _,_,_,_,_,_,_
]))
;



output 
[
 if j = 1 then "\n" else " " endif ++
   show(x[i,j])
 | i,j in 1..n
] ++ ["\n"]
;
