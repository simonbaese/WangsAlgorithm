# Wang's Algorithm

Automated Theorem Proving with Wang's Algorithm

This is a little exercise about logic programming with Prolog. To learn about Wang's algorithm please refer to the presentation (Presentation.pdf) in the repository. The program was tested with SWI-Prolog 8.0.3 for MacOS but should also run easily with other version due to its simplicity.

# Contents

The repository contains two files which can be consulted by Prolog.

#### wang.pl

States if the given theorems are **true** or **false** and prints the individual steps of the proves.

#### wang_min.pl

Only states if the given theorems are **true** or **false**.

# Running the program

Start up Prolog and consult either **wang.pl** or **wang_min.pl**. There are five allowed operators for the logic statements with stated precedences.

``` prolog
:-op(700,xfy,<->). % equivalence
:-op(700,xfy,->). % implication
:-op(600,xfy,v). % disjunction
:-op(600,xfy,&). % conjunction
:-op(500,fy,!). % negation
```

The main call `prove(?List1,?List2)` takes two lists as inputs which should contain the respective left- and right-hand side of the entailments to prove. For example

``` prolog
prove([[]],[[tobe v !tobe]]).
```

which answers the old question `[] |= [tobe v !tobe]` ("To be or not to be?"). It is also possible to prove multiple entailments at once like so

``` prolog
prove([[],[(p & q) & r]],[[p v !p],[p & (q & r)]]).
```

# Other examples

Some examples with their expected outcome.

``` prolog
prove([[p]],[[p v q]]). % true
prove([[]],[[(((p -> q) -> p ) -> p)]]). % true
prove([[(p -> q) & (!r -> !q)]],[[p -> r]]). % true
prove([[]],[[(!p & !q) -> (p <-> q)]]). % true
prove([[p <-> q]],[[(p <-> r) -> (q <-> r)]]). % true
prove([[]],[[(((p & q) -> !((!p v !q))) & (!((!p v !q)) -> (p & q)))]]). % true
prove([[]],[[((!p -> q) & ((p & q) -> !r) & ((r v !p) -> !q) -> p)]]). % true

```

Do you want to challenge your computer? This one might be charm. We recommend using 
**wang_min.pl** to avoid overwhelming output.

``` prolog
prove([[]],[[((!p -> q) & ((p & q) -> !r) & ((r v !p) -> !q) -> (r & q))]]). % true
```

# References

- Hao Wang, Toward Mechanical Mathematics, IBM Journal of Research and Development, volume 4, 1960.
- Stuart Russell and Peter Nerving. 2009. Artificial Intelligence: A Modern Approach (3rd edition). Prentice Hall Press, Upper Saddle River, NJ, USA. (Chapters 8, 9 and 12)
- Štěpán, Jan. "Propositional calculus proving methods in Prolog." Acta Universitatis Palackianae Olomucensis. Facultas Rerum Naturalium. Mathematica 29.1 (1990): 301-321.
