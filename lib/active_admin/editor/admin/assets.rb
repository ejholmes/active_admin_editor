ActiveAdmin.register ImageAsset do
  menu parent: 'Assets', label: 'Images'
  index as: :grid do |image_asset|
    link_to(image_tag(image_asset.storage.thumb), admin_image_asset_path(image_asset))
  end

  form do |f|
    f.inputs do
      f.input :storage
    end

    f.buttons
  end

  show do
    attributes_table do
      row('Dimensions') do
        "#{image_asset.dimensions[:width]}px x #{image_asset.dimensions[:height]}px"
      end
      row('Thumnail') do
        image_tag(image_asset.storage.thumb)
      end
      row('25%') do
        image_tag(image_asset.storage.one_quarter)
      end
      row('50%') do
        image_tag(image_asset.storage.half)
      end
      row('75%') do
        image_tag(image_asset.storage.three_quarters)
      end
      row('Full Image') do
        image_tag(image_asset.storage)
      end
    end
  end
end
