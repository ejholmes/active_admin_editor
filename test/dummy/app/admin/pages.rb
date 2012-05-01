ActiveAdmin.register Page do
  show do
    panel "Content" do
      raw page.content
    end
  end

  form do |f|
    f.inputs do
      f.input :content, as: :html_editor
      f.input :title
    end

    f.buttons
  end
end
