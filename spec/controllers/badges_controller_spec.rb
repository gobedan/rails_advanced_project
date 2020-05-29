# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    before { login(user) }

    it 'renders index badges template' do
      get :index
      expect(response).to render_template :index
    end
  end
end
