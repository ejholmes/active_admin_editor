ActiveAdmin.register Asset do
  index as: :grid do |asset|
    link_to(image_tag(asset.storage.thumb), admin_asset_path(asset))
  end

  show do
    attributes_table do
      row('Thumnail') do
        image_tag(asset.storage.thumb)
      end
      row('Full Image') do
        image_tag(asset.storage)
      end
    end
  end
end
