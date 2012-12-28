class HtmlEditorInput < Formtastic::Inputs::TextInput
  def upload_enabled?
    ActiveAdmin::Editor.configuration.s3_configured?
  end

  def policy
    ActiveAdmin::Editor::Policy.new
  end

  def wrapper_html_options
    return super unless upload_enabled?
    super.merge( :data => { :policy => policy.to_json })
  end

  def to_html
    html = '<div class="wrap">'
    html << builder.text_area(method, input_html_options)
    html << '</div>'
    html << '<div style="clear: both"></div>'
    input_wrapping do
      label_html << html.html_safe
    end
  end
end
