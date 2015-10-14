# encoding: utf-8

class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog

  version :thumb do
    process resize_to_fit: [0, 50]
  end

  def store_dir
    "blog/#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
