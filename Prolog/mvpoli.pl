%%%% 807387 Avogadro Roberto
%%%% 808708 Belotti Federico

/** 
 * is_monomial(Monomial)
 * il predicato is_monomial è vero se Monomial è un monomio.
 */	
is_monomial(Monomial) :-
	monomials(Monomial, [_]),
	!.
is_monomial(Monomial) :-
	!,
	to_poly(Monomial, poly([])).			
/** 
 * is_polynomial(Polynomial)
 * il predicato is_polynomial è vero se Polynomial è un polinomio.
 */	
is_polynomial(Poly) :-
	to_poly(Poly, _).
	
 /** 
  * coefficients(Poly, Coefficients)
  * il predicato coefficients è vero quando Coefficients 
  * è una lista dei "ovviamente" coefficienti di Poly. 
  */
coefficients(Poly, Coefficients) :-  
	monomials(Poly, [M | Ms]),
	!,
	sort_simplify_ms([M | Ms], SSMs),	  
	get_coefficients(SSMs, Coefficients).
coefficients(Poly, [0]) :-
	!,  
	monomials(Poly, []).
	
/** 
 * variables(Poly, Variables)
 * il predicato variables è vero quando Variables è 
 * una lista dei simboli di variabile che appaiono in Poly.  
 */
variables(Poly, Variables) :- 
	monomials(Poly, Ms),  
	get_variables(Ms, Vs), 
	sort(Vs, Variables).

/**
 *  monomials(Poly, Monomials)
 *  il predicato monomials è vero quando Monomials è la lista ordinata, 
 *  dei monomi che appaiono in Poly.
 */  
monomials(Poly, Monomials) :- 
	to_poly(Poly, poly(Ms)),
	sort_simplify_ms(Ms, SSMs), 
	Monomials = SSMs.

/** 
 * maxdegree(Poly, Degree)
 * il predicato maxdegree è vero quando Degree 
 * è il massimo grado dei monomi che appaiono in Poly.
 */
maxdegree(Poly, Degree) :-
	monomials(Poly, Ms),
	last(Ms, m(_, Degree, _)).
	
/** 
 * mindegree(Poly, Degree)
 * il predicato mindegree è vero quando Degree 
 * è il minimo grado dei monomi che appaiono in Poly.
 */   
mindegree(Poly, Degree) :- 
	monomials(Poly, [m(_, Degree, _) | _]).	

/** 
 * polyplus(Poly1, Poly2, Result)
 * il predicato polyplus è vero quando Result 
 * è il polinomio somma di Poly1 e Poly2.
 */
polyplus(Poly1, Poly2, Result) :- 
	to_poly(Poly1, poly(Ms1)),
	to_poly(Poly2, poly(Ms2)), 
	append(Ms1, Ms2, Ms),
	sort_simplify_ms(Ms, SSMs),
	Result = poly(SSMs).
	
/** 
 * polyminus(Poly1, Poly2, Result)
 * il predicato polyplus è vero quando Result è 
 * il polinomio somma di Poly1 e Poly2.
 */			
polyminus(Poly1, Poly2, Result) :-
	to_poly(Poly1, poly(Ms1)), 
	to_poly(Poly2, poly(Ms2)),
	ms_times_k(Ms2, -1, NMs2),
	append(Ms1, NMs2, Ms),
	sort_simplify_ms(Ms, SSMs),
	Result = poly(SSMs).
	
/** 
 * polytimes(Poly1, Poly2, Result)
 * il predicato polytimes è vero quando Result è 
 * il polinomio risultante dalla moltiplicazione di Poly1 e Poly2.
 */	
polytimes(Poly1, Poly2, Result) :-
	to_poly(Poly1, poly(Ms1)),
	to_poly(Poly2, poly(Ms2)),
	ms_times_ms(Ms1, Ms2, Ms),
	sort_simplify_ms(Ms, SSMs),
	Result = poly(SSMs).

/** 
 * polytimes_k(Poly1, K, Result)
 * il predicato polytimes è vero quando Result è 
 * il polinomio risultante dalla moltiplicazione di Poly1 e K.
 */	
polytimes_k(Poly1, K, Result) :-
        catch(EK is K, _, fail),
	polytimes(Poly1, EK, Result).

/**
 *  polypower(Poly, Power, PPoly)
 *  il predicato polypower è vero quando
 *  PPoly è la lista Poly "elevata" alla power 
 */
polypower(Poly, N, PPoly) :- 
	to_poly(Poly, poly(Ms)),
	check_exponent(N, EN),
	poly_power(Ms, EN, Ms, PMs),
	sort_simplify_ms(PMs, SSPMs),
	PPoly = poly(SSPMs).

/**
 * as_monomial(Expression, Monomial)
 * il predicato as_monomial è vero quando Monomial è il termine 
 * che rappresenta il monomio risultante dal “parsing” dell’espressione Expression; 
 * il monomio risultante viene appropriatamente ordinato.
 * In questo caso abbiamo voluto sfruttare il concetto di "ereditarietà" 
 * secondo cui un monomio è un polinomio composto solo da un termine
 * (https://en.wikipedia.org/wiki/Monomial).
 * Di conseguenza ci siamo posti la seguente domanda:
 * si può considerare un monomio l'espressione x+x? O meglio:
 * sono da considerarsi monomi tutte quelle espressioni che, semplificate,
 * sono composte da un singolo termine?
 * Se lo si considera nella sua globalità x+x non è monomio, è sintatticamente
 * scorretto, ma se prima di porsi tal domanda si effettuano le semplificazioni
 * del caso, allora lo si può ritenere tale.
 * In definitiva abbiamo optato per considerare espressioni 
 * simili a x+x come dei monomi.
 * Per avere conferme, abbiamo posto la stessa domanda a wolfram|alpha:
 * https://www.wolframalpha.com/input/?i=is+x%2Bx+monomial%3F
 */
as_monomial(Expression, Monomial) :-
	as_polynomial(Expression, poly(Ms)),
	set_monomial(Ms, Monomial).
/**
 * as_polynomial(Expression, Polynomial)
 * il predicato as_polynomial è vero quando Polynomial 
 * è il termine che rappresenta il polinomio risultante
 * dal “parsing” dell’espressione Expression; 
 * il polinomio risultante viene appropriatamente ordinato.
 */
as_polynomial(Expression, Polynomial) :- 
	parse_poly(Expression, Ms),
	sort_simplify_ms(Ms, SSMs),
	Polynomial = poly(SSMs).	
	
/** 
 * polyval(Polynomial, VariableValues, Value)
 * il predicato polyval è vero quanto Value contiene il valore 
 * del polinomio Polynomial (che può anche essere un monomio), 
 * nel punto n-dimensionale rappresentato dalla lista VariableValues, 
 * che contiene un valore per ogni variabile 
 * ottenuta con il predicato variables/2.
 */  
polyval(Poly, VariableValues, Value) :-
	monomials(Poly, Ms),  
	get_variables(Ms, Vs),
	sort(Vs, Vars), 
	length(Vars, L1),
	length(VariableValues, L2),
	L2 >= L1,
	is_number_list(VariableValues),
	create_pairs(Vars, VariableValues, VarValPairs),
	ms_eval(Ms, VarValPairs, Value).

/** 
 * pprint_polynomial(Polynomial)
 * il predicato pprint polynomial risulta vero 
 * dopo aver stampato (sullo “standard output”) una 
 * rappresentazione tradizionale del termine polinomio 
 * associato a Polynomial. 
 */   
pprint_polynomial(Polynomial) :-
	to_poly(Polynomial, poly(Ms)),
	print_ms(Ms).
	
		
%%%%---------------------------------------------------------------------------

%%	Private predicates

%%	Sorting predicates 

/** 
 * ms_sort(Monomials, SMonomials)
 * il predicato ms_sort è vero quando SMonomials 
 * è la lista Monomials ordinata. 
 * nota: per "ordinata" si intende l'ordinamento dato da specifica.
 */
ms_sort(Ms, SMs) :- 
	predsort(mons_comp, Ms, SMs).
	
/** 
 * mons_comp(OP, Mon1, Mon2)
 */
mons_comp(<, m(_, MD1, Vs1), m(_, MD2, Vs2)) :- 
	(MD1 < MD2 ; MD1 = MD2, is_smaller(Vs1, Vs2)), 	       
	!.
mons_comp(>, m(_, _, _), m(_, _, _)) :- 
	!.

/** 
 *  is_smaller(VarsPowers1, VarsPowers2)
 */	
is_smaller([], [_ | _]) :- 
	!.
is_smaller([v(_E1, V1) | _Vs1], [v(_E2, V2) | _Vs2]) :- 
	V1 @< V2, 
	!.
is_smaller([v(E1, V) | _Vs1], [v(E2, V) | _Vs2]) :- 
	E1 < E2, 
	!.
is_smaller([v(E, V) | Vs1], [v(E, V) | Vs2]) :-
	!, 
	is_smaller(Vs1, Vs2).

/**
 * sort_simplify_ms(Monomials, SMonomials)
 * il predicato sort_simplify_ms è vero quando
 * SMonomials è la lista Monomials semplificata
 */	
sort_simplify_ms(Ms, SSMs) :-	
	sort_simplify_vs(Ms, NMs), 
	ms_sort(NMs, SMs), 
	simplify_ms(SMs, SSMs).	

%%	Parsing helpers predicates 

/**
 * simplify_vs(VarsPowers, SVarsPowers)
 * Il predicato simplify_vs è vero quando
 * SVarsPowers è la lista VarsPowers semplificata
 */
simplify_vs([], []) :- 
	!.
simplify_vs([v(0, _) | Vs], R) :- 
	!, 
	simplify_vs(Vs, R).
simplify_vs([v(E, A)], [v(E, A)]) :- 
	!.
simplify_vs([v(N, A), v(M, A) | Vs], R) :- 
	!, 
	S is N + M, 
	simplify_vs([v(S, A) | Vs], R).
simplify_vs([v(N, A), v(M, B) | Vs], [v(N, A) | R]) :- 
	!, 
	simplify_vs([v(M, B) | Vs], R).

/**
 * sort_simplify_vs(Monomials, SMonomials)
 * Il predicato sort_simplify_vs è vero quando
 * SMonomials è la lista Monomials in cui ogni termine
 * m(Coefficient, TotalDegree, VarsPowers) ha lista VarsPowers 
 * ordinata e semplificata.
 */
sort_simplify_vs([], []) :-
	!.
sort_simplify_vs([m(C, MD, Vs) | Ms], [m(C, MD, SSVs) | R]) :- 
	!, 
	sort(2, @=<, Vs, SVs), 
	simplify_vs(SVs, SSVs),
	sort_simplify_vs(Ms, R).
	
/**
 * simplify_ms(Monomials, SMonomials)
 * Il predicato simplify_ms è vero quando
 * SMonomials è la lista Monomials semplificata
 */
simplify_ms([], []) :- 
	!.
simplify_ms([m(0, _, _) | Ms], R) :- 
	!, 
	simplify_ms(Ms, R).	
simplify_ms([m(C, MD, V)], [m(C, MD, V)]) :- 
	!.
simplify_ms([m(C1, MD, V), m(C2, MD, V) | Ms], R) :- 
	!, 
	S is C1+C2, 
	simplify_ms([m(S, MD, V) | Ms], R).
simplify_ms([m(C1, MD1, V1), m(C2, MD2, V2) | Ms], [m(C1, MD1, V1) | R]) :- 
	!, 
	simplify_ms([m(C2, MD2, V2) | Ms], R).
	
/**
 * check_exponent(Exp, EvalExp)
 * Il predicato check_exponent è vero quando
 * EvalExp è valutazione di Exp
 */	
check_exponent(N, E) :-
	catch(E is N, _, fail),
	integer(E), 
	E >= 0.
/**
 * mon_power(VarsPowers, N, PVarsPowers)
 * Il predicato mon_power è vero quando
 * PVarsPower è la lista VarsPowers "elevata" alla N.
 * per elevevamento a potenza di una lista Vs alla N si intende 
 * la seguente operazione:
 * di ogni struttura v(...) moltiplicare il termine Power per N
 */
mon_power([], _, []) :- 
	!.
mon_power([v(D, V) | Vs], N, [v(M, V) | PVs]) :- 
	!,
	M is D*N, 
	mon_power(Vs, N, PVs).

/**
 * set_monomial(Mon, NMon)
 */
set_monomial([], m(0, 0, [])) :-
	!.
set_monomial([m(C, MD, Vs)], m(C, MD, Vs)) :-
	!.

%%%	Parsing predicates
	
/**
 * parse_poly(Expression, Monomials)
 * il predicato parse_poly è vero quando Monomials
 * è la lista risultante dal "parsing" di Expression
 * nota: 
 * parse_poly(P, _) :-
 *	var(P),
 *	!, 
 *	fail.	
 * è stato fatto per evitare ricorsione infinita nel caso venisso chiamato il
 * predicato ad esempio in questo modo as_polynomial(A, P)
 * cioè con entrambi gli argomenti come variabili.
 * questo perchè as_polynomial utilizza parse_poly per effettuare 
 * il "parsing" di un polinomio
 */	
parse_poly(P, _) :-
	var(P),
	!, 
	fail.	

% Recursive predicates
parse_poly(+(P), Ms) :-
	!, 
	parse_poly(P, Ms).
parse_poly(-(P), Ms) :-
	!, 
	parse_poly(P, R),
	ms_times_k(R, -1, Ms).
parse_poly(P1+P2, Ms) :-
	!, 
	parse_poly(P1, Ms1),
	parse_poly(P2, Ms2),
	append(Ms1, Ms2, Ms).
parse_poly(P1-P2, Ms) :- 
	!,
	parse_poly(P1, Ms1),
	parse_poly(P2, Ms2),
	ms_times_k(Ms2, -1, MMs2),
	append(Ms1, MMs2, Ms).
parse_poly(P1*P2, Ms) :-
	!,
	parse_poly(P1, Ms1),
	parse_poly(P2, Ms2),
	ms_times_ms(Ms1, Ms2, Ms).
parse_poly(X, [m(Y, 0, [])]) :-
	catch(Y is X, _, fail),
	!.
parse_poly(P^N, Ms) :-
	!,		
	parse_poly(P, NMs),
	sort_simplify_ms(NMs, SSNMs),
	check_exponent(N, E),
	parse_poly(SSNMs, E, Ms).
% Base cases
parse_poly(X, [m(1, 1, [v(1, X)])]) :-
	!,
	(X \= + , X \= - , X \= * , X \= ^),
	catch(atom(X), _, fail).
parse_poly([m(C, MD, Vs)], E, [m(NC, NMD, NPVs)]) :-
	!,
	mon_power(Vs, E, NPVs),
	NMD is MD*E,
	NC is C^E.
parse_poly(SSNMs, E, Ms) :-	
	!,
	poly_power(SSNMs, E, SSNMs, Ms).
	
%%%	Miscellanous predicates 

/** 
 * is_varpower(VarPower)
 */ 
is_varpower(v(Power, VarSymbol)) :- 
	integer(Power),
	Power >= 0,
	atom(VarSymbol).
		
/**
 * monomial(Monomial)
 * il predicato monomial è vero
 * se Monomial è struttura consistente e sintatticamente corretta 
 * rappresentante un monomio.
 * oppure Monomial è un espressione rappresentante un monomio
 */
monomial(poly([m(C, TD, Vs)])) :-
	!, 
	monomial(m(C, TD, Vs)).	
monomial(m(C, TD, Vs)) :- 
	!,	
	number(C),  
	integer(TD),
	TD >= 0,
	get_total_degree(Vs, TD), 
	is_list(Vs),  
	foreach(member(V, Vs), is_varpower(V)).
monomial(Monomial) :- 
	as_monomial(Monomial, _).

/**
 * polynomial(Monomials)
 * il predicato monomial è vero
 * se Monomials è struttura consistente e sintatticamente corretta 
 * rappresentante un polinomio.
 * oppure Monomials è un espressione Rappresentante un polinomio
 */
polynomial(m(C, MD, Vs)) :- 
	!,
	monomial(m(C, MD, Vs)).
polynomial(poly(Monomials)) :-
	!, 
	is_list(Monomials),  
	foreach(member(M, Monomials), monomial(M)).
polynomial(Expression) :- 
	!,
	as_polynomial(Expression, _).	

/** to_poly(Polyin, Polyout)
 *  il predicato to_poly è vero quando Polyout è la rappresentazione
 *  di Polyin nella forma poly(Monomials), dove monomials è una lista 
 *  di monomi nella forma m(Coefficient, TotalDegree, VarsPowers).	
 */
to_poly(m(C, MD, Vs), poly([m(EC, EMD, EVs)])) :-
	!,
	compute_ms_evals([m(C, MD, Vs)],[m(EC, EMD, EVs)]),
	monomial(m(EC, EMD, EVs)).
to_poly(poly(Monomials), poly(EMonomials)) :- 
	!,
	compute_ms_evals(Monomials, EMonomials),
	polynomial(poly(EMonomials)).
to_poly(Expression, Poly) :- 
	!,
	as_polynomial(Expression, Poly).
	
/** 
 *  compute_ms_evals(Monomials, EMonomials)
 *  il predicato compute_ms_evals è vero quando EMonomials è la lista
 *  EMonomials valutata.
 *  nota: per lista EMonomials valutata si inteda la lista in cui 
 *  nei termini m(Coefficient, TotalDegree, VarsPowers) sono stati
 *  valutatati Coefficient, TotalDegree e la lista VarsPowers.
 */		
compute_ms_evals([], []) :-
	!.	
compute_ms_evals([m(C, MD, Vs) | Ms], [ m(EC, EMD, EVs)| EMs]) :-
	!,
	EC is C,
	EMD is MD,
	compute_vs_evals(Vs, EVs),
	compute_ms_evals(Ms, EMs).

/** 
 *  compute_vs_evals(VarsPowers, EVarsPowers)
 *  il predicato compute_ms_evals è vero quando EVarsPowers è la lista
 *  VarsPowers valutata.
 *  nota: per lista VarsPowers valutata si inteda la lista in cui 
 *  nei termini v(Power, VarSymbol) è stato valutato Power.
 */		
compute_vs_evals([], []) :-
	!.	
compute_vs_evals([v(E, S) | Vs], [v(EE, S)| EVs]) :-
	!,
	EE is E, 	
	compute_vs_evals(Vs, EVs).
/**
 * get_total_degree(VarsPowers, Degree)
 * il predicato get_total_degree è varo quando Degree è il grado
 * della lista VarsPowers.
 * nota: per grado della lista VarsPowers si intende la somma dei Power
 * dei termini v(Power, VarSymbol) della lista VarsPowers.
 */
get_total_degree([], 0) :- 
	!.
get_total_degree([v(E, _) | Vs], Degree) :- 
	!,
	get_total_degree(Vs, R), 
	Degree is E+R.	

/**
 * get_coefficients(Monomials, Coefficients)
 * il predicato get_coefficients è vero quando Coefficients è la lista
 * dei coefficienti che appaiono nella lista Monomials.
 * dove Monomials è una lista di monomi.
 */	
get_coefficients([], []) :- 
	!.
get_coefficients([m(C, _, _) | Ms], [C | Cs]) :- 
	get_coefficients(Ms, Cs). 

/**
 * get_variables(Monomials, Vars)
 * il predicato get_variables è vero quando Vars è la lista
 * delle variabili che appaiono nella lista Monomials.
 * dove Monomials è una lista di monomi.
 */	
get_variables([], []) :- 
	!.
get_variables([m(_, _, []) | Ms], Vs) :- 
	!, 
	get_variables(Ms, Vs).
get_variables([m(_, _, [v(_, VM) | VMs]) | Ms], [VM | Vs]) :- 
	!, 
	get_variables([m(_, _, VMs) | Ms], Vs).

/**
 * get_variables(Monomials, Vars)
 * il predicato get_variables è vero quando Vars è la lista
 * delle variabili che appaiono nella lista Monomials.
 * dove Monomials è una lista di monomi.
 */	
get_varpowers([], []) :- 
	!.
get_varpowers([m(_, _, []) | Ms], Vs) :- 
	!, 
	get_varpowers(Ms, Vs).
get_varpowers([m(_, _, [v(E, V) | VMs]) | Ms], [v(E, V) | Vs]) :- 
	!, 
	get_varpowers([m(_, _, VMs) | Ms], Vs).			

/**
 * poly_power(Monomials, N, Acc, PMonomials)
 * il predicato poly_power è vero quando PMonomials è la lista
 * Monomials "elevata" alla N.
 * dove Monomials è una lista di monomi.
 * nota: Acc deve essere inizialmente settato uguale a Monomials 
 */
poly_power(_, 0, _, [m(1, 0, [])]) :- 
	!.
poly_power(_, 1, Acc, Acc) :- 
	!.
poly_power(Ms, N, Acc, Result) :- 
	ms_times_ms(Ms, Acc, R),
	K is N-1,
	poly_power(Ms, K, R, Result).
	
/**
 * ms_times_k(Monomials, K, KMonomials)
 * il predicato ms_times è vero quando KMonomials è la lista
 * Monomials i cui monomi sono stati moltiplicati per K. 
 * dove Monomials è una lista di monomi.
 */
ms_times_k([], _, []) :- 
	!.
ms_times_k(_, 0, []) :-
	!.
ms_times_k([m(0, _, _) | Ms], K, KMs) :- 
	!, 
	ms_times_k(Ms, K, KMs).
ms_times_k([m(C, MD, Vs) | Ms], K, [m(NC, MD, Vs) | KMs]) :-
	!, 
	NC is K*C, 
	ms_times_k(Ms, K, KMs).
	
/**
 * ms_times_ms(Monomials1, Monomials2, Monomials)
 * il predicato ms_times_ms è vero quando Monomials è il prodotto delle liste
 * Monomials1 e Monomials2
 * dove Monomials1 e Monomials2 sono liste di monomi.
 */ 
ms_times_ms(_Ms1, [m(0, _, _)], [m(0, 0, [])]) :- 
	!.
ms_times_ms([], _Ms2, []) :- 
	!.
ms_times_ms([M1 | Ms1], Ms2, Ms) :- 
	mon_times_ms(M1, Ms2, M1Ms2),
	ms_times_ms(Ms1, Ms2, NMs),
	append(M1Ms2, NMs, Ms).
	
/**
 * mon_times_ms(Monomial, Monomials2, Monomials)
 * il predicato mon_times_ms è vero quando Monomials è il prodotto del monomio
 * Monomial e della lista Monomials.
 * dove Monomials è una lista di monomi.
 */ 
mon_times_ms(m(_, _, _), [], []) :- 
	!.
mon_times_ms(M1, [M2 | Ms], [M1M2 | R]) :-
	!,
	mon_times_mon(M1, M2, M1M2),
	mon_times_ms(M1, Ms, R).

/**
 * mon_times_mon(Monomial1, Monomial2, Monomial)
 * il predicato mon_times_ms è vero quando Monomial è il prodotto dei monomi
 * Monomial1 e Monomial2.
 */ 	
mon_times_mon(m(C1, MD1, Vs1), m(C2, MD2, Vs2), m(NC, NMD, Vs)) :-
	NC is C1 * C2,
	NMD is MD1 + MD2,
	append(Vs1, Vs2, Vs).

/**
 * print_ms(Monomials)
 */ 
print_ms([]) :-
	!,
	writeln("0").
print_ms([M | Ms]) :-
	!,
	format_first_mon(M, MStr),
	format_ms(Ms, PolyStr),
	string_concat(MStr, PolyStr, Poly),	
	writeln(Poly).

/**
 * format_first_mon(Monomial)
 */ 
format_first_mon(m(C, 0, []), R) :-
	!,
	term_string(C, R).
% C = 1
format_first_mon(m(1, _, Vs), R) :- 
	!,
	format_vs(Vs, R).
% C = -1
format_first_mon(m(-1, _, Vs), R) :- 
	!,
	format_vs(Vs, VsStr),
	string_concat("-", VsStr, R).
% C != 1 and C != -1
format_first_mon(m(C, _, Vs), R) :- 
	!,
	term_string(C, CStr), 
	format_vs(Vs, VsStr),
	string_concat(CStr, "*", NCStr),
	string_concat(NCStr, VsStr, R).

/**
 * format_ms(Monomials)
 */ 
format_ms([], "") :-
	!.
% C = 1
format_ms([m(1, _, Vs) | Ms], R) :- 
	!,
	format_vs(Vs, VsStr),
	% + Vs
	string_concat(" + ", VsStr, PVsStr),
	format_ms(Ms, R2),
	string_concat(PVsStr, R2, R).
% C = -1
format_ms([m(-1, _, Vs) | Ms], R) :- 
	!,
	format_vs(Vs, VsStr),
	% + Vs
	string_concat(" - ", VsStr, PVsStr),
	format_ms(Ms, R2),
	string_concat(PVsStr, R2, R).
% C > 0 and C != 1
format_ms([m(C, _, Vs) | Ms], R) :- 
	C > 0,
	!,
	term_string(C, CStr), 
	format_vs(Vs, VsStr),
	% CVs
	string_concat(CStr, "*", NCStr),
	string_concat(NCStr, VsStr, CVsStr),
	% + CVs
	string_concat(" + ", CVsStr, PCVsStr),
	format_ms(Ms, R2),
	string_concat(PCVsStr, R2, R).
% C < 0 and C != -1
format_ms([m(C, _, Vs) | Ms], R) :- 
	!,
	NC is C*(-1),
	term_string(NC, CStr), 
	format_vs(Vs, VsStr),
	% CVs
	string_concat(CStr, "*", NCStr),
	string_concat(NCStr, VsStr, CVsStr),
	% + CVs
	string_concat(" - ", CVsStr, PCVsStr),
	format_ms(Ms, R2),
	string_concat(PCVsStr, R2, R).

/**
 * format_first_mon(VarsPowers)
 */ 
format_vs([v(1, V)], VStr) :- 
	!,
	term_string(V, VStr).
format_vs([v(1, V) | Vs], R) :- 
	!,
	term_string(V, VStr), 
	string_concat(VStr, "*", VTStr),
	format_vs(Vs, R2),
	string_concat(VTStr, R2, R).
format_vs([v(D, V)], VPwrDStr) :- 
	!,
	term_string(V, VStr), 
	term_string(D, DStr), 
	string_concat(VStr, "^", VPwrStr), 
	string_concat(VPwrStr, DStr, VPwrDStr).
format_vs([v(D, V) | Vs], R) :- 
	!,
	term_string(V, VStr), 
	term_string(D, DStr), 
	string_concat(VStr, "^", VPwrStr), 
	string_concat(VPwrStr, DStr, VPwrDStr),
	string_concat(VPwrDStr, "*", VPwrDTStr),
	format_vs(Vs, R2),
	string_concat(VPwrDTStr, R2, R).

/**
 * is_number_list(X)
 * il predicato is_number_list è vero quando X è una
 * lista di numeri.
 */ 	
is_number_list([]) :-
	!.
is_number_list([X]) :- 
	number(X), 
	!.
is_number_list([X | Xs]) :- 
	number(X), 
	!, 
	is_number_list(Xs).

/**
 * ms_eval(Monomials, VarVal, Val)
 */ 	
ms_eval([], _, 0) :- 
	!.
ms_eval([m(C, _, [])], [], C) :- 
	!.	
ms_eval([m(C, _, Vs) | Ms], VarValPairs, Val) :- 
	vs_eval(Vs, VarValPairs, VVs), 
	ms_eval(Ms, VarValPairs, NewVal), 
	Val is NewVal + (C*VVs).

/**
 * vs_eval(VarsPowers, VarVal, Val)
 */ 
vs_eval([], _, 1) :- 
	!.
vs_eval([v(D, V) | Vs], VarValPairs, Val) :- 
	get_val_value(VarValPairs, V, Value),	
	vs_eval(Vs, VarValPairs, NewVal),
	Val is NewVal*(Value^D). 

/**
 * create_pairs(Vars, Vals, VarVal)
 */ 
create_pairs([], _, []) :-
	!.
create_pairs([V | Vs], [Val | Vals], [[V, Val] | R]) :- 
	create_pairs(Vs, Vals, R).

/**
 * get_val_value(VarVal, Var, Value)
 */ 
get_val_value([[Var, Value] | _], Var, Value) :- 
	!.
get_val_value([[_, _] | VarValPairs], Var, Value) :- 
	!,
	get_val_value(VarValPairs, Var, Value). 	
				
	
mvpoli_test :- load_test_files([]), run_tests.


