class QuizSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  after_initialize :init 

  def init
    self.user_answers ||= {}
  end
  
end
