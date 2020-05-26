# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('https://gist.github.com/gobedan/4651d1193e459cf6c90c34ee93d071ac').for(:url) }
  it { should_not allow_value('htt://gist.github.c/gobedan/4651d1193e459cf6c90c34ee93d071ac').for(:url) }
end
