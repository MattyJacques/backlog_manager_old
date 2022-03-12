class Platform < ApplicationRecord
  belongs_to :platform_family
  has_and_belongs_to_many :games
end
