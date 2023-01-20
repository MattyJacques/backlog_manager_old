require 'rails_helper'

RSpec.describe TrophyList, type: :model do
  it { should belong_to(:release) }
  it { should have_many(:trophies).dependent(:destroy) }

  it { should define_enum_for(:region).with_values([:europe, :north_america, :germany, :asia, :china, :japan, :original]) }
end
