LEGENDA:
con m(...) si intende la struttura monomio così formata: m(Coefficient, TotalDegree, VarsPowers).
con m(0, 0, []) si intende la struttura monomio nullo.
con poly(Ms) si intende la struttura polinomio, dove con Ms si intende una lista di strutture monomio m(...).
con poly([]) si intende la struttura polinomio nullo 

----------------------------------------------------------------------------------------------

INTRODUZIONE: 
Lo scopo di questo progetto è la costruzione di una libreria per la manipolazione di polinomi multivariati.
dalla specifica del pdf era richiesto di implementare operazioni standard e abbastanza semplici sui polinomi, noi ci siamo
voluti spingere un po oltre, e abbiamo anche implementato cose un po più avanzate, per esempio la possibilità di trattare un polinomio elevato alla n, oppure polinomi con più coefficenti, polinomi che si moltiplicano ecc..
l'unico caso non trattato è la divisione tra polinomi.
esempi di casi trattati: (x+y)^2, 3*x*5*z + a*3*b, (x+y)*(2*a+b)
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
    Esempio: poly([m(1, 1, [v(1,x)]), m(1, 1, [v(1,x)])]) => poly([m(2, 1, [v(1,x)])]) (risulta essere un monomio dopo aver semplificato)
  - una struttura del tipo poly([])
  - una struttura del tipo m(0, 0, [])
  - una struttura del tipo m(...)
  - un'espressione non parsata rappresentante un monomio
Si considera polinomio:
  - una struttura del tipo poly([])
  - una struttura del tipo poly(Ms)
  - una struttura del tipo m(0, 0, [])
  - una struttura del tipo m(...)
  - un'espressione non parsata rappresentante un polinomio  
abbiamo deciso di strutturare a libreria nel seguente modo, abbiamo definito una serie di predicati "pubblici" che sono quelli richiesti dalla specifica del pdf più alcuni aggiunti da noi, e inoltre abbiamo definito una serie di predicati "privati" che sono quelli diciamo 
"di supporto" a quelli "pubblici".
Dato che l'utente che utilizza questa libreria non dovrebbe essere a conoscenza dei predicati privati, qui di seguito descriviamo solo come utilizzare i predicati pubblici.

----------------------------------------------------------------------------------------------

PREDICATI:
Predicate: is_monomial(Monomial)
Descrzione: Il predicato is_monomial è vero quando Monomial è un monomio.
            Monomial può assumere una delle seguenti forme:
 	    - una struttura del tipo poly([])
  	    - una struttura del tipo poly(Ms) rappresentante monomio
  	    - una struttura del tipo m(0, 0, [])
  	    - una struttura del tipo m(...)
  	    - un'espressione non parsata rappresentante monomio   

Predicate: is_polynomial(Poly)
Descrizione: Il predicato is_polynomial è vero quando Poly è un polinomio.
    	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio        

Predicate: coefficients(Poly, Coefficients)
Descrizione: Il predicato coefficients è vero quando Coefficients è una lista dei "ovviamente" coefficienti di Poly.
             Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio    
	      
Predicate: variables(Poly, Variables)
Descrizione: Il predicato variables è vero quando Variables è una lista dei simboli di variabile che appaiono in Poly.
  	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio   
  	       
Predicate: monomials(Poly, Monomials)
Descrizione: Il predicato monomials è vero quando Monomials è la lista ordinata, dei monomi che
	     appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio     
	      
Predicate: maxdegree(Poly, Degree)
Descrizione: Il predicato maxdegree è vero quando Degree è il massimo grado dei monomi che appaiono in Poly.
  	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio   
  	      
Predicate: mindegree(Poly, Degree)
Descrizione: Il predicato mindegree è vero quando Degree è il minimo grado dei monomi che appaiono in Poly.
	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio     
	      
Predicate: polyplus(Poly1, Poly2, Result)
Descrizione: Il predicato polyplus è vero quando Result è il polinomio somma di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio      

Predicate: polyminus(Poly1, Poly2, Result)
Descrizione: Il predicato polyminus è vero quando Result è il polinomio differenza di Poly1 e Poly2.
      	     Poly1 e Poly2 possono assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio      

Predicate: polytimes(Poly1, Poly2, Result)
Descrizione: Il predicato polytimes è vero quando Result è il polinomio 
	     risultante dalla moltiplicazione di Poly1 e Poly2.
	     Poly1 e Poly2 possono assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio 

Predicate: polytimes_k(Poly1, K, Result)
Descrizione: il predicato polytimes è vero quando Result è 
 	     il polinomio risultante dalla moltiplicazione di Poly1 e K.
 	     dove K è un valore numerico.
	     Poly1 può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio      	          

Predicate: polypower(Poly, N, Result)
Descrizione: Il predicato polytimes è vero quando Result è il polinomio Poly "elevato" alla N.
	     Poly può assumere una delle seguenti forme:
 	     - una struttura del tipo poly([])
  	     - una struttura del tipo poly(Ms)
  	     - una struttura del tipo m(0, 0, [])
  	     - una struttura del tipo m(...)
  	     - un'espressione non parsata rappresentante un polinomio   
	     
Predicate: as_monomial(Expression, Monomial)
Descrizione: Il predicato as_monomial è vero quando Monomial è il termine che rappresenta il monomio risultante dal
	     “parsing” dell’espressione Expression; il monomio risultante viene appropriatamente ordinato.

Predicate: as_polynomial(Expression, Polynomial)
Descrizione: Il predicato as_polynomial è vero quando Polynomial è il termine che rappresenta il polinomio risultante
	     dal “parsing” dell’espressione Expression; il polinomio viene appropriatamente ordinato.

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

