# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question, answers: create_list(:answer, 5)) }
  let(:answer) { create(:answer) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'validates association of best answer' do
    question.best_answer = answer
    expect(question).to be_invalid
    expect(question.errors[:base]).to include("answer is not associated with question")
  end
end
