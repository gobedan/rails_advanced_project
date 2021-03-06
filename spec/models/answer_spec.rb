# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { create(:answer) }
  let!(:question) { create(:question, answers: create_list(:answer, 2)) }

  it { should belong_to :author }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should accept_nested_attributes_for :links }

  it "sets answer's best flag" do
    answer.toggle_best
    expect(answer).to be_best
  end

  it "removes answer's best flag" do
    answer.toggle_best
    answer.toggle_best
    expect(answer).to_not be_best
  end

  it "have no more than one best answer for question" do
    question.answers[0].toggle_best
    question.answers[1].toggle_best
    question.answers.reload

    expect(question.answers[0]).to_not be_best
    expect(question.answers[1]).to be_best
  end

  it 'has many attached file' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
