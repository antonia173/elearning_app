class Question < ApplicationRecord
  belongs_to :quiz
  validates :correct_answer, inclusion: { in: 1..4 }
end
