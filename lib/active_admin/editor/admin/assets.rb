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
      row('Thumbnail') do
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

  controller do

    def create
      if params['qqfile']
        @image_asset = ImageAsset.new
        io = request.env['rack.input']

        def io.original_filename=(name) @original_filename = name; end
        def io.original_filename() @original_filename; end

        io.original_filename = params['qqfile']

        @image_asset.storage = io
        if @image_asset.save!
          render json: { success: true }.to_json
        else
          render nothing: true, status: 500 and return
        end
      else
        create!
      end
    end

  end
end
