class Payment < ApplicationRecord
  belongs_to :cadena, optional: true
  belongs_to :participant, optional: true
  belongs_to :user, optional: true
end
