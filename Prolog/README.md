# LEGEND:

* with m (...) we mean the monomial structure thus formed: m (Coefficient, TotalDegree, VarsPowers).
* with m (0, 0, []) we mean the null monomial structure.
* with poly (Ms) we mean the polynomial structure, where with Ms we mean a list of monomial structures m (...).
* with poly ([]) we mean the null polynomial structure

----------------------------------------------------------------------------------------------

# INTRODUCTION:

The aim of this project is the construction of a library for the manipulation of multivariate polynomials.  
From the pdf specification it was required to implement standard and fairly simple operations on polynomials, we are there
wanted to push a little further, and we have also implemented things a bit more advanced, for example the ability to treat a polynomial elevated to n, or polynomials with more coefficients, polynomials that multiply etc ..
the only untreated case is the division between polynomials.  
Examples of cases treated: (x + y) ^ 2, 3 * x * 5 * z + a * 3 * b, (x + y) * (2 * a + b)  
Given that from the specification of the pdf the interpretation of what can be a monomial and what a polynomial has seemed quite free
we have opted for this interpretation:
First of all, as regards the monomials, we wanted to exploit the concept of "inheritance" according to which a monomial is a polynomial composed only by a term (https://en.wikipedia.org/wiki/Monomial).
As a result, we asked ourselves the following question:
can the expression x + x be considered a monomial? Or better:
are all those expressions that are simplified and are composed of a single term?
If we consider it as a whole x + x it is not monomial, it is syntactically incorrect, but if before making such a request the simplifications of the case are made, then it can be considered as such.
Ultimately we opted to consider expressions similar to x + x as monomials.  
To confirm, we asked the same question to wolfram | alpha:
https://www.wolframalpha.com/input/?i=is+x%2Bx+monomial%3F.  
So now let's list what we consider a polynomial and what a monomial.  
It is considered monomial:

* a structure of the poly type (Ms) where Ms is a list containing only one term, or Ms is a list with more terms and after simplifying this list there remains only one term. Example: poly ([m (1, 1, [v (1, x)]), m (1, 1, [v (1, x)])]) => poly ([m (2, 1, [ v (1, x)])]) (turns out to be a monomial after simplifying)
* a structure of the poly type ([])
* a structure of the type m (0, 0, [])
* a structure of the type m (...)
* a non-parsed expression representing a monomial

It is considered a polynomial:

* a structure of the poly type ([])
* a structure of the poly type (Ms)
* a structure of the type m (0, 0, [])
* a structure of the type m (...)
* a non-parsed expression representing a polynomial

We decided to structure it as a library in the following way, we defined a series of "public" predicates that are those required by the specification of the pdf plus some added by us, and we have also defined a series of "private" predicates that are what we say
"support" to "public" ones.  
Since the user who uses this library should not be aware of private predicates, we describe below only how to use public predicates.

-------------------------------------------------- --------------------------------------------

# PREDICATES:
Predicate: is_monomial (Monomial)

* Description: The is_monomial predicate is true when Monomial is a monomial. Monomial can take one of the following forms:
    * a structure of the poly type ([])
    * a poly (Ms) representative monomial structure
    * a structure of the type m (0, 0, [])
    * a structure of the type m (...)
    * a non-parsed expression representing monomial

Predicate: is_polynomial (Poly)

* Description: The is_polynomial predicate is true when Poly is a polynomial. Poly can take one of the following forms:
    * a structure of the poly type ([])
    * a structure of the poly type (Ms)
    * a structure of the type m (0, 0, [])
    * a structure of the type m (...)
    * a non-parsed expression representing a polynomial

Predicate: coefficients (Poly, Coefficients)

* Description: The predicate coefficients is true when Coefficients is a list of "obviously" Poly coefficients. Poly can take one of the following forms:
    * a structure of the poly type ([])
    * a structure of the poly type (Ms)
    * a structure of the type m (0, 0, [])
    * a structure of the type m (...)
    * a non-parsed expression representing a polynomial    
	      
Predicate: variables (Poly, Variables)

* Description: The variables predicate is true when Variables is a list of variable symbols that appear in Poly. Poly can take one of the following forms:
    * a structure of the type poly ([])
    * a structure of the poly type (Ms)
    * a structure of the type m (0, 0, [])
    * a structure of the type m (...)
    * an unparsed expression representing a polynomial
  
Predicate: monomials (Poly, Monomials)

* Description: The predicate monomials is true when Monomials is the ordered list, of the monomials that appear in Poly. Poly can take one of the following forms:
    * a structure of the type poly ([])
    * a structure of the poly type (Ms)
    * a structure of the type m (0, 0, [])
    * a structure of the type m (...)
    * an unparsed expression representing a polynomial

Predicate: maxdegree (Poly, Degree)
Description: The maxdegree predicate is true when Degree is the maximum degree of the monomers that appear in Poly.
  Poly can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial
  
Predicate: mindegree (Poly, Degree)
Description: The mindegree predicate is true when Degree is the minimum degree of the monomials that appear in Poly.
Poly can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial

Predicate: polyplus (Poly1, Poly2, Result)
Description: The polyplus predicate is true when Result is the sum polynomial of Poly1 and Poly2.
Poly1 and Poly2 can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial

Predicate: polyminus (Poly1, Poly2, Result)
Description: The polyminus predicate is true when Result is the polynomial difference of Poly1 and Poly2.
      Poly1 and Poly2 can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial

Predicate: polytimes (Poly1, Poly2, Result)
Description: The polytimes predicate is true when Result is the polynomial
resulting from the multiplication of Poly1 and Poly2.
Poly1 and Poly2 can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial

Predicate: polytimes_k (Poly1, K, Result)
Description: The polytimes predicate is true when Result is
 the polynomial resulting from the multiplication of Poly1 and K.
 where K is a numerical value.
Poly1 can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial

Predicate: polypower (Poly, N, Result)
Description: The polytimes predicate is true when Result is the Poly "elevated" polynomial.
Poly can take one of the following forms:
 - a structure of the poly type ([])
  - a structure of the poly type (Ms)
  - a structure of the type m (0, 0, [])
  - a structure of the type m (...)
  - a non-parsed expression representing a polynomial

Predicate: as_monomial (Expression, Monomial)
Description: The as_monomial predicate is true when Monomial is the term that represents the monomial resulting from
"Parsing" of the expression Expression; the resulting monomone is appropriately ordered.

Predicate: as_polynomial (Expression, Polynomial)
Description: The as_polynomial predicate is true when Polynomial is the term that represents the resulting polynomial
from the "parsing" of the expression Expression; the polynomial is appropriately ordered.

Predicate: polyval(Polynomial, VariableValues, Value)
Descrizione: Il predicato polyval è vero quanto Value contiene il valore del polinomio Polynomial (che può anche
	     essere un monomio), nel punto n-dimensionale rappresentato dalla lista VariableValues, che contiene un
             valore per ogni variabile ottenuta con il predicato variables/2.
	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio   
	     
Predicate: pprint polynomial(Polynomial)
Descrizione: Il predicato pprint polynomial risulta vedo dopo aver stampato sullo “standard output” una rappresentazione tradizionale del 		     termine polinomio associato a Polynomial. 
	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio   

