# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'sets current user as author'
      # do
      #   expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(user.answers, :count).by(1)
      # end

      it 'saves new answer in associated collection' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not saves new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
    end

    it 'redirects to Question#show view' do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
      expect(response).to redirect_to question_path(controller.question)
    end
  end

  describe 'DELETE #destroy' do
    context 'with author user logged in' do
      before { login(answer.author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to change(Answer, :count).by(-1)
      end
    end

    context 'with non-author user logged in' do
      before { login(user) }

      let!(:answer) { create(:answer) }

      it 'cannot delete the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to_not change(Answer, :count)
      end
    end
  end
end
