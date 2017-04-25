compose([], L2, L2).
compose(L1, L2, L3) :-
	[H|T] = L1,
	[H|S] = L3,
	compose(L2, T, S).

distinct([]):-true.
distinct(L):-
	[H|T] = L,
	(member(H,T) -> false;
		distinct(T)).

solution(David,Peter,Jim,Robert,California, Oregon, Washington, Arizona,Baseball, Basketball, Handball, Football):-

	member(California,[11,12,13,14]),
	member(Oregon,[11,12,13,14]),
	member(Washington,[11,12,13,14]),
	member(Arizona,[11,12,13,14]),

	member(David,[11,12,13,14]),
	member(Peter,[11,12,13,14]),
	member(Jim,[11,12,13,14]),
	member(Robert,[11,12,13,14]),

	member(Baseball,[11,12,13,14]),
	member(Basketball,[11,12,13,14]),
	member(Handball,[11,12,13,14]),
	member(Football,[11,12,13,14]),

	David = California,
	Baseball < Oregon,
	Peter = Washington,
	Jim = Basketball,
	Jim > David,
	Handball is Washington + 1,
	Football = 11,
	Robert = Arizona,
	Peter = 12,
	Robert = 13,

	distinct([David, Peter, Jim,Robert]),
	distinct([California, Oregon, Washington, Arizona]),
	distinct([Baseball, Basketball, Handball, Football]).


language(k, English).
language(e, English).
language(h, English).
language(i, English).
language(b, French).
language(g, French).
language(i, French).
language(c, Korean).
language(d, Korean).
language(f, Korean).
language(j, Korean).
language(d, Chinese).
language(g, Chinese).
language(h, Chinese).
language(j, Chinese).
language(k, Chinese).

gender(b, female).
gender(e, female).
gender(h, female).
gender(c, female).
gender(j, female).

gender(k, male).
gender(i, male).
gender(g, male).
gender(f, male).
gender(d, male).

seating(X):-
	member(B,[b,e,h,c,j]),
	member(C,[i,d,f,g]),
	member(D,[b,e,h,c,j]),
	X = [k,B,C,D],
	distinct(X).