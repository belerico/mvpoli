;;;; 807387 Avogadro Roberto
;;;; 808708 Belotti Federico

#|
  Funzione che ritorna true se Poly è monomio consistente e 
  sintatticamente corretto, false altrimenti.
|#
(defun is-monomial(Poly)
     (let ((Ms (monomials Poly)))
          (if (or (null Ms) (= 1 (length Ms)))
              T
              NIL
          )
     ) 
)

#|
  Funzione che ritorna true se Poly è polinomio consistente e
  sintatticamente corretto, false altrimenti.
|#
(defun is-polynomial(Poly)
	(let ((Ms (to-ms Poly)))
             T
        )
)

#|
  Funzione che ritorna la lista di strutture varpowers di Poly,
  se Poly rappresenta una struttura monomio, lancia un errore altrimenti.
|#
(defun varpowers(Poly)
        (let ((Ms (monomials Poly)))
             (if (= 1 (length Ms))
                 (get-vs (first Ms))
                 (error "~S is not a monomial" Poly)
             )
        )
)

#|
  Funzione che ritorna la lista di variabili di Poly,
  se Poly rappresenta una struttura monomio, lancia un errore altrimenti.
|#
(defun vars-of(Poly)
	(let ((Ms (monomials Poly)))
	     (if (= 1 (length Ms))
		 (mapcar 'get-var-sym (get-vs (first Ms)))
		 (error "~S is not a monomial" Poly)
	     )	
	)
)

#|
  Funzione che ritorna il grado totale di Poly,
  se Poly rappresenta una struttura monomio, lancia un errore altrimenti.
|#
(defun monomial-degree(Poly)
        (let ((Ms (monomials Poly)))
             (if (= 1 (length Ms))
                 (get-md (first Ms))
                 (error "~S is not a monomial" S)
             )
        )
)

#|
  Funzione che ritorna il coefficiente di Poly,
  se Poly rappresenta una struttura monomio, lancia un errore altrimenti.
|#
(defun monomial-coefficient(Poly)
	(let ((Ms (monomials Poly)))
	     (if (= 1 (length Ms))
		 (get-coeff (first Ms))
		 (error "~S is not a monomial" Poly)
	     )	
	)
)

;La funzione coefficients ritorna una lista dei coefficienti di Poly.
(defun coefficients(Poly)
        (let ((Ms (monomials Poly)))
             (if (null Ms)
                 '(0)
                 (mapcar 'get-coeff (monomials Poly))
             )
        )
)

#|
  La funzione variables ritorna una lista contenente 
  i simboli di variabile che appaiono in Poly.
|#
(defun variables(Poly)
	(get-ms-vs (monomials Poly))
)

#|
  La funzione monomials ritorna la lista ordinata dei monomi 
  che appaiono in Poly.
|#
(defun monomials(Poly)
	(let ((Ms (to-ms Poly)))
             (if (ignore-errors (or (eq 'POLY (first Poly)) 
                                    (eq 'M (first Poly))
                                )
                 )
                 (sort-simplify-ms Ms)
                 Ms
             )
	)
)

;La funzione maxdegree ritorna il massimo grado dei monomi che appaiono in Poly.
(defun maxdegree(Poly) 
	(get-md (first (last (monomials Poly))))
)

;La funzione mindegree ritorna il minimo grado dei monomi che appaiono in Poly.
(defun mindegree(Poly) 
	(get-md (first (monomials Poly)))
)

;La funzione polyplus produce il polinomio differenza di Poly1 e Poly2.
(defun polyplus(Poly1 Poly2)
        (list 'POLY (sort-simplify-ms (append (to-ms Poly1) (to-ms Poly2))))
)

;La funzione polyminus produce il polinomio differenza di Poly1 e Poly2.	
(defun polyminus(Poly1 Poly2)
        (list 'POLY (sort-simplify-ms (append (to-ms Poly1) 
           	                              (ms-times-k (to-ms Poly2) -1)
           	                      )
                    )
        )
)	

#|
  La funzione polytimes ritorna il polinomio risultante dalla 
  moltiplicazione di Poly1 e Poly2.
|#
(defun polytimes(Poly1 Poly2)
        (list 'POLY (sort-simplify-ms (ms-times-ms (to-ms Poly1)
                                                   (to-ms Poly2)
                                      )
                    )
        )
)

#|
  La funzione polytimes-k ritorna il polinomio risultante dalla 
  moltiplicazione di Poly1 per la costante K.
|#
(defun polytimes-k(Poly K)
        (if (numberp K)
            (list 'POLY (sort-simplify-ms (ms-times-k (to-ms Poly) (eval K))))
            (error "~S must be a number" K)
        )
)

#|
  La funzione polypower ritorna il polinomio risultante dallo 
  elevamento a potenza di Poly alla N .
|#
(defun polypower(Poly N)
        (let ((Ms (to-ms Poly))
              (EN (check-exp N)))
             (list 'POLY (sort-simplify-ms (poly-power Ms EN Ms)))
        )
)

#|
  La funzione as-monomial ritorna una lista di strutture monomio
  che rappresenta il monomio risultante dal "parsing" dell’espressione 
  Expression.
  In questo caso abbiamo voluto sfruttare il concetto di "ereditarietà" 
  secondo cui un monomio è un polinomio composto solo da un termine
  (https://en.wikipedia.org/wiki/Monomial).
  Di conseguenza ci siamo posti la seguente domanda:
  si può considerare un monomio l'espressione x+x? O meglio:
  sono da considerarsi monomi tutte quelle espressioni che, semplificate,
  sono composte da un singolo termine?
  Se lo si considera nella sua globalità x+x non è monomio, è sintatticamente
  scorretto, ma se prima di porsi tal domanda si effettuano le semplificazioni
  del caso, allora lo si può ritenere tale.
  In definitiva abbiamo optato per considerare espressioni 
  simili a x+x come dei monomi.
  Per avere conferme, abbiamo posto la stessa domanda a wolfram|alpha:
  https://www.wolframalpha.com/input/?i=is+x%2Bx+monomial%3F
|#
(defun as-monomial(Expression)
        (let ((Ms (sort-simplify-ms (parse-poly Expression NIL))))    
                   ;Monomio 0 (POLY NIL)
             (cond ((null Ms) (first (create-mon 0 0 NIL)))
                   ;Expression è un monomio
                   ((= 1 (length Ms)) (first Ms))
                   ;Expression è un polinomio
                   (T (error "~S is not a monomial" Expression))
             )	
        )	        
)

#|
  La funzione as-polynomial ritorna una struttura polinomio
  (POLY (M1 M2 ...)), che rappresenta il polinomio risultante dal "parsing" 
  dell’espressione Expression.
|#	
(defun as-polynomial(Expression)
	(list 'POLY (sort-simplify-ms (parse-poly Expression NIL)))
)

#|
  La funzione polyval restituisce il valore del polinomio Poly 
  nel punto n-dimensionale rappresentato dalla lista Values, 
  che contiene un valore per ogni variabile di Poly.
|#
(defun polyval(Poly Values)
	(let* ((Ms (monomials Poly))
	       (Vars (get-ms-vs Ms))
	      )
	      (if (and (>= (length Values) (length Vars)) 
		       (every 'numberp Values)
		  )
	  	  (reduce '+ (mapcar (lambda(M) (mon-eval M Vars Values)) Ms))
		  (error "length of ~S must be greater than or equal to 
		          length of ~S, and ~S must contain only numbers"
		         Values Vars Values
		  )
	      )
	)
)

#|
  La funzione pprint-polynomial ritorna NIL dopo aver stampato una 
  rappresentazione tradizionale del termine polinomio associato a Poly.
  Viene omesso il simbolo di moltiplicazione.
|#
(defun pprint-polynomial(Poly)
        (let ((Ms (monomials Poly))) 
             (if (null Ms) 
                 (format t "0")
	         (format t (concatenate 'string 
				        (format-first-mon (first Ms)) 
				        (format-ms (rest Ms))
		           )
		 )	
	     )
	) 
)


;;;;-----------------------------------------------------------------------;;;;
; PRIVATE FUNCTIONS


#|
  Funzione che ritorna true se l'input VP è una struttura varpower (V Exp Sym)
  sintatticamente corretta, false altrimenti.
|#
(defun varpowerp(VP)
	(and (listp VP)
	     (eq 'V (first VP))
	     (let ((S (get-var-sym VP))
		   (E (eval (get-var-exp VP)))
		  )
		  (and (symbolp S)
		       (if (or (eq NIL S)
	                       (eq '+ S)
	                       (eq '- S)
	                       (eq '* S)
	                       (eq 'expt S)
	                   )
	                   (error "~S is not allowed as a variable" S)
	                   T
	               ) 
		       (integerp E)
		       (>= E 0)
		  )
	     )
	)
)

#|
  Funzione che ritorna true se Poly è una struttura monomio 
  consistente e sintatticamente corretta, false altrimenti.
|#
(defun monomialp(M)
	(cond ;M = (POLY (M))
	      ((and (eq 'POLY (first M)) (= 1 (length (second M))))
			(monomialp (first (second M)))
	      )
	      ;M = (M C MD Vs)
	      ((eq 'M (first M))
			(and (listp M)
			     (let ((C (eval (get-coeff M))))
			          (numberp C)
			     )
			     (let ((MD (eval (get-md M)))
				   (Vs (get-vs M))
				  )
				  (and (integerp MD)
				       (>= MD 0)
				       ;Controllo consistenza grado monomio
				       (= MD (compute-total-deg M))
				       (listp Vs)
				       (every 'varpowerp Vs)
				  )
			     )
			)
	      )
	)
)

#|
  Funzione che ritorna true se Poly è una struttura polinomio 
  consistente e sintatticamente corretta, false altrimenti.
|#
(defun polynomialp(P)
        (cond ;P = (POLY (M1 M2 ...)
	      ((eq 'POLY (first P))
                        (and (listp P)
                             (let ((Ms (second P)))
                                  (and (listp Ms) (every #'monomialp Ms))
                             )
                        )
	      )
	      ;P = (M C MD Vs)
	      ((eq 'M (first P)) (monomialp P))
	)
)

#|
  Funzione che, ricevuta in input una lista di strutture get-vs,
  ritorna una lista di strutture get-vs ordinate in ordine
  lessicografico crescente secondo il simbolo di variabile.
|#
(defun vs-sort(Vs)
	(let ((CVs (copy-list Vs)))
	     (sort CVs 'string< :key 'third)	
	)
)

#|
  Funzione che, ricevuta in input una lista di strutture monomio,
  ritorna una lista di strutture monomio ordinate secondo
  l'ordinamento specificato.
|#
(defun ms-sort(Ms)
	(let ((CMs (copy-list Ms)))
	     (sort CMs 'mons-comp)	
	)
)

#|
  Funzione che funge da comparatore per la funzione ms-sort,
  ovvero specifica secondo quali regole la struttura monomio 
  M1 è "minore" della struttura monomio M2.
  Queste regole sono:
  - Se il grado della struttura monomio M1 è minore del grado della
    struttura monomio M2 oppure i gradi sono uguali e la funzione
    (smallerp (get-vs M1) (get-vs M2)) ritorna true,
    allora nella lista risultato comparirà prima M1 di M2,
  - altrimenti nella lista risultato comparirà prima M2 di M1.
|#
(defun mons-comp(M1 M2)
	(let ((MD1 (get-md M1)) (MD2 (get-md M2)))        
	     (if (or (< MD1 MD2) 
		     (and (= MD1 MD2) (smallerp (get-vs M1) (get-vs M2)))
		 ) 
		 T
		 NIL
	     )
	)
)

#|
  Funzione che, prese in input due strutture get-vs Vs1 e Vs2,
  ritorna true se la struttura get-vs Vs1 è "minore" della struttura
  get-vs Vs2, false altrimenti.
  Le regole secondo cui una struttura get-vs è più piccola di un'altra 
  sono:
  - Se il simbolo di variabile di Vs1 è lessicograficamente minore del
    simbolo di variabile di Vs2, allora Vs1 è più piccola di Vs2.
  - Se il simbolo di variabile di Vs1 è uguale al simbolo di variabile di Vs2
    e l'esponente di Vs1 è minore di dell'esponente di Vs2, allora Vs1
    è più piccola di Vs2
|#
(defun smallerp(Vs1 Vs2)
	(let ((E1 (get-var-exp (first Vs1)))
	      (E2 (get-var-exp (first Vs2)))
	      (V1 (get-var-sym (first Vs1)))
	      (V2 (get-var-sym (first Vs2)))
	     )
	     (cond ((null Vs1) T)
		   ((string< V1 V2) T)
		   ((and (equal V1 V2) (< E1 E2)) T)
		   ((and (= E1 E2) (equal V1 V2)) 
			 (smallerp (rest Vs1) (rest Vs2))
		   )
	     )
	)
)

#|
  Funzione che crea una lista contenente la singola struttura get-vs
  (V E V), dove:
  - E è l'esponente
  - V è il simbolo di variabile
|#
(defun create-vs(E Sym)
	(list (list 'V E Sym))
)

#|
  Funzione che crea una lista contenente la singola struttura monomio
  (M C MD Vs), dove:
  - C è il coefficiente del monomio
  - MD è il grado del monomio
  - Vs è una lista di strutture get-vs
|#
(defun create-mon(C MD Vs)
	(list (list 'M C MD Vs))
)

#|
  Funzione che, presa in input una lista ordinata,
  in ordine lessicografico crecente, di strutture get-vs Vs, 
  ritorna la semplificazione di Vs.
  Per semplificazione si intende:
  - Se l'esponente di una variabile è uguale a 0,
    questa viene scartata.
  - Se due strutture get-vs contigue* sono uguali viene creata
    una nuova struttura get-vs che avrà, per esponente
    la somma dei due esponenti e per simbolo di variabile
    il simbolo della prima (o della seconda, è indifferente).
  * La contiguità è assicurata dal fatto che Vs sia ordinata.  
|#
(defun simplify-vs(Vs)
	(reduce 
            (lambda(V Res)
               (cond ((eq 0 (get-var-exp V)) Res)
                     ((null Res) (list V))
                     ((eq (get-var-sym V) (get-var-sym (first Res)))
                          (append (create-vs (+ (get-var-exp V) 
                                                (get-var-exp (first Res))
                                             ) 
                                             (get-var-sym V)
                                  ) 
                                  (rest Res)
                          )
                     )
                     (T (append (list V) Res))
               )
            ) Vs :initial-value nil :from-end t        
        )
)

#|
  Funzione che, presa in input una lista di strutture monomio Ms, 
  ordina in ordine lessicografico crescente le liste di get-vs 
  di ogni struttura monomio secondo il simbolo di variabile, 
  semplificandole poi.
  Ritorna dunque una lista di strutture monomio in cui ogni monomio
  ha la lista di get-vs ordinata e semplificata. 
|#
(defun sort-simplify-vs(Ms)
	(mapcan (lambda(M)
	                (let ((C (get-coeff M))
	                      (MD (get-md M))
	                      (SSVs (simplify-vs (vs-sort (get-vs M))))
	                     )
	                     (create-mon C MD SSVs)
	                )      
	        ) 
	        Ms
	)
)

#|
  Funzione che, presa in input una lista non semplificata, 
  ma ordinata secondo l'ordinamento specificato,
  di strutture monomio Ms, ritorna la semplificazione di Ms.
  Per semplificazione si intende:
  - Se il coefficiente di un monomio è uguale a 0, questo viene
    scartato.
  - Se due monomi contigui* sono simili, allora si crea 
    una nuova struttura monomio con lo stesso grado, 
    la stessa lista di variabili e i coefficienti sommati.
  * La contiguità è assicurata dal fatto che Ms sia ordinata.    
|#
(defun simplify-ms(Ms)
        (reduce 
            (lambda(M Res)
               (cond ((eq 0 (get-coeff M)) Res)
                     ((null Res) (list M))
                     ((mon-similarp M (first Res))
                        (append (mon-plus-mon M (first Res)) (rest Res))
                     )
                     (T (append (list M) Res))
               )
            ) Ms :initial-value nil :from-end t        
        )
)

#|
  Data una lista di strutture monomio Ms, ritorna una lista di
  strutture monomio in cui i monomi risultano ordinati secondo
  l'ordinamento specificato e semplificati.
|#
(defun sort-simplify-ms(Ms)
        (simplify-ms (ms-sort (sort-simplify-vs Ms))) 
)

#|
  Funzione che ritorna true se il monomio M1 è simile al monomio M2, 
  false altrimenti.
|#
(defun mon-similarp(M1 M2)
	(if (equal (get-vs M1) (get-vs M2))
	    T
	    NIL
	)
)
	
#|
  Supponendo M1 M2 siano due monomi simili, 
  crea una nuova struttura monomio con lo stesso grado, 
  la stessa lista di variabili e i coefficienti sommati.
  In caso la somma dei coefficienti sia uguale 0, viene ritornato NIL. 
|#
(defun mon-plus-mon(M1 M2)
        (let ((NC (+ (get-coeff M1) (get-coeff M2))))
             (if (= 0 NC)
                 NIL
                 (create-mon NC (get-md M1) (get-vs M1)) 
             )
        )
)

;Moltiplica la struttura monomio M per una costante K.
(defun mon-times-k(M K)
	(create-mon (* (get-coeff M) K) (get-md M) (get-vs M))
)

;Moltiplica la lista di strutture monomio Ms per una costante K.
(defun ms-times-k(Ms K)
	(if (= K 0) 
	    ()
	    (mapcan (lambda(M) (mon-times-k M K))  Ms)
	)
)

;Moltiplica la struttura monomio M1 per la struttura monomio M2.
(defun mon-times-mon(M1 M2)
        (create-mon (* (get-coeff M1) 
	               (get-coeff M2)
                    ) 
                    (+ (get-md M1) (get-md M2)) 
                    (append (get-vs M1) (get-vs M2))
         )
)

;Moltiplica la struttura monomio M1 per la lista di strutture monomio Ms.
(defun mon-times-ms(M1 Ms)
	(if (= 0 (get-coeff M1)) 
	    (create-mon 0 0 NIL)
	    (mapcan (lambda(M2) 
                         (if (= 0 (get-coeff M2)) 
                             (create-mon 0 0 NIL)
                             (mon-times-mon M1 M2)
                         )					 
                    ) 
                    Ms
	    )
	)
)

#|
  Moltiplica la lista di strutture monomio Ms1 
  per la lista di strutture monomio Ms2.
|#
(defun ms-times-ms(Ms1 Ms2)
        ;Se Ms1 = (M 0 MD get-vs) oppure
        ;Se Ms2 = (M 0 MD get-vs) inutile proseguire
        (if (or (and (= 1 (length Ms1))
                     (= 0 (get-coeff (first Ms1)))
                )
                (and (= 1 (length Ms2)) 
                     (= 0 (get-coeff (first Ms2)))
                )
            )) 
            (create-mon 0 0 NIL)
	    (mapcan (lambda(M1) (mon-times-ms M1 Ms2)) Ms1)
	)	
)

#|
  Funzione che, presi in input una lista di strutture monomio Ms, 
  un intero Power e una lista di strutture monomio Acc,
  moltiplica ricorsivamente Power-1 volte Ms per Acc.
  Dunque per eseguire l'operazione (Polinomio)^N basterà chiamare 
  (poly-power Ms N Ms), dove Ms è la lista di strutture monomio
  di Polinomio.
|#
(defun poly-power(Ms Power Acc)
	(cond ((= 0 Power) (create-mon 1 0 NIL))
	      ((= 1 Power) Acc)
	      (T (poly-power Ms (- Power 1) (ms-times-ms Ms Acc)))
	)
)

#|
  Funzione che, preso in input un esponente E, ritorna l'esponente valutato 
  dalla funzione eval se E è valutabile, intero e maggiore di 0,
  altrimenti viene lanciato un errore.
|#
(defun check-exp(E)
	(if (evaluablep E)
	    (let ((EE (eval E)))
	         (if (and (integerp EE) (>= EE 0))
		     EE
		     (error "~S evaluated from ~S, must be integer and >= 0" 
		            EE E
		     )
	         )
	    )
	    (error "~S is not evaluable" E)
	)
)

#|
  Funzione che ritorna T se Expression è una funzione valutabile 
  dalla funzione eval; se eval genera un errore (Expression non è valutabile),
  questo viene catturato e viene ritornato NIL.
|#
(defun evaluablep(Expression)
	(handler-case (if (and (not (eq 'T Expression)) (eval Expression))
	                  T
	                  NIL
	              ) 
		      (error () NIL)
	)
)

#|
  Funzione che, dati in input un'espressione Expression non "parsata" e un 
  operatore Op, restituisce una lista di strutture monomio non semplificate.
  Il suo comportamento si riassume in due step:
  1) "Capisce" che tipo di operazione deve svolgere
  2) Chiama ricorsivamente se stessa per eseguire tal operazione
  Le operazioni da essa supportate sono:
  - cambio di segno di un polinomio, ovvero -(Polinomio).
  - somma di polinomi.
  - sottrazione di polinomi.
  - moltiplicazione di polinomi.
  - polinomio elevato alla n, con n intero e non negativo.
  I casi base per l'uscita dalla ricorsione sono:
  - Expression è un numero,
  - oppure Expression è un simbolo di variabile. 
  In caso non riesca a parsare l'espressione data in input, lancia 
  un errore.   
|#
(defun parse-poly(Expression Op)	
	(cond ((numberp Expression)
			(create-mon Expression 0 NIL)
	      )
	      ((symbolp Expression)
	               (if (or (eq NIL Expression)
	                       (eq '+ Expression)
	                       (eq '- Expression)
	                       (eq '* Expression)
	                       (eq 'expt Expression)
	                   )
	                   (error "~S is not allowed as a variable" Expression)
	                   (create-mon 1 1 (list (list 'V '1 Expression)))
	               ) 
	      )
	      ;Si evita la ricorsione sulla lista vuota
	      ((= 1 (length Expression))
			(parse-poly (first Expression) NIL)
	      )
	      ;Expression = (- (Polinomio))
	      ((and (= 2 (length Expression)) 
		    (eq (first Expression) '-)
	       ) 
			(ms-times-k (parse-poly (second Expression) NIL) -1)
	      )
	      ((eq (first Expression) '+) 
			(parse-poly (rest Expression) '+)
	      )
	      ((eq (first Expression) '-) 
			(parse-poly (rest Expression) '-)
	      )
	      ((eq (first Expression) '*) 
			(parse-poly (rest Expression) '*)
	      )
	      ((eq (first Expression) 'expt) 
			(parse-poly (rest Expression) '^)
	      )
	      ((eq Op '+)
			(mapcan (lambda(X) (parse-poly X NIL)) 
	                        Expression
	                )             		
	      )
	      ((eq Op '-)
			(append (parse-poly (first Expression) NIL)
				(ms-times-k (parse-poly (rest Expression) '+) 
					    -1
				)			
			)		
	      )
	      ((eq Op '*)
			(reduce 'ms-times-ms (mapcar (lambda(X) 
			                                     (parse-poly X NIL)
			                             )
			                             Expression
			                     )
	       		)		
	      )
	      ((eq Op '^)
	                (if (and (evaluablep (first Expression)) 
				 (evaluablep (second Expression))
			    )
			    ;Base ed esponente valutbili dalla funzione eval 
			    (create-mon (expt (eval (first Expression)) 
					      (eval (second Expression))
			    	        ) 
					0 
					NIL
			    )
			    ;O base o esponente o entrambe non valutabili
			    (let ((EE (check-exp (second Expression)))
			          ;Parsing e semplificazione della base
				  (P (sort-simplify-ms
					    (parse-poly (first Expression) NIL)           
			             )
			          )
			         )
			         (let* ((M (first P))
			                (Vs (get-vs M))) 
			               (if (= 1 (length P))
			                  ;La base è un monomio 
			         	  (create-mon
			         	     (expt (get-coeff M) EE)
			                     (* EE (get-md M))
			         	     (mapcar (lambda(V) 
			         	    	       (substitute
			         	    	         (* EE (get-var-exp V))
			         	    	         (second V)
			         	    	         V
			         	    	       )
			         	    	     ) 
			         	    	     Vs
			         	     )
			         	  )
			         	  ;La base è un polinomio
			         	  (poly-power P EE P)
			               )    
			         )
		            )
			)		
	      )
	      ;Errore
	      (T (if (evaluablep Expression)
			(create-mon (eval Expression) 0 NIL)
			(error "~S is not evaluable" Expression)
		 )
	      )
	)
)

(defun get-coeff(M)
	(second M)
)

(defun get-md(M)
	(third M)
)

(defun get-vs(M)
	(fourth M)
)

(defun get-var-exp(V)
	(second V)
)

(defun get-var-sym(V)
	(third V)
)

#|
  Funzione che, presa in input una lista di strutture monomio Ms,
  ritorna una lista che contiene i simboli di variabile
  che compaiono nelle strutture get-vs di ogni M di Ms,
  ordinate e ripetute una sola volta.
  Ad esempio:
  (get-ms-vs '((M 1 1 ((V 1 C))) 
               (M 1 2 ((V 1 A) (V 1 B))) 
               (M 1 2 ((V 1 B) (V 1 C)))
              )
  ) -> (A B C)
|#
(defun get-ms-vs(Ms)
        (let* ((Vs (reduce 'append (mapcar 'get-vs Ms)))
               (Vars (mapcar (lambda(V) (get-var-sym V)) Vs))
              )
	      (remove-duplicates (sort Vars 'string<) 
		                 :test 'string-equal 
	      )
	)
)

#|
  Funzione che data una struttura monomio M in input calcola
  il grado totale di essa.
|#
(defun compute-total-deg(M)
	(reduce '+ (mapcar (lambda(V) (eval (get-var-exp V))) (get-vs M)))
)

;Funzione che "converte" Poly in una lista di strutture monomio.
(defun to-ms(Poly)
        (if (ignore-errors (or (eq 'POLY (first Poly)) (eq 'M (first Poly))))
            (if (polynomialp Poly)
                (compute-evals Poly)
                (error "~S is not a proper polynomial" Poly)
            )
            (sort-simplify-ms (parse-poly Poly NIL))
        )
)

#|
  Funzione che ritorna una lista di strutture monomio in cui per ogni monomio
  sono stati valutati dalla funzione eval i seguenti campi:
  - Coefficiente
  - Grado totale del monomio
  - Per ogni varpowers, l'esponente.
  Poly può essere una struttura monomio o una struttura polinomio.
  Ad esempio:
  (compute-evals '(M (max 3 2) (log 100 10) ((V (min 4 2 3) A))))
  -> ((M 3 2 ((V 2 A))))
|#
(defun compute-evals(Poly)
        (let ((Ms (if (eq 'M (first Poly))
                      (list Poly)
                      (second Poly)
                  )
             ))
             (mapcan (lambda(M)
                         (let* ((C (get-coeff M))
                                (EC (eval (get-coeff M)))
                                (EMD (eval (get-md M)))
                                (EVs (mapcan (lambda(V)
                                                (create-vs 
                                                        (eval (get-var-exp V)) 
                                                        (get-var-sym V)
                                                )
                                             ) 
                                             (get-vs M)
                                   )
                                )
                              )
                              (create-mon EC EMD EVs)
                         )
                     ) 
                     Ms
             )
        )
)

#|
  Funzione che, presi in input una lista di strutture varpowers Vs,
  una lista di simboli di variabile Vars e una lista di valori numerici Values,
  ritorna una lista di coppie in cui ogni coppia è del tipo (Exp VarValue).
  Ad esempio:
  (create-pairs '((V 1 A) (V 2 B) (V 3 C)) '(A B C) '(3 2 1))
  -> ((1 3) (2 2) (3 1))
|#
(defun create-pairs(Vs Vars Values)
        (mapcar (lambda(V) 
                        (list (get-var-exp V)
                              (nth (position (get-var-sym V) Vars) Values) 
                        )
	        ) 
	        Vs
        )
)


#|
  La funzione mon-eval restituisce il valore del monomio M 
  nel punto n-dimensionale rappresentato dalla lista Values, 
  che contiene un valore per ogni variabile di M, 
  rappresentata dalla lista Vars.      
|#
(defun mon-eval(M Vars Values)
	(* (get-coeff M)
	   (reduce '* (mapcar (lambda(Pair) (expt (second Pair) (first Pair))) 
	   	     	      (create-pairs (get-vs M) Vars Values)
	   	      )
	   )
	)
)

(defun format-first-mon(M)
	(let ((C (get-coeff M)) 
	      (MD (get-md M)) 
	      (Vs (get-vs M))
	     )
	     (cond ((= 0 MD) (write-to-string C))
		   ((= 1 C) (format-vs Vs))
		   ((= -1 C) (concatenate 'string "-" (format-vs Vs)))
	           (T (concatenate 'string 
		      		   (write-to-string C)
		      		   "*" 
				   (format-vs Vs)
		      )
		   )		
	     )
	)
)

(defun format-ms(Ms)
	(let ((C (get-coeff (first Ms))) 
	      (Vs (get-vs (first Ms)))
	     )
	     (cond ((null Ms) "")
		   ((= 1 C) (concatenate 'string " + " 
					         (format-vs Vs) 
					         (format-ms (rest Ms))
		            )
		   )
		   ((= -1 C) (concatenate 'string " - " 
					          (format-vs Vs) 
					          (format-ms (rest Ms))
		             )
		   )
		   ((> C 0) (concatenate 'string " + " 
					         (concatenate 'string 
						        (write-to-string C)
						        "*" 
						        (format-vs Vs)
					         ) 
					         (format-ms (rest Ms))
		            )
		   )
		   (T (concatenate 'string " - " 
				           (concatenate 'string 
					             (write-to-string (* -1 C))
					             "*" 
					             (format-vs Vs)
				           ) 
				           (format-ms (rest Ms))
		      )
		   )
	     )
	)
)

(defun format-vs(Vs)
	(let ((D (write-to-string (get-var-exp (first Vs)))) 
	      (V (string (get-var-sym (first Vs))))
	     )
	     (cond ((= 1 (length Vs))
	                (if (equal "1" D)
	                    V
	                    (concatenate 'string V "^" D)
	                )    
	           )
		   ((equal "1" D) 
		        (concatenate 'string V "*" (format-vs (rest Vs)))
		   )
		   (T (concatenate 'string 
				(concatenate 'string V "^" D)
				"*" 
				(format-vs (rest Vs))
		      )
		   )
             )
	)
)
