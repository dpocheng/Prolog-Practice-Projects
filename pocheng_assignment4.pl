% Question 1: Train Travel
% routeTrip(seattle, oceanside, Trip).
% Trip = [seattle, portland, sanfrancisco, bakersfiled, sandiego,
% oceanside].
nonStopTrain(sandiego,oceanside).
nonStopTrain(lasvegas,sandiego).
nonStopTrain(sanfrancisco,bakersfield).
nonStopTrain(bakersfield,sandiego).
nonStopTrain(oceanside,losangeles).
nonStopTrain(portland,sanfrancisco).
nonStopTrain(seattle,portland).

routeTrip(X,Y,[X, Y]):- nonStopTrain(X,Y).
routeTrip(X,Y,[X|Trip]):- nonStopTrain(X,Z), routeTrip(Z,Y,Trip).


% Question 2: NCAA Play-offs
% playoffs(X).
% X = [[gonzaga, washington],[oklahoma, iowa], ...]
team(connecticut,22,2,east).
team(duke,24,1,east).
team(memphis,23,2,south).
team(villanova,20,2,east).
team(gonzaga,21,3,west).
team(texas,22,3,south).
team(georgeWashington,20,1,east).
team(tennessee,18,3,south).
team(pittsburgh,19,3,midwest).
team(florida,21,3,east).
team(westVirginia,18,6,east).
team(ohioState,18,3,midwest).
team(bostoncollege,20,5,east).
team(illinois,20,4,midwest).
team(uCLA,20,5,west).
team(michiganState,18,7,midwest).
team(georgetown,17,5,east).
team(iowa,20,6,midwest).
team(oklahoma,16,5,midwest).
team(washington,18,5,west).
team(northCarolinaState,19,5,east).
team(kansas,18,6,midwest).
team(northCarolina,15,6,east).
team(bucknell,20,3,east).
getWinsByName(N,W):- team(N,W,_,_).
teamsInZone(Zone,Teams):-findall(X,team(X,_,_,Zone),Teams).
findAllTeams(West,Midwest,South,East):-teamsInZone(west,West),teamsInZone(midwest,Midwest),teamsInZone(south,South),teamsInZone(east,East).
maxWins([X],X).
maxWins([X|T],X):-maxWins(T,M),getWinsByName(X,W1),getWinsByName(M,W2),W1>=W2.
maxWins([X|T],M):-maxWins(T,M),getWinsByName(X,W1),getWinsByName(M,W2),W1<W2.
minWins([X],X).
minWins([X|T],X):-minWins(T,M),getWinsByName(X,W1),getWinsByName(M,W2),W1<W2.
minWins([X|T],M):-minWins(T,M),getWinsByName(X,W1),getWinsByName(M,W2),W1>=W2.
findMinMax(Teams,Min,Max):-maxWins(Teams,Max),minWins(Teams,Min).
listAppend([],Min,Max,[[Max, Min]]).
listAppend([H|T],Min,Max,[H|Min_Max]):-listAppend(T,Min,Max,Min_Max).
isEqual(X,Y):-X==Y.
isNotEqual(X,Y):-X\=Y.
isLess(X,Y):-getWinsByName(X,X1),getWinsByName(Y,Y1),X1=<Y1.
delTeam(X,[X|T],T).
delTeam(X,[H|T],[H|NT]):-delTeam(X,T,NT).
teamsList([],Min,Max,LO,P,RP):-(isEqual(Min,Max)->(LO=Min);(LO="None")),RP=P.
teamsList(T,Min,Max,LO,P,RP):-findMinMax(T,Min,Max),delTeam(Min,T,NT),(isNotEqual(Min,Max)->(listAppend(P,Min,Max,NP),delTeam(Max,NT,NT2),teamsList(NT2,_,_,LO,NP,RP));teamsList(NT,Min,Max,LO,P,RP)).
callTeamsList(Zone,LO,RP):-teamsInZone(Zone,Teams),teamsList(Teams,_,_,LO,[],RP).
teamsAppend([],L2,L2).
teamsAppend([H1|T1],L2,[H1|T1_L2]):-teamsAppend(T1,L2,T1_L2).
generatePlayoffs(Z1,Z2,Z3,Z4,T1,T2,T3,T4,X):-
	callTeamsList(Z1,T1,L1),
	callTeamsList(Z2,T2,L2),
	callTeamsList(Z3,T3,L3),
	callTeamsList(Z4,T4,L4),
	teamsAppend([],L1,X1),
	teamsAppend(X1,L2,X2),
	teamsAppend(X2,L3,X3),
	teamsAppend(X3,L4,X).
checkingZone(Z1,Z2,Z3,Z4,T1,T2,T3,T4,W,M,S,E):-
	((isEqual(Z1,west)->W=T1);
	 (isEqual(Z2,west)->W=T2);
	 (isEqual(Z3,west)->W=T3);
	 (isEqual(Z4,west)->W=T4)),
	((isEqual(Z1,midwest)->M=T1);
	 (isEqual(Z2,midwest)->M=T2);
	 (isEqual(Z3,midwest)->M=T3);
	 (isEqual(Z4,midwest)->M=T4)),
	((isEqual(Z1,south)->S=T1);
	 (isEqual(Z2,south)->S=T2);
	 (isEqual(Z3,south)->S=T3);
	 (isEqual(Z4,south)->S=T4)),
	((isEqual(Z1,east)->E=T1);
	 (isEqual(Z2,east)->E=T2);
	 (isEqual(Z3,east)->E=T3);
	 (isEqual(Z4,east)->E=T4)).
pairLeftover(Z1,Z2,Z3,Z4,T1,T2,T3,T4,X1,X):-
	checkingZone(Z1,Z2,Z3,Z4,T1,T2,T3,T4,W,M,S,E),
        (isLess(W,M)->listAppend(X1,W,M,X2);
		      listAppend(X1,M,W,X2)),
	(isLess(S,E)->listAppend(X2,S,E,X);
		      listAppend(X2,E,S,X)).
playoffs(X):-
	permutation([Z1,Z2,Z3,Z4],[west,midwest,south,east]),
	generatePlayoffs(Z1,Z2,Z3,Z4,T1,T2,T3,T4,X1),
	pairLeftover(Z1,Z2,Z3,Z4,T1,T2,T3,T4,X1,X).


% Question 3: The Seating Chart
% Name Gender Hobbies
%             Hobby 1 Hobby 2 Hobby 3
% jim	 m     sup     fish    kayak
% tom	 m     hike    fish    ski
% joe	 m     gamer   chess   climb
% bob	 m     paint   yoga    run
% fay	 f     sup     dance   run
% beth	 f     climb   cycle   fish
% sue	 f     yoga    skate   ski
% cami	 f     run     kayak   gamer

guest(jim,m,sup,fish,kayak).
guest(tom,m,hike,fish,ski).
guest(joe,m,gamer,chess,climb).
guest(bob,m,paint,yoga,run).
guest(fay,f,sup,dance,run).
guest(beth,f,climb,cycle,fish).
guest(sue,f,yoga,skate,ski).
guest(cami,f,run,kayak,gamer).
getGuestName(Names):-findall(X,guest(X,_,_,_,_),Names).
seatingChart([G1, G2, G3, G4, G5, G6, G7, G8]):-
	getGuestName(Names),
	permutation([G1,G2,G3,G4,G5,G6,G7,G8],Names),
	\+error([G1,G2,G3,G4,G5,G6,G7,G8]).

error([G1,G2,_,_,_,_,_,_]):-
	guest(G1,S1,H11,H12,H13),guest(G2,S2,H21,H22,H23),
	(S1==S2;S1\=S2,
	 (H11\=H21, H11\=H22, H11\=H23,
	  H12\=H21, H12\=H22, H12\=H23,
	  H13\=H21, H13\=H22, H13\=H23)).
error([_,G2,G3,_,_,_,_,_]):-
	guest(G2,S2,H21,H22,H23),guest(G3,S3,H31,H32,H33),
	(S2==S3;S2\=S3,
	 (H21\=H31, H21\=H32, H21\=H33,
	  H22\=H31, H22\=H32, H22\=H33,
	  H23\=H31, H23\=H32, H23\=H33)).
error([_,_,G3,G4,_,_,_,_]):-
	guest(G3,S3,H31,H32,H33),guest(G4,S4,H41,H42,H43),
	(S3==S4;S3\=S4,
	 (H31\=H41, H31\=H42, H31\=H43,
	  H32\=H41, H32\=H42, H32\=H43,
	  H33\=H41, H33\=H42, H33\=H43)).
error([_,_,_,G4,G5,_,_,_]):-
	guest(G4,S4,H41,H42,H43),guest(G5,S5,H51,H52,H53),
	(S4==S5;S4\=S5,
	 (H41\=H51, H41\=H52, H41\=H53,
	  H42\=H51, H42\=H52, H42\=H53,
	  H43\=H51, H43\=H52, H43\=H53)).
error([_,_,_,_,G5,G6,_,_]):-
	guest(G5,S5,H51,H52,H53),guest(G6,S6,H61,H62,H63),
	(S5==S6;S5\=S6,
	 (H51\=H61, H51\=H62, H51\=H63,
	  H52\=H61, H52\=H62, H52\=H63,
	  H53\=H61, H53\=H62, H53\=H63)).
error([_,_,_,_,_,G6,G7,_]):-
	guest(G6,S6,H61,H62,H63),guest(G7,S7,H71,H72,H73),
	(S6==S7;
	S6\=S7,(H61\=H71, H61\=H72, H61\=H73,
	H62\=H71, H62\=H72, H62\=H73,
	H63\=H71, H63\=H72, H63\=H73)).
error([_,_,_,_,_,_,G7,G8]):-
	guest(G7,S7,H71,H72,H73),guest(G8,S8,H81,H82,H83),
	(S7==S8;S7\=S8,
	 (H71\=H81, H71\=H82, H71\=H83,
	  H72\=H81, H72\=H82, H72\=H83,
	  H73\=H81, H73\=H82, H73\=H83)).
error([G1,_,_,_,_,_,_,G8]):-
	guest(G1,S1,H11,H12,H13),guest(G8,S8,H81,H82,H83),
	(S1==S8;S1\=S8,
	 (H11\=H81, H11\=H82, H11\=H83,
	  H12\=H81, H12\=H82, H12\=H83,
	  H13\=H81, H13\=H82, H13\=H83)).
