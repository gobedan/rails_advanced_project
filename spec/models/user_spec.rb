# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it { should have_many(:questions).dependent(:destroy).inverse_of(:author) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'returns true if user is author of content' do
    expect(question.author.author_of?(question)).to be true
  end

  it 'returns false if user is not author of content' do
    expect(user.author_of?(question)).to be false
  end
end
