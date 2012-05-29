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

      # HTML 5 Uploading
      uploader = new qq.FileUploader
        element: document.getElementById('asset_uploader'),
        action: '/admin/image_assets.json'
        onComplete: ->
          load_assets image_dialog

      # Will re-load and re-render the assets
      load_assets = (root) ->
        active_admin_editor.find('#asset_uploader').hide()
        container    = root.find('.assets_container').html('').hide()
        save_button  = root.find('a[data-wysihtml5-dialog-action="save"]')
        image_input  = root.find('input[data-wysihtml5-dialog-field="src"]')

        root.find('.asset_scale_selection').hide()

        setDialogInput = (field, val) ->
          f = root.find("[data-wysihtml5-dialog-field='#{field}']")
          f.val(val)

        if image_input.val() == 'http://'
          active_admin_editor.find('#asset_uploader').show()
          $.getJSON '/admin/image_assets.json', (data) ->

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
            root.find('.asset_scale_selection').show()

            selectedScale = ->
              root.find('input[@name="asset_scale"]:checked').data('scale')

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

            root.find('input[name="asset_scale"]').click (e) ->
              populateSrc(root.find('.asset.active img')[0])

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


      editor.on 'show:dialog', (dialog) ->
        load_assets image_dialog if dialog.command == 'insertImage'

  $ ->
    $('.active_admin_editor').active_admin_editor()
)(jQuery)
