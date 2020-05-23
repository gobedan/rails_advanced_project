# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, answers: create_list(:answer, 1)) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    before do
      get :show, params: { id: question }
    end

    it 'assigns a new Link to answer' do
      # controller тут нужен чтобы не был путаницы с answer который в let(:answer)
      expect(controller.answer.links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Link to question' do
      # controller тут нужен чтобы не был путаницы с question который в let(:question)
      expect(controller.question.links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'sets current user as author' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(controller.question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with author user logged in' do
      before { login(question.author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with non-author user logged in' do
      before { login(user) }

      let!(:question) { create(:question) }

      it 'cannot delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with author user logged in' do
      before { login(question.author) }

      context 'with valid attribures' do
        it 'changes question attributes' do
          patch :update, format: :js, params: { id: question, question: { title: 'new title', body: 'new body' } }
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update template' do
          patch :update, format: :js, params: { id: question, question: attributes_for(:question) }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not changes question attributes' do
          expect do
            patch :update, format: :js, params: { id: question, question: attributes_for(:question, :invalid) }
          end.to_not change(question, :body)
          # Рспек ругается на попытку сцепить через .or - пишет что это плохой стиль вместе с not_to
          expect do
            patch :update, format: :js, params: { id: question, question: attributes_for(:question, :invalid) }
          end.to_not change(question, :title)
        end
      end
    end

    context 'with non-author user logged in' do
      before { login(user) }

      let!(:question) { create(:question) }

      it 'cannot edit the question' do
        patch :update, format: :js, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.body).to_not eq 'new body'
        expect(question.title).to_not eq 'new title'
      end
    end
  end
end
