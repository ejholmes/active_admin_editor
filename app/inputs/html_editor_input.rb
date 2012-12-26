class HtmlEditorInput < Formtastic::Inputs::TextInput
  def toolbar
    <<-HTML
    <div id="#{input_html_options[:id]}-toolbar" class="active_admin_editor_toolbar">
      <ul>
        <li><a data-wysihtml5-action="change_view">Source</a></li>
        <li><a data-wysihtml5-command="bold" title="Bold">Bold</a></li>
        <li><a data-wysihtml5-command="italic" title="Italic">Italic</a></li>
        <li><a data-wysihtml5-command="createLink" title="Link">Link</a></li>
        <li><a data-wysihtml5-command="insertImage" class="insertImage" title="Image">Image</a></li>
        <li><a data-wysihtml5-command="insertUnorderedList" title="Unordered list">Bulleted List</a></li>
        <li><a data-wysihtml5-command="insertOrderedList" title="Ordered list">Numbered List</a></li>
        <li><a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h1">h1</a></li>
        <li><a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2">h2</a></li>
        <li><a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h3">h3</a></li>
      </ul>

      <div data-wysihtml5-dialog="createLink" style="display: none">
        <label>
          Link:
          <input data-wysihtml5-dialog-field="href" value="http://">
        </label>
      </div>
      
    </div>
    HTML
  end

  def to_html
    html = '<div class="active_admin_editor">'
    html << toolbar.html_safe
    html << builder.text_area(method, input_html_options)
    html << '</div>'
    html << '<div style="clear: both"></div>'
    input_wrapping do
      label_html << html.html_safe
    end
  end
end
