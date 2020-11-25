:- include('map.pl').
:- include('character.pl').
:- include('quest.pl').
:- include('inventory.pl').
:- include('enemy.pl').
:- include('battle.pl').
:- include('store.pl').

print_start :-
    write('LET\'S FIND DONATELLO!'),nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%                              ~Find Donatello~                                   %'),nl,
    write('% 1. start     : untuk memulai petualanganmu                                      %'),nl,
    write('% 2. map       : menampilkan peta                                                 %'),nl,
    write('% 3. status    : menampilkan status pemain                                        %'),nl,
    write('% 4. w         : gerak ke utara 1 langkah                                         %'),nl,
    write('% 7. a         : gerak ke barat 1 langkah                                         %'),nl,
    write('% 5. s         : gerak ke selatan 1 langkah                                       %'),nl,
    write('% 6. d         : gerak ke timur 1 langkah                                         %'),nl,
    write('% 7. inventory : menampilkan inventory                                            %'),nl,
    write('% 8. help      : menampilkan segala bantuan                                       %'),nl,
    write('% 9. quest     : menampilkan quest dan progress quest yang dimiliki               %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,nl.



start :-
    print_start,
    initLocPlayer,
    initProgressQuest,
    initEnemy,
    initCharacter,
    initInventory.

status :-
    printstats.

quest :-
    print_getQuest.

potion :-
    usePotion.

help :-
    print_start.