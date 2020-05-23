# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :expose_record_helper
  before_action :prepend_view_paths, only: :destroy

  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }
  expose :record, -> { attachment.record }

  def destroy
    if current_user.author_of?(record)
      attachment.purge
      render "#{record_class.pluralize}/update"
    else
      render file: Rails.root.join('public/403.html'), status: 403, layout: false
    end
  end

  private

  def prepend_view_paths
    prepend_view_path "app/views/#{record_class.pluralize}"
    lookup_context.prefixes << record_class.pluralize
  end

  def record_class
    record.class.to_s.downcase
  end

  def expose_record_helper
    self.class.define_method(record_class) { record }
    self.class.helper_method(record_class)
  end
end
