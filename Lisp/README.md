# LEGENDA:
con (M ...) si intende la struttura monomio così formata: (M Coefficient TotalDegree VarsPowers) 
con (M 0 0 NIL) si intende la struttura monomio nullo
con (POLY Ms) si intende la struttura polinomio, dove al posto di Ms si intende una lista di strutture monomio (M ...) 
con (POLY NIL) si intende la struttura polinomio nullo

----------------------------------------------------------------------------------------------

# INTRODUCTION:
Lo scopo di questo progetto è la costruzione di una libreria per la manipolazione di polinomi multivariati.
dalla specifica del pdf era richiesto di implementare operazioni standard e abbastanza semplici sui polinomi, noi ci siamo
voluti spingere un po oltre, e abbiamo anche implementato cose un po più avanzate, per esempio la possibilità di trattare un polinomio elevato alla n, oppure polinomi con più coefficenti, polinomi che si moltiplicano ecc..
l'unico caso non trattato è la divisione tra polinomi.
esempi di casi trattati: (x+y)^2, 3*x*5*z + a*3*b, (x+y)*(2*a+b), ....
dato che dalla specifica del pdf l'interpretazione di cosa possa essere un monomio e cosa un polinomio è sembrata abbastanza libera
noi abbiamo optato per questa interpretazione:
innanzi tutto per quanto riguarda i monomi abbiamo voluto sfruttare il concetto di "ereditarietà" secondo cui un monomio è un polinomio composto solo da un termine (https://en.wikipedia.org/wiki/Monomial).
Di conseguenza ci siamo posti la seguente domanda:
si può considerare un monomio l'espressione x+x? O meglio:
sono da considerarsi monomi tutte quelle espressioni che, semplificate, sono composte da un singolo termine?
Se lo si considera nella sua globalità x+x non è monomio, è sintatticamente scorretto, ma se prima di porsi tal domanda si effettuano le semplificazioni del caso, allora lo si può ritenere tale.
In definitiva abbiamo optato per considerare espressioni simili a x+x come dei monomi.
Per avere conferme, abbiamo posto la stessa domanda a wolfram|alpha:
https://www.wolframalpha.com/input/?i=is+x%2Bx+monomial%3F.
quindi ora elenchiamo cosa noi consideriamo un polinomio e cosa un monomio:
Si considera monomio:
  - una struttura del tipo poly(Ms) dove Ms è una lista contenente un solo termine, 
    oppure Ms è una lista con più termini e dopo aver semplificato tale lista rimane un solo termine
    Esempio: (POLY ((M 1 1 ((V 1 X))) (M 1 1 ((V 1 X))))) => (POLY ((M 2 1 ((V 1 X))))) (risulta essere un monomio dopo aver semplificato).
    definiamo per questo caso particolare la struttura (POLY Ms), struttura rappresentante un monomio.
  - una struttura del tipo (POLY NIL)
  - una struttura del tipo (M 0 0 NIL)
  - una struttura del tipo (M ...)
  - un'espressione non parsata rappresentante un monomio
Si considera polinomio:
  - una struttura del tipo (POLY NIL)
  - una struttura del tipo (POLY Ms)
  - una struttura del tipo (M ...)
 - un'espressione non parsata rappresentante un polinomio 
abbiamo deciso di strutturare a libreria nel seguente modo, abbiamo definito una serie di funzioni "pubbliche" che sono quelle richieste dalla specifica del pdf più alcune aggiunte da noi, e inoltre abbiamo definito una serie di funzioni "private" che sono quelle diciamo 
"di supporto" a quelle "pubbliche".
Dato che l'utente che utilizza questa libreria non dovrebbe essere a conoscenza delle funzioni private, qui di seguito descriviamo solo come utilizzare le funzioni pubbliche.

----------------------------------------------------------------------------------------------

FUNCTIONS:
Function: (is-monomial Monomial) 
Output: T o NIL
Descrizione: Data una struttura Monomial, ritorna la lista di varpowers VP-list.
    	     Monomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms) rappresentante un monomio
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un monomio 
  	     
Function: (is-polynomial Polynomial) 
Output: T o NIL
Descrizione: Data una struttura Monomial, ritorna la lista di varpowers VP-list.
  	     Polynomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio
  
Function: (varpowers Monomial) 
Output: VP-list
Descrizione: Data una struttura Monomial, ritorna la lista di varpowers VP-list.
	     Monomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms) rappresentante un monomio
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un monomio

Function (vars-of Monomial)  
Output: Variables
Descrizione: Data una struttura Monomial, ritorna la lista di variabili Variables.
	     Monomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms) rappresentante un monomio
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un monomio 

Function: (monomial-degree Monomial) 
Output: TotalDegree
Descrizione: Data una struttura Monomial, ritorna il suo grado totale TotalDegree.
	     Monomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms) rappresentante un monomio
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un monomio 

Function: (monomial-coefficient Monomial) 
Output: Coefficient
Descrizione: Data una struttura Monomial, ritorna il suo coefficiente Coefficient.
	     Monomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms) rappresentante un monomio
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un monomio 

Function: (coefficients Poly) 
Output: Coefficients
Descrizione: La funzione coefficients ritorna una lista Coefficients dei "ovviamente" coefficienti di Poly.
 	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio

Function: (variables Poly) 
Output: Variables
Descrizione: La funzione variables ritorna una lista Variables dei simboli di variabile che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio
		
Function: (monomials Poly) 
Output: Monomials
Descrizione: La funzione monomials ritorna la lista ordinata, dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio

Function: (maxdegree Poly) 
Output: Degree
Descrizione: La funzione maxdegree ritorna il massimo grado dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio
	     
Function: (mindegree Poly) 
Output: Degree
Descrizione: La funzione mindegree ritorna il minimo grado dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio

Function: (polyplus Poly1 Poly2) 
Output: Result
Descrizione: La funzione polyplus produce il polinomio somma di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio 
	     
Function: (polyminus Poly1 Poly2) 
Output: Result
Descrizione: La funzione polyplus produce il polinomio differenza di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio 

Function: (polytimes Poly1 Poly2) 
Output: Result
Descrizione: La funzione polytimes ritorna il polinomio risultante dalla moltiplicazione di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio 

Function: (polytimes-k Poly K) 
Output: Result
Descrizione: La funzione polytimes ritorna il polinomio risultante dalla moltiplicazione di Poly e K.
	     dove K è un valore numerico.
	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio
	     
Function: (polypower Poly N) 
Output: Result
Descrizione: La funzione polypower ritorna il polinomio Poly "elevato" alla N.
	     Poly può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio

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
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio

Function: (pprint-polynomial Polynomial)
Output: NIL
Descrizione: La funzione pprint-polynomial ritorna NIL dopo aver stampato sullo “standard output” una rappresentazione tradizionale del 	     termine polinomio associato a Polynomial.
             Polynomial può assumere una delle seguenti forme:
  	     - una struttura del tipo (POLY NIL)
  	     - una struttura del tipo (POLY Ms)
  	     - una struttura del tipo (M ...)
  	     - una struttura del tipo (M 0 0 NIL)
  	     - un'espressione non parsata rappresentante un polinomio
	     
	     
	     
