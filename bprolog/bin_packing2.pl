/*

  Global constraint bin_packing in B-Prolog.

  From Global Constraint Catalogue
  http://www.emn.fr/x-info/sdemasse/gccat/sec4.35.html
  """
  Given several items of the collection ITEMS (each of them having a specific 
  weight), and different bins of a fixed capacity, assign each item to a bin 
  so that the total weight of the items in each bin does not exceed CAPACITY.
  
  Example
    <(5,<bin-3 weight-4, bin-1 weight-3,bin-3 weight-1>)>
  
   The bin_packing constraint holds since the sum of the height of items 
  that are assigned to bins 1 and 3 is respectively equal to 3 and 5. 
  The previous quantities are both less than or equal to the maximum 
  CAPACITY 5. Figure 4.35.1 shows the solution associated with the example.
  
  Remark
  
  Note the difference with the classical bin-packing problem [MT90] where 
  one wants to find solutions that minimise the number of bins. In our 
  case each item may be assigned only to specific bins (i.e., the different 
  values of the bin variable) and the goal is to find a feasible solution. 
  This constraint can be seen as a special case of the cumulative 
  constraint [AB93], where all task durations are equal to 1.
  """

  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/



/*
  From the ECLiPSe model:
  """
  This is also a study of translating a simple predicate from MiniZinc to 
  ECLiPSe. Here is the MiniZinc code, n is the size of weights and bins:
   forall(b in 1..n) (
      sum(j in 1..n) ( weights[j]*bool2int(bins[j] = b)) <= capacity
   )
 
  Using the same approach as MiniZinc, I prefer version 2 to version 1,
  since it is more succint. I prefer version 2 to version 3 since it
  is clearer.
  
  Note that both the MiniZinc version and this ECLiPSe version are
  fully multidirectional, i.e. we can let either (or all) of the
  variables be free and it still work.
  If we let Bins free, we must fix the length of it (to 3 in the
  example).
  """

*/

go :-
        foreach(Problem in 1..2,
                Predicate in [bin_packing1, bin_packing2],
                (format("Problem ~d using ~w\n", [Problem,Predicate]),
                 do_problem(Problem,Predicate)
                )),
        nl.

 
do_problem(Problem, Predicate) :-
        % we let the Capacity be unknown
        problem(Problem,Bins, Weights,_Capacity),
        % N = 3, % if Bins is free we must set the length of it

        length(Weights,N),
        length(Bins,N),

        % Bins :: 1..N,

        % Weights :: 1..4,

        % Capacity = 5,
        Capacity :: 1..20,

        % bin_packing3(Bins,Weights,Capacity),
        
        % bin_packing2(Bins,Weights,Capacity),
        Args = [Bins,Weights,Capacity],
        Goal =.. [Predicate|Args],
        
        call(Goal),

        term_variables([Capacity,Weights,Bins],Vars),
        minof(labeling(Vars),Capacity),

        writeln(capacity:Capacity),
        writeln(bins:Bins),
        writeln(weights:Weights),
        nl.
 
  

% The example cited above
problem(1, [3,1,3], [4,3,1], 5).
% another example
problem(2, [3,1,3,2,2,1,2,3], [4,3,1,3,4,3,1,2], 5).


% version 1, using list comprehension
bin_packing1(Bins, Weights, Capacity) :-
        length(Bins,N),
        length(Weights,N),
        foreach(B in 1..N,
                sum([(Weights[J]*(Bins[J] #= B)) : J in 1..N ]) #=< Capacity
        ).

% version 2, using ac
bin_packing2(Bins, Weights, Capacity) :-
        length(Bins,N),
        length(Weights,N),

        foreach(B in 1..N, [Sum],
                (foreach(J in 1..N, ac(Sum, 0),
                         Sum^1 #= Sum^0 + Weights[J] * (Bins[J] #= B)
                        ),
                 Sum #=< Capacity
                )).
