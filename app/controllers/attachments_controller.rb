# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :expose_record_helper

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

  def record_class
    record.class.to_s.downcase
  end

  def expose_record_helper
    self.class.define_method(record_class) { record }
    self.class.helper_method(record_class)
  end
end
