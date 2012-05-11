class ImageAsset < Asset
  mount_uploader :storage, ImageAssetUploader
end
