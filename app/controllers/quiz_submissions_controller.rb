class QuizSubmissionsController < ApplicationController
  before_action :find_quiz_submission, only: %i[show]
  include XapiMethods

  def show
    @quiz = @quiz_submission.quiz
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])

    user_answers = {}
    correct_answers = 0

    params.each do |key, value|
      next unless key.start_with?('question_')

      question_id = key.split('_').last.to_i
      selected_answer = value.to_i
      user_answers[question_id.to_s] = selected_answer

      question = Question.find(question_id)
      correct_answers += 1 if question.correct_answer == selected_answer
      
      send_question_statment(question, selected_answer)
    end

    score = (correct_answers.to_f / @quiz.questions.count) * 100
    @quiz_submission = QuizSubmission.create(quiz: @quiz, user: current_user, score: score, user_answers: user_answers)
    send_result_statment(score)

    redirect_to quiz_submission_path(@quiz, @quiz_submission)
  end

  private

  def find_quiz_submission
    @quiz_submission = QuizSubmission.find(params[:id])
  end

  def quiz_submission_params
    params.require(:quiz_submission).permit(:quiz_id, :user_id, :score, user_answers: {})
  end

  def send_question_statment(question, selected_answer)
    send_statment(
      verb: 'answered',
      verb_id: 'http://adlnet.gov/expapi/verbs/answered',
      object: "Question #{question.id}",
      object_id: "http://example.com/question-#{question.id}",
      object_description: question.content,
      activity_type: 'http://adlnet.gov/expapi/activities/question',
      response: question.send("answer#{selected_answer}"),
      success: question.correct_answer == selected_answer,
      score_details: nil
    )
  end

  def send_result_statment(score)
    passed = score >= 50
    verb = passed ? 'passed' : 'failed'
    verb_id = passed ? 'http://adlnet.gov/expapi/verbs/passed' : 'http://adlnet.gov/expapi/verbs/failed'

    send_statment(
      verb: verb,
      verb_id: verb_id,
      object: "Quiz #{@quiz.id}",
      object_id: "http://example.com/quiz-#{@quiz.id}",
      object_description: @quiz.title,
      activity_type: 'http://adlnet.gov/expapi/activities/assessment',
      response: nil,
      success: passed,
      score_details: {min: 0, raw: score, max: 100}
    )
  end
end