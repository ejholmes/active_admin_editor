(($) ->
  $.fn.active_admin_editor = (options) ->
    active_admin_editor = $(this)

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

      # Clears and hides the asset container
      clear_assets = ->
        active_admin_editor.find('#asset_uploader').hide()
        image_dialog.find('.assets_container').html('').hide()
        image_dialog.find('.asset_scale_selection').hide()

      # Will re-load and re-render the assets
      load_assets = (done=null) ->
        container    = image_dialog.find('.assets_container')
        save_button  = image_dialog.find('a[data-wysihtml5-dialog-action="save"]')

        # Helper method for setting an input field within the dialog
        setDialogInput = (field, val) ->
          f = image_dialog.find("[data-wysihtml5-dialog-field='#{field}']")
          f.val(val)

        active_admin_editor.find('#asset_uploader').show()
        $.getJSON '/admin/image_assets.json', (data) ->
          list = $('<ul class="page_content"></ul>')

          $.each data, (i, asset) ->
            tag = $("""
            <li class="asset">
              <img data-image-width="#{asset.dimensions.width}"
                data-image-height="#{asset.dimensions.height}"
                title="#{asset.dimensions.width}px x #{asset.dimensions.height}px"
                src="#{asset.storage.thumb.url}" />
            </li>
            """)
            tag.find('img').data('image-src', asset.storage)
            list.append(tag)

          container.append(list).show()
          container.append($('<div class="page_navigation"></div>'))
          container.paginate
            items_per_page: 10
            show_first: false
            show_last: false

          image_dialog.find('.asset_scale_selection').show()

          selectedScale = ->
            image_dialog.find('input[name="asset_scale"]:checked').data('scale')

          populateSrc = (el) ->
            scale = selectedScale()
            container.find('.asset').removeClass('active')
            if scale == 'full'
              src = $(el).data('image-src').url
            else
              src = $(el).data('image-src')[scale].url
            if !src.match(/^(http|https)/gi)
              src = el.src.match(/(http|https):\/\/[^/]*/gi) + src
            setDialogInput 'src', src
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
        done() if done

      # HTML 5 Uploading
      uploader = new qq.FileUploader
        element: document.getElementById('asset_uploader'),
        action: '/admin/image_assets.json'
        onComplete: ->
          clear_assets()
          load_assets()

      editor.on 'show:dialog', (dialog) ->
        image_input = image_dialog.find('input[data-wysihtml5-dialog-field="src"]')
        if dialog.command == 'insertImage'
          clear_assets()
          load_assets() if image_input.val() == 'http://'

  $ ->
    $('.active_admin_editor').each(->$(@).active_admin_editor())
)(jQuery)
