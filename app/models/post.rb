class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    has_many :likes, as: :likeable, dependent: :destroy
    validates :title, :description, presence: true
  end
  