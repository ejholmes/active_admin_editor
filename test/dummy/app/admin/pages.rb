ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :content, as: :html_editor
      f.input :title
    end

    f.buttons
  end
end
