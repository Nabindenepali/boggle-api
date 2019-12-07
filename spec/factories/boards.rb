FactoryBot.define do
  factory :board do
    rows { 4 }
    sequence(:dices) { |n| get_dices_for_board(n) }
  end
end

def get_dices_for_board(index)
  # arrays of different letters used on the dices for testing purpose
  dices = [
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
    ]
  ]
  return dices[index]
end