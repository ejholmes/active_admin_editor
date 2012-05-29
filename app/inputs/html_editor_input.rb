class HtmlEditorInput < Formtastic::Inputs::TextInput
  def toolbar
    <<-HTML
    <div id="#{input_html_options[:id]}-toolbar" class="active_admin_editor_toolbar">
      
      <a data-wysihtml5-action="change_view"><span>Source</span></a>
      <a data-wysihtml5-command="bold" title="Bold"><span>Bold</span></a>
      <a data-wysihtml5-command="italic" title="Italic"><span>Italic</span></a>
      <a data-wysihtml5-command="createLink" title="Link"><span>Link</span></a>
      <a data-wysihtml5-command="insertImage" class="insertImage" title="Image"><span>Image</span></a>
      <a data-wysihtml5-command="insertUnorderedList" title="Unordered list"><span>Bulleted List</span></a>
      <a data-wysihtml5-command="insertOrderedList" title="Ordered list"><span>Numbered List</span></a>
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h1">h1</a>
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2">h2</a>
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h3">h3</a>
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
          <input data-wysihtml5-dialog-field="src" value="http://" />
        </label>
        <div id="asset_uploader">
          <noscript>
            <a href="/admin/image_assets/new">Upload &raquo;</a>
          </noscript>
        </div>
        <div class="assets_container">
        </div>
        <div class="asset_scale_selection">
          <label>Scale:</label>
          <label>
            100%
            <input data-scale="full" type="radio" name="asset_scale" checked="checked" />
          </label>
          <label>
            75%
            <input data-scale="three_quarters" type="radio" name="asset_scale" />
          </label>
          <label>
            50%
            <input data-scale="half" type="radio" name="asset_scale" />
          </label>
          <label>
            25%
            <input data-scale="one_quarter" type="radio" name="asset_scale" />
          </label>
        </div>
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
      quicksave: false
    }.merge(super)
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
