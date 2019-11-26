require 'rails_helper'

RSpec.describe Board, type: :model do
  # Validation test
  # ensure that the rows and dices column are present before saving
  it { should validate_presence_of(:rows) }
  it { should validate_presence_of(:dices) }
end
