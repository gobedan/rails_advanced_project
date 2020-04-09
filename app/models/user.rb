# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, dependent: :destroy, inverse_of: :author
  has_many :answers, dependent: :destroy, inverse_of: :author

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(content)
    content.author_id == id
  end
end
