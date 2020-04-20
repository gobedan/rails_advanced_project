# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'sets current user as author' do
        expect { post :create, format: :js, params: { question_id: question, answer: attributes_for(:answer) } }.to change(user.answers, :count).by(1)
      end

      it 'saves new answer in associated collection' do
        expect { post :create, format: :js, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not saves new answer to database' do
        expect { post :create, format: :js, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
    end

    it 'render create template' do
      post :create, format: :js, params: { question_id: question, answer: attributes_for(:answer) }
      expect(response).to render_template 'answers/create'
    end
  end

  describe 'DELETE #destroy' do
    context 'with author user logged in' do
      before { login(answer.author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects back to question show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with non-author user logged in' do
      before { login(user) }

      let!(:answer) { create(:answer) }

      it 'cannot delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with author user logged in' do
      before { login(answer.author) }

      context 'with valid attribures' do
        it 'changes answer attributes' do
          patch :update, format: :js, params: { id: answer, answer: { body: 'new body' } }
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update template' do
          patch :update, format: :js, params: { id: answer, answer: attributes_for(:answer) }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not changes answer attributes' do
          expect do
            patch :update, format: :js, params: { id: answer, answer: attributes_for(:answer, :invalid) }
          end.to_not change(answer, :body)
        end
      end
    end

    context 'with non-author user logged in' do
      before { login(user) }

      let!(:answer) { create(:answer) }

      it 'cannot edit the answer' do
        patch :update, format: :js, params: { id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end
end
