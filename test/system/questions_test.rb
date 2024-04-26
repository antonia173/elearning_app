require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
  setup do
    @question = questions(:one)
  end

  test "visiting the index" do
    visit questions_url
    assert_selector "h1", text: "Questions"
  end

  test "should create question" do
    visit questions_url
    click_on "New question"

    fill_in "Answer1", with: @question.answer1
    fill_in "Answer2", with: @question.answer2
    fill_in "Answer3", with: @question.answer3
    fill_in "Answer4", with: @question.answer4
    fill_in "Content", with: @question.content
    fill_in "Correct answer", with: @question.correct_answer
    fill_in "Quiz", with: @question.quiz_id
    click_on "Create Question"

    assert_text "Question was successfully created"
    click_on "Back"
  end

  test "should update Question" do
    visit question_url(@question)
    click_on "Edit this question", match: :first

    fill_in "Answer1", with: @question.answer1
    fill_in "Answer2", with: @question.answer2
    fill_in "Answer3", with: @question.answer3
    fill_in "Answer4", with: @question.answer4
    fill_in "Content", with: @question.content
    fill_in "Correct answer", with: @question.correct_answer
    fill_in "Quiz", with: @question.quiz_id
    click_on "Update Question"

    assert_text "Question was successfully updated"
    click_on "Back"
  end

  test "should destroy Question" do
    visit question_url(@question)
    click_on "Destroy this question", match: :first

    assert_text "Question was successfully destroyed"
  end
end
