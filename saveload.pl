save:-
    write('%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%  SIMPAN PROGRESSMU  %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%'),nl,nl,
    write('Nama File: '), read(File),
    atom_concat(File, '.txt', Filename),
    atom_concat('./gameMemory/', Filename, Path),
    open(Path, write, Stream), 
    user(CHARACTER,CLASS,CURRENTHEALTH,HEALTH,ATTACK,DEFENCE,GOLD,LEVEL,XP),
    write(Stream, user(CHARACTER,CLASS,CURRENTHEALTH,HEALTH,ATTACK,DEFENCE,GOLD,LEVEL,XP)),write(Stream, '.\n'),
    locPlayer(X,Y),
    write(Stream, locPlayer(X,Y)), write(Stream, '.\n'),
    inventoryData(Char_id, Item_1, Item_2, Item_3, Item_4, Potion_1, Potion_2, Potion_3, Potion_4, Potion_5, Potion_6),
    write(Stream, inventoryData(Char_id, Item_1, Item_2, Item_3, Item_4, Potion_1, Potion_2, Potion_3, Potion_4, Potion_5, Potion_6)), write(Stream, '.\n'),
    progressQuest(QuestId, ShredderCount, OozmaCount, KappaCount),
    write(Stream, progressQuest(QuestId, ShredderCount, OozmaCount, KappaCount)), write(Stream, '.\n'),
    statsQuest(A),
    write(Stream, statsQuest(A)), write(Stream, '.\n'),
    close(Stream),
    write('\n-----------------------\n\n      [BERHASIL]\n\nData disimpan di:\n >> '), write(Path),nl,nl.

load:-
    nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%      LOAD GAME      %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%'),nl,nl,
    write('Masukkan nama File yang ingin diload\n >> '), read(File),
    atom_concat(File, '.txt', Filename),
    atom_concat('./gameMemory/', Filename, Path),
    
    retractall(user(_,_,_,_,_,_,_,_,_)),
    retractall(locPlayer(_,_)),
    retractall(inventoryData(_,_,_,_,_,_,_,_,_,_,_)),
    retractall(progressQuest(_,_,_,_)),
    retractall(statsQuest(_)),

    open(Path, read, Stream),
    repeat,
        read(Stream, Line),
        assertz(Line),
    at_end_of_stream(Stream),
    write('\n-----------------------\n\n      [BERHASIL]\n\nData telah dimuat.\n'),
    format('~nFile yang dimuat: ~w~n', [Filename]),
    close(Stream),
    !.
