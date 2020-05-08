# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question, answers: create_list(:answer, 5)) }
  let(:answer) { create(:answer) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'has best answer' do
    question.answers.first.toggle_best
    expect(question.best_answer).to eq question.answers.first
  end

  it 'has many attached file' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
