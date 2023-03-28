class Book < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :writer
end
