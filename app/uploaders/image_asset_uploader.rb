# encoding: utf-8

class ImageAssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :store_geometry

  def store_geometry
    if @file
      img = ::Magick::Image::read(@file.file).first
      if model
        model.dimensions = {
          width: img.columns,
          height: img.rows
        }
      end
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [100, 100]
  end

  # Only allow images
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
