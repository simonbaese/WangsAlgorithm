# Wang's Algorithm
Automated Theorem Proving with Wang's Algorithm

This is a little exercise about logic programming with Prolog. To learn about Wang's algorithm please refer to the presentation (Presentation.pdf) in the repository. The program was tested with SWI-Prolog 8.0.3 for MacOS but should also run easily with other version due to its simplicity.

# Contents

The repository contains two files which can be consulted by Prolog.

#### wang.pl
States if the given theorems are true or false and prints the individual steps of the proves.

#### wang_min.pl
Only states if the given theorems are true or false.

# Running the program

Start up Prolog and consult either `wang.pl` or `wang_min.pl`. There are five allowed operators for the logic statements with stated precedences.
````
:-op(700,xfy,<->). % equivalence
:-op(700,xfy,->). % implication
:-op(600,xfy,v). % disjunction
:-op(600,xfy,&). % conjunction
:-op(500,fy,!). % negation
````
The main call `prove(?List1,?List2)` takes two lists as inputs which should contain the respective left- and right-hand side of the entailments to prove. For example
````
prove([[]],[[tobe v !tobe]]).
````
which answers the old question `[] |= [tobe v !tobe]` ("To be or not to be?"). It is also possible to prove multiple entailments at once like so
````
prove([[],[(p & q) & r]],[[p v !p],[p & (q & r)]]).
````

# Other examples
````
prove([[p]],[[p v q]]). % TRUE
prove([[(p -> q) & (!r -> !q)]],[[p -> r]]). % TRUE
prove([[]],[[(!p & !q) -> (p <-> q)]]). % TRUE
prove([[p <-> q]],[[(p <-> r) -> (q <-> r)]]). % TRUE
````
More following soon.
