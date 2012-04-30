class HtmlEditorInput < Formtastic::Inputs::TextInput
  def toolbar
    <<-HTML
    <div id="#{input_html_options[:id]}-toolbar" class="active_admin_editor_toolbar">
      <a data-wysihtml5-command="bold" title="CTRL+B">bold</a>
      <a data-wysihtml5-command="italic" title="CTRL+I">italic</a> |
      <a data-wysihtml5-command="createLink">insert link</a> |
      <a data-wysihtml5-command="insertLibraryImage">insert image</a> |
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h1">h1</a> |
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2">h2</a> |
      <a data-wysihtml5-command="insertUnorderedList">insertUnorderedList</a> |
      <a data-wysihtml5-command="insertOrderedList">insertOrderedList</a>
      <a data-wysihtml5-action="change_view">switch to html view</a>

      <div data-wysihtml5-dialog-container="insertLibraryImage" style="display: none;">
      </div>

      <div data-wysihtml5-dialog="createLink" style="display: none;">
        <label>
          Link:
          <input data-wysihtml5-dialog-field="href" value="http://">
        </label>
        <a data-wysihtml5-dialog-action="save">OK</a>&nbsp;<a data-wysihtml5-dialog-action="cancel">Cancel</a>
      </div>
      
    </div>
    HTML
  end

  def input_html_options
    {
      'active-admin-editor' => true
    }.merge(super)
  end

  def to_html
    html = '<div class="active_admin_editor">'
    html << toolbar.html_safe
    html << builder.text_area(method, input_html_options)
    html << '</div>'
    input_wrapping do
      label_html << html.html_safe
    end
  end
end
