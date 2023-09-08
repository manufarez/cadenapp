class Payment < ApplicationRecord
  belongs_to :cadena
  belongs_to :participant
  belongs_to :user
end
