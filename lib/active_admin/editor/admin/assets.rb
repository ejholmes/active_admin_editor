ActiveAdmin.register ImageAsset do
  index as: :grid do |image_asset|
    link_to(image_tag(image_asset.storage.thumb), admin_image_asset_path(image_asset))
  end

  show do
    attributes_table do
      row('Thumnail') do
        image_tag(image_asset.storage.thumb)
      end
      row('Full Image') do
        image_tag(image_asset.storage)
      end
    end
  end
end
