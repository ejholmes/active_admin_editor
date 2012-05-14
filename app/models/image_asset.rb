class ImageAsset < Asset
  attr_accessible :storage, :type
  mount_uploader :storage, ImageAssetUploader
  serialize :dimensions
end
