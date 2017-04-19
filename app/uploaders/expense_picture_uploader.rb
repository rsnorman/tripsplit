class ExpensePictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  process resize_to_fit: [500, 500]

  version :thumb do
    process resize_to_fit: [200, 200]
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_whitelist
    %w(jpg jpeg)
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
