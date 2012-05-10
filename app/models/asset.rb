class Asset < ActiveRecord::Base
  attr_accessible :storage, :type
  mount_uploader :storage, AssetUploader
end
