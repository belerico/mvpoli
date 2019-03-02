# LEGENDA:
with (M ...) we mean the monomial structure thus formed: (M Coefficient TotalDegree VarsPowers)
with (M 0 0 NIL) we mean the null monomial structure
with (POLY Ms) we mean the polynomial structure, where instead of Ms we mean a list of monomial structures (M ...)
with (POLY NIL) we mean the null polynomial structure

----------------------------------------------------------------------------------------------

# INTRODUCTION:
The aim of this project is the construction of a library for the manipulation of multivariate polynomials.
From the pdf specification it was required to implement standard and fairly simple operations on polynomials, we are there
wanted to push a little further, and we have also implemented things a bit more advanced, for example the ability to treat a polynomial elevated to n, or polynomials with more coefficients, polynomials that multiply etc ..
the only untreated case is the division between polynomials.
examples of cases treated: (x + y) ^ 2, 3 * x * 5 * z + a * 3 * b, (x + y) * (2 * a + b), ....
given that from the specification of the pdf the interpretation of what can be a monomial and what a polynomial has seemed quite free
we have opted for this interpretation:
First of all, as regards the monomial, we wanted to exploit the concept of "inheritance" according to which a monomial is a polynomial composed only by a term (https://en.wikipedia.org/wiki/Monomial).
As a result, we asked ourselves the following question:
can the expression x + x be considered a monomial? Or better:
are all those expressions that are simplified and are composed of a single term?
If we consider it as a whole x + x it is not monomial, it is syntactically incorrect, but if before making such a request the simplifications of the case are made, then it can be considered as such.
Ultimately we opted to consider expressions similar to x + x as monomials.
To confirm, we asked the same question to wolfram | alpha:
https://www.wolframalpha.com/input/?i=is+x%2Bx+monomial%3F.  
So now let's list what we consider a polynomial and what a monomial.  
It is considered monomial:
   * a structure of the type poly(Ms) where Ms is a list containing only one term, or Ms is a list with more terms and after simplifying this list there remains only one term. Example: (POLY ((M 1 1 ((V 1 X))) (M 1 1 ((V 1 X))))) => (POLY ((M 2 1 ((V 1 X))))) (turns out to be a monomial after simplifying). For this particular case we define the structure (POLY Ms), a structure representing a monomial.
   * a structure of the type (POLY NIL)
   * a structure of the type (M 0 0 NIL)
   * a structure of the type (M ...)
   * a non-parsed expression representing a monomial

It is considered a polynomial:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a non-parsed expression representing a polynomial

We decided to structure it as a library in the following way, we defined a series of "public" functions that are those required by the specification of the pdf plus some additions from us, and we have also defined a series of "private" functions that are what we say "support" to "public" ones.  
Since the user who uses this library should not be aware of the private functions, we describe below only how to use the public functions.

----------------------------------------------------------------------------------------------

FUNCTIONS:
Function: (is-monomial Monomial) 
Output: T or NIL
Description: Given a Monomial structure, return the list of varpowers VP-list. Monomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms) representing a monomial
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a monomial 
  	    

Function: (is-polynomial Polynomial)
Output: T or NIL
Description: Given a Monomial structure, return the list of varpowers VP-list. Polynomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial
  

Function: (Monomial varpowers)
Output: VP-list
Description: Given a Monomial structure, return the list of varpowers VP-list.
Monomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms) representing a monomial
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a monomial


Function (vars-of Monomial)
Output: Variables
Description: Given a Monomial structure, it returns the list of variables Variables.
Monomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms) representing a monomial
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a monomial


Function: (monomial-degree Monomial)
Output: TotalDegree
Description: Given a Monomial structure, it returns its total degree TotalDegree.
Monomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms) representing a monomial
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a monomial


Function: (monomial-coefficient Monomial)
Output: Coefficient
Description: Given a Monomial structure, it returns its Coefficient coefficient.
Monomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms) representing a monomial
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a monomial


Function: (Poly coefficients)
Output: Coefficients
Description: The coefficients function returns a Coefficients list of the "obviously" Poly coefficients.
 Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial


Function: (Poly variables)
Output: Variables
Description: The variables function returns a Variables list of the variable symbols that appear in Poly.
Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (Poly monomials)
Output: Monomials
Description: The monomials function returns the ordered list, of the monomials that appear in Poly.
Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (Poly maxdegree)
Output: Degree
Description: The maxdegree function returns the maximum degree of the monomers that appear in Poly.
Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (Poly Mindegree)
Output: Degree
Description: The mindegree function returns the minimum degree of the monomers that appear in Poly.
Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (polyplus Poly1 Poly2)
Output: Result
Description: The polyplus function produces the sum polynomial of Poly1 and Poly2.
Poly1 and Poly2 can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (polyminus Poly1 Poly2)
Output: Result
Description: The polyplus function produces the polynomial difference of Poly1 and Poly2.
Poly1 and Poly2 can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial 

Function: (polytimes Poly1 Poly2)
Output: Result
Description: The polytimes function returns the polynomial resulting from the multiplication of Poly1 and Poly2.
Poly1 and Poly2 can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (polytimes-k Poly K)
Output: Result
Description: The polytimes function returns the polynomial resulting from the multiplication of Poly and K.
where K is a numerical value.
Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (polypower Poly N)
Output: Result
Description: The polypower function returns the Poly "high" polynomial to N.
Poly can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (as-monomial Expression)
Output: Monomial
Description: The as-monomial function returns the data structure (list) that represents the monomial resulting from
"Parsing" of the expression Expression; the resulting monomial must be appropriately ordered.

Function: (as-polynomial Expression)
Output: Polynomial
Description: The as-polynomial function returns the data structure (list) representing the monomial resulting from
"Parsing" of the expression Expression; the resulting polynomial must be appropriately ordered.

Function: (polyval Polynomial VariableValues)
Output: Value
Description: The polyval function returns the Value value of the Polynomial polynomial (which can also be a
monomial), in the n-dimensional point represented by the VariableValues ​​list, which contains a value for
every variable obtained with the variables function.
Polynomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial

Function: (pprint-polynomial Polynomial)
Output: NIL
Description: The pprint-polynomial function returns NIL after having printed on the "standard output" a traditional representation of the polynomial term associated with Polynomial.
             Polynomial can take one of the following forms:
   * a structure of the type (POLY NIL)
   * a structure of the type (POLY Ms)
   * a structure of the type (M ...)
   * a structure of the type (M 0 0 NIL)
   * an unparsed expression representing a polynomial