% 
% Quasigroup completion problem in MiniZinc.
% 

% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

include "quasigroup_completion_model.mzn"; 

n = 10;
constraint

    % Problem from http://www.cs.cornell.edu/gomes/QUASIdemo.html
    % (n = 10)
    % Pattern #1. 
    % There are _many_ solutions to this problem.
    cp2d(x, array2d(1..n, 1..n, 
    [
      _,_,_,1,_,_,_,_,_,_,
      _,_,1,_,_,_,_,_,_,_,
      _,1,_,_,_,2,_,_,_,_,
      1,_,_,_,2,_,_,_,_,_,
      _,_,_,2,1,_,_,_,_,_,
      _,_,2,_,_,1,_,_,_,_,
      _,_,_,_,_,_,1,_,_,_,
      _,_,_,_,_,_,_,1,_,2,
      _,_,_,_,_,_,_,_,2,_,
      _,_,_,_,_,_,_,2,_,_,
    ]))

;

