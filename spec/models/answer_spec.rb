# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { create(:answer) }

  it { should belong_to :question }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should belong_to :author }

  it '#best? returns true if answer has been choosen as best' do
    answer.question.best_answer_id = answer.id
    expect(answer).to be_best
  end

  it '#best? returns false if answer has not been choosen as best' do
    expect(answer).to_not be_best
  end
end
