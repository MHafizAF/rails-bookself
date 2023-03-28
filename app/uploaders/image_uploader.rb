class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process :tags => ['book_picture']

  def extension_allowlist
    %w(jpg jpeg png)
  end
end
