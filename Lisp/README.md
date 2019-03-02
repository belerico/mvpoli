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

We decided to structure it as a library in the following way, we defined a series of "public" functions that are those required by the specification of the pdf plus some additions from us, and we have also defined a series of "private" functions that are what we say
"support" to "public" ones.  
Since the user who uses this library should not be aware of the private functions, we describe below only how to use the public functions.
----------------------------------------------------------------------------------------------

FUNCTIONS:
Function: (is-monomial Monomial) 
Output: T o NIL
Descrizione: Data una struttura Monomial, ritorna la lista di varpowers VP-list.
    	     Monomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms) rappresentante un monomio
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un monomio 
  	     
Function: (is-polynomial Polynomial) 
Output: T o NIL
Descrizione: Data una struttura Monomial, ritorna la lista di varpowers VP-list.
  	     Polynomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio
  
Function: (varpowers Monomial) 
Output: VP-list
Descrizione: Data una struttura Monomial, ritorna la lista di varpowers VP-list.
	     Monomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms) rappresentante un monomio
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un monomio

Function (vars-of Monomial)  
Output: Variables
Descrizione: Data una struttura Monomial, ritorna la lista di variabili Variables.
	     Monomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms) rappresentante un monomio
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un monomio 

Function: (monomial-degree Monomial) 
Output: TotalDegree
Descrizione: Data una struttura Monomial, ritorna il suo grado totale TotalDegree.
	     Monomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms) rappresentante un monomio
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un monomio 

Function: (monomial-coefficient Monomial) 
Output: Coefficient
Descrizione: Data una struttura Monomial, ritorna il suo coefficiente Coefficient.
	     Monomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms) rappresentante un monomio
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un monomio 

Function: (coefficients Poly) 
Output: Coefficients
Descrizione: La funzione coefficients ritorna una lista Coefficients dei "ovviamente" coefficienti di Poly.
 	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio

Function: (variables Poly) 
Output: Variables
Descrizione: La funzione variables ritorna una lista Variables dei simboli di variabile che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio
		
Function: (monomials Poly) 
Output: Monomials
Descrizione: La funzione monomials ritorna la lista ordinata, dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio

Function: (maxdegree Poly) 
Output: Degree
Descrizione: La funzione maxdegree ritorna il massimo grado dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio
	     
Function: (mindegree Poly) 
Output: Degree
Descrizione: La funzione mindegree ritorna il minimo grado dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio

Function: (polyplus Poly1 Poly2) 
Output: Result
Descrizione: La funzione polyplus produce il polinomio somma di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio 
	     
Function: (polyminus Poly1 Poly2) 
Output: Result
Descrizione: La funzione polyplus produce il polinomio differenza di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio 

Function: (polytimes Poly1 Poly2) 
Output: Result
Descrizione: La funzione polytimes ritorna il polinomio risultante dalla moltiplicazione di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio 

Function: (polytimes-k Poly K) 
Output: Result
Descrizione: La funzione polytimes ritorna il polinomio risultante dalla moltiplicazione di Poly e K.
	     dove K è un valore numerico.
	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio
	     
Function: (polypower Poly N) 
Output: Result
Descrizione: La funzione polypower ritorna il polinomio Poly "elevato" alla N.
	     Poly può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio

Function: (as-monomial Expression)
Output: Monomial
Descrizione: La funzione as-monomial ritorna la struttura dati (lista) che rappresenta il monomio risultante dal
	     “parsing” dell’espressione Expression; il monomio risultante deve essere appropriatamente ordinato.

Function: (as-polynomial Expression) 
Output: Polynomial
Descrizione: La funzione as-polynomial ritorna la struttura dati (lista) che rappresenta il monomio risultante dal
	     “parsing” dell’espressione Expression; il polinomio risultante deve essere appropriatamente ordinato.

Function: (polyval Polynomial VariableValues) 
Output: Value
Descrizione: La funzione polyval restituisce il valore Value del polinomio Polynomial (che può anche essere un
	     monomio), nel punto n-dimensionale rappresentato dalla lista VariableValues, che contiene un valore per
	     ogni variabile ottenuta con la funzione variables.
	     Polynomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio

Function: (pprint-polynomial Polynomial)
Output: NIL
Descrizione: La funzione pprint-polynomial ritorna NIL dopo aver stampato sullo “standard output” una rappresentazione tradizionale del 	     termine polinomio associato a Polynomial.
             Polynomial può assumere una delle seguenti forme:
  	     * una struttura del tipo (POLY NIL)
  	     * una struttura del tipo (POLY Ms)
  	     * una struttura del tipo (M ...)
  	     * una struttura del tipo (M 0 0 NIL)
  	     * un'espressione non parsata rappresentante un polinomio
	     
	     
	     
