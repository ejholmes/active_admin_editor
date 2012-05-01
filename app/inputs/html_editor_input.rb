class HtmlEditorInput < Formtastic::Inputs::TextInput
  def toolbar
    <<-HTML
    <div id="#{input_html_options[:id]}-toolbar" class="active_admin_editor_toolbar">
      <a data-wysihtml5-action="change_view">Source</a>
      #{%Q{<a data-wysihtml5-command="bold" title="Bold"></a>} if input_html_options[:commands][:bold]}
      #{%Q{<a data-wysihtml5-command="italic" title="Italic"></a>} if input_html_options[:commands][:italic]}
      #{%Q{<a data-wysihtml5-command="createLink" title="Link"></a>} if input_html_options[:commands][:link]}
      #{%Q{<a data-wysihtml5-command="insertImage" title="Image"></a>} if input_html_options[:commands][:image]}
      #{%Q{<a data-wysihtml5-command="insertUnorderedList" title="Unordered list"></a>} if input_html_options[:commands][:ul]}
      #{%Q{<a data-wysihtml5-command="insertOrderedList" title="Ordered list"></a>} if input_html_options[:commands][:li]}
      <div class="separator"></div>
      #{%Q{<a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h1">h1</a>} if input_html_options[:commands][:h1]}
      #{%Q{<a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2">h2</a>} if input_html_options[:commands][:h2]}
      #{%Q{<a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h3">h3</a>} if input_html_options[:commands][:h3]}
      #{%Q{<a class="button quicksave" href="#">Save</a>} if input_html_options[:quicksave]}

      <div data-wysihtml5-dialog="createLink" style="display: none">
        <label>
          Link:
          <input data-wysihtml5-dialog-field="href" value="http://">
        </label>
        <div class="action-group">
          <a data-wysihtml5-dialog-action="save" class="button">OK</a>
          <a data-wysihtml5-dialog-action="cancel">Cancel</a>
        </div>
      </div>
      
      <div data-wysihtml5-dialog="insertImage" style="display: none">
        <label>
          Image:
          <input data-wysihtml5-dialog-field="src" value="http://">
        </label>
        <label>
          Align:
          <select data-wysihtml5-dialog-field="className">
            <option value="">default</option>
            <option value="wysiwyg-float-left">left</option>
            <option value="wysiwyg-float-right">right</option>
          </select>
        </label>
        <div class="action-group">
          <a data-wysihtml5-dialog-action="save" class="button">OK</a>
          <a data-wysihtml5-dialog-action="cancel">Cancel</a>
        </div>
      </div>
      
    </div>
    HTML
  end

  def input_html_options
    {
      quicksave: false,
      commands: {
        bold: true,
        italic: true,
        link: true,
        image: true,
        ul: true,
        li: true,

        h1: true,
        h2: true,
        h3: true
      }
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
