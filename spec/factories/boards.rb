FactoryBot.define do
  factory :board do
    rows { 4 }
    dices { Array.new(4) {|i| Array.new(4) {|j| Array('A'..'Z').shuffle.first} } }
  end
end