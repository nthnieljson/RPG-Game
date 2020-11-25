:- include('character.pl').
:- include('enemy.pl').

:- dynamic(enemyCurrHP/1).
:- dynamic(userSpecialAttackCD/1).
:- dynamic(enemySpecialAttackCD/1).
:- dynamic(runStatus/1).

hurtEnemy(Dmg) :-
	enemyCurrHP(EnemyCurrentHP),
	EnemyCurrentHPNew is EnemyCurrentHP - Dmg,
	retract(enemyCurrHP(EnemyCurrentHP)),
	asserta(enemyCurrHP(EnemyCurrentHPNew)),!.
	
hurtUser(Dmg) :-
	user(Char, Class, UserCurrHP, UserHP, UserAtt, UserDef, Gold, Lvl),
	UserCurrHPNew is UserCurrHP - Dmg,
	retract(user(Char, Class, UserCurrHP, UserHP, UserAtt, UserDef, Gold, Lvl)),
	asserta(user(Char, Class, UserCurrHPNew, UserHP, UserAtt, UserDef, Gold, Lvl)),!.

increaseUserCD :-
	userSpecialAttackCD(SpecialAttackCD),
	retract(userSpecialAttackCD(SpecialAttackCD)),
	asserta(userSpecialAttackCD(3)),!.

decreaseUserCD :-
	userSpecialAttackCD(SpecialAttackCD),
	SpecialAttackCD =\= 0,
	NewSpecialAttackCD is SpecialAttackCD - 1,
	retract(userSpecialAttackCD(SpecialAttackCD)),
	asserta(userSpecialAttackCD(NewSpecialAttackCD)),!.

decreaseUserCD.
	
increaseEnemyCD :-
	enemySpecialAttackCD(SpecialAttackCD),
	retract(enemySpecialAttackCD(SpecialAttackCD)),
	asserta(enemySpecialAttackCD(3)),!.

decreaseEnemyCD:-
	enemySpecialAttackCD(SpecialAttackCD),
	SpecialAttackCD =\= 0,
	NewSpecialAttackCD is SpecialAttackCD - 1,
	retract(enemySpecialAttackCD(SpecialAttackCD)),
	asserta(enemySpecialAttackCD(NewSpecialAttackCD)),!.
	
decreaseEnemyCD.

%calculate damage dealt,
userAttacking(EnemyId, Dmg):-
	user(_,_, _, _, UserAtt, _, _, _),
	enemyData(EnemyId, _, _, _, EnemyDef,_),
	Dmg is (UserAtt),
	decreaseUserCD,
	hurtEnemy(Dmg),!.
	%rumus dmg masih belum pasti
	
userSpecialAttacking(EnemyId, Dmg):-
	userSpecialAttackCD(SpecialAttackCD),
	SpecialAttackCD =:= 0,
	user(_,_, _, _, UserAtt, _, _, _),
	enemyData(EnemyId, _, _, _, EnemyDef,_),
	Dmg is (UserAtt * 2),
	increaseUserCD, 
	hurtEnemy(Dmg),!.
	%rumus dmg masih belum pasti

userSpecialAttacking(EnemyId, Dmg):-
	userSpecialAttackCD(SpecialAttackCD),
	SpecialAttackCD =\= 0,
	Dmg is 0,
	write('Special Attack masih dalam cooldown!\n'),!.	
	

enemyAttacking(EnemyId, Dmg):-
	user(_,_, _, _, _, UserDef, _, _),
	enemyData(EnemyId, _, _, EnemyAtt, _, _),
	enemySpecialAttackCD(EnemyCD),
	(EnemyCD =:= 0 ->
		random(1, 4, X),
		(X =:= 1 ->
			Dmg is (EnemyAtt * 2),
			increaseEnemyCD
			;
			Dmg is (EnemyAtt),
			decreaseEnemyCD
		)
		;
		Dmg is (EnemyAtt),
		decreaseEnemyCD	
	),
	hurtUser(Dmg),!.
	%rumus dmg masih belum pasti

printBattleEnemyStat(EnemyId) :-
	enemyCurrHP(CurrHP),
	enemyData(EnemyId, _, HP, Att, Def, Lvl),
	format('Level: ~d\n', [Lvl]),
	format('Health: ~d/~d\n', [CurrHP, HP]),
	format('Attack: ~d\n', [Att]),
	format('Defense: ~d', [Def]),!.
	

printBattleUserStat :-
	user(Char, Class, UserCurrHP, UserHP, UserAtt, UserDef, Gold, Lvl),
	format('Your HP : ~d', [UserCurrHP]).


printBattleMenu :-
	userSpecialAttackCD(SpecialAttackCD),
	write('What will you do?'),nl,nl,
	write('|-----------------|-----------------|'),nl,
	format('|      Attack     |Special Attack(~d)|', [SpecialAttackCD]),nl,
	write('|-----------------|-----------------|'),nl,
	write('|      Potion     |       Run       |'),nl,
	write('|-----------------|-----------------|').


battleCommand(attack, EnemyId) :-
	userAttacking(EnemyId, UserDmg),
	format('You dealt ~d damage!\n', [UserDmg]),
	enemyCurrHP(EnemyCurrentHP),
	(EnemyCurrentHP > 0 ->
		enemyAttacking(EnemyId, EnemyDmg),
		enemyData(EnemyId, EnemyName, _, _, _, _),
		format('~w dealt ~d damage!\n', [EnemyName, EnemyDmg])
		;
		write('Enemy defeated!\n')
	), !.

battleCommand(specialAttack, EnemyId) :-
	userSpecialAttacking(EnemyId, Dmg),
	(Dmg =:= 0 -> 
		write('Use other action!\n') 
		; 
		format('Your special attack dealt ~d damage!\n', [Dmg]),
		enemyCurrHP(EnemyCurrentHP),
		(EnemyCurrentHP > 0 ->
			enemyAttacking(EnemyId, EnemyDmg),
			enemyData(EnemyId, EnemyName, _, _, _, _),
			format('~w dealt ~d damage!\n', [EnemyName, EnemyDmg])
			;
			write('Enemy defeated!\n')
		)	 
	),!.

battleCommand(run, EnemyId) :-
	random(1, 4, X),
	(X =:= 1 ->
		runStatus(RunStatus),
		retract(runStatus(RunStatus)),
		asserta(runStatus(1))
		;
		enemyAttacking(EnemyId, EnemyDmg),
		enemyData(EnemyId, EnemyName, _, _, _, _),
		format('~w dealt ~d damage!\n', [EnemyName, EnemyDmg])	
	), !.
	
battleCommand(potion, EnemyId) :-
	/*
	
	INSERT USE POTION HERE
	
	*/
	decreaseUserCD,
	enemyAttacking(EnemyId, EnemyDmg),
	enemyData(EnemyId, EnemyName, _, _, _, _),
	format('~w dealt ~d damage!\n', [EnemyName, EnemyDmg]).


% kondisi berhenti battle adalah, run || HP player <= 0 || HP enemy <= 0
battle(EnemyId):-
	enemyData(EnemyId, EnemyName, EnemyHP, _, _, _),
	format('You found a ~w\n', [EnemyName]),
	asserta(enemyCurrHP(EnemyHP)),
	asserta(userSpecialAttackCD(0)),
	asserta(enemySpecialAttackCD(0)),
	asserta(runStatus(0)),
	repeat,
		printBattleEnemyStat(EnemyId),nl,nl,
		printBattleUserStat,nl,nl,
		printBattleMenu,nl,nl,
		read(Command),
		battleCommand(Command, EnemyId),
		enemyCurrHP(EnemyCurrentHPNew),
		user(_, _, UserCurrentHPNew, _, _, _, _, _),
		runStatus(RunStatus),
		nl,
	(EnemyCurrentHPNew =< 0; UserCurrentHPNew =< 0; RunStatus =:= 1),
	retract(enemyCurrHP(EnemyCurrentHPNew)),
	retract(runStatus(RunStatus)),
	userSpecialAttackCD(UserCD),
	enemySpecialAttackCD(EnemyCD),
	retract(userSpecialAttackCD(UserCD)),
	retract(enemySpecialAttackCD(EnemyCD)).



	
%['battle.pl']. character. 1. battle(1).
