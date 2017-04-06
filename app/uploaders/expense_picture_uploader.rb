class ExpensePictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [500, 500]

  version :thumb do
    process resize_to_fit: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg)
  end
end
