# frozen_string_literal: true

class Badge < ApplicationRecord
  belongs_to :question
  belongs_to :reciever, class_name: 'User', inverse_of: :badges, optional: true

  has_one_attached :image

  validates :title, :image, presence: true
end
