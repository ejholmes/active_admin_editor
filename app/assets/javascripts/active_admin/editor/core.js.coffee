(($) ->
  $.fn.active_admin_editor = (options) ->
    active_admin_editor = $(this)
    console.log active_admin_editor

    if active_admin_editor.length > 0
      textarea_id = active_admin_editor.find('textarea').attr('id')
      toolbar_id  = active_admin_editor.find('.active_admin_editor_toolbar').attr('id')

      editor = new wysihtml5.Editor(textarea_id, {
        toolbar: toolbar_id,
        stylesheets: "/assets/wysiwyg.css",
        parserRules: wysihtml5ParserRules
      })

      window.editor = editor

      image_dialog = active_admin_editor.find('[data-wysihtml5-dialog="insertImage"]')

      editor.on 'show:dialog', (dialog) ->
        if dialog.command == 'insertImage'
          container    = image_dialog.find('.assets_container').html('').hide()
          save_button  = image_dialog.find('a[data-wysihtml5-dialog-action="save"]')
          image_input  = image_dialog.find('input[data-wysihtml5-dialog-field="src"]')

          image_dialog.find('.asset_scale_selection').hide()

          setDialogInput = (field, val) ->
            f = image_dialog.find("[data-wysihtml5-dialog-field='#{field}']")
            f.val(val)

          if image_input.val() == 'http://'
            $.getJSON '/admin/image_assets.json', (data) ->
              container.append($('<a class="upload" href="/admin/image_assets/new">Upload &raquo;</a>'))

              $.each data, (i, asset) ->
                tag = $("""
                <div class="asset">
                  <img data-image-width="#{asset.dimensions.width}"
                    data-image-height="#{asset.dimensions.height}"
                    title="#{asset.dimensions.width}px x #{asset.dimensions.height}px"
                    src="#{asset.storage.thumb.url}" />
                </div>
                """)
                tag.find('img').data('image-src', asset.storage)
                container.append(tag)

              container.show()
              image_dialog.find('.asset_scale_selection').show()

              selectedScale = ->
                image_dialog.find('input[@name="asset_scale"]:checked').data('scale')

              populateSrc = (el) ->
                scale = selectedScale()
                container.find('.asset').removeClass('active')
                domain = el.src.match(/http:\/\/[^/]*/gi)
                if scale == 'full'
                  setDialogInput 'src', domain + $(el).data('image-src').url
                else
                  setDialogInput 'src', domain + $(el).data('image-src')[scale].url
                $(el).parent().addClass('active')

              image_dialog.find('input[name="asset_scale"]').click (e) ->
                populateSrc(image_dialog.find('.asset.active img')[0])

              container.find('img').
                click((e) ->
                  populateSrc(this)
                ).
                dblclick((e) ->
                  fireEvent = (element, event) ->
                    if (document.createEvent)
                      # dispatch for firefox + others
                      evt = document.createEvent("HTMLEvents")
                      evt.initEvent(event, true, true ); # event type,bubbling,cancelable
                      return !element.dispatchEvent(evt)
                    else
                      # dispatch for IE
                      evt = document.createEventObject()
                      return element.fireEvent('on'+event, evt)

                  fireEvent save_button[0], 'click'
                )

  $ ->
    $('.active_admin_editor').active_admin_editor()
)(jQuery)
