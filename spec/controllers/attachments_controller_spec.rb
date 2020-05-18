# frozen_string_literal: true

require 'rails_helper'
require 'active_support/inflector'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    context 'with author user logged in' do
      before { login(question.author) }

      let!(:question) { create(:question, :with_attachments) }

      it 'deletes the file' do
        expect { delete :destroy, format: :js, params: { id: question.files.first } }.to change(question.files.attachments, :count).by(-1)
      end

      it 'renders update template' do
        delete :destroy, format: :js, params: { id: question.files.first.id }
        expect(response).to render_template 'questions/update'
      end
    end

    context 'with non-author user logged in' do
      before { login(user) }

      let!(:question) { create(:question, :with_attachments) }

      it 'cannot delete file' do
        expect { delete :destroy, format: :js, params: { id: question.files.first } }.to_not change(question.files.attachments, :count)
      end
    end
  end
end
