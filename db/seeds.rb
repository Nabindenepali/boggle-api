# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

board_dices = [
    [
        %w(D E H N),
        %w(K T M B),
        %w(C R E N),
        %w(F A D T)
    ],
    [
        %w(E G H K),
        %w(M N Y D),
        %w(E I O R),
        %w(N T E I)
    ],
    [
        %w(E B S L),
        %w(T H A W),
        %w(G Y N I),
        %w(P K R F)
    ],
    [
        %w(T E O V),
        %w(E S R F),
        %w(W N A P),
        %w(C A R I)
    ],
    [
        %w(M A P O),
        %w(E T E R),
        %w(D E N I),
        %w(L D H C)
    ],
    [
        %w(T H Y N),
        %w(P R E I),
        %w(L C R A),
        %w(M S E T)
    ],
    [
        %w(P L A M),
        %w(N E R Y),
        %w(T V W I),
        %w(E G H B)
    ],
    [
        %w(D E A R),
        %w(N T O N),
        %w(R A V I),
        %w(R L C N)
    ],
    [
        %w(H G I N),
        %w(T L F S),
        %w(A E N T),
        %w(M U Y R)
    ],
    [
        %w(R L A P),
        %w(F U R T),
        %w(H L M E),
        %w(I O P K)
    ]
]

board_dices.each do |board_dice|
  Board.create(rows: 4, dices: board_dice)
end
