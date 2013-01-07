//= require_tree ./templates

;(function(window, wysihtml5) {
  window.AA = (window.AA || {})
  var config

  var Editor = function(options, el) {
    config          = options
    var _this       = this
    this.$el        = $(el)
    this.$textarea  = this.$el.find('textarea')
    this.policy     = this.$el.data('policy')

    this._addToolbar()
    this._attachEditor()
  }

  /**
   * Returns the wysihtml5 editor instance for this editor.
   */
  Editor.prototype.editor = function() {
    return this._editor
  }

  /**
   * Adds the wysihtml5 toolbar. If uploads are enabled, also adds the
   * necessary file inputs for uploading.
   */
  Editor.prototype._addToolbar = function() {
    var template = JST['active_admin/editor/templates/toolbar']({
      id: this.$el.attr('id') + '-toolbar'
    })

    this.$toolbar = $(template)

    if (config.uploads_enabled) {
      var _this = this
      this.$toolbar.find('input.uploadable').each(function() {
        _this._addUploader(this)
      })
    }

    this.$el.find('.wrap').prepend(this.$toolbar)
  }

  /**
   * Adds a file input attached to the supplied text input. And upload is
   * triggered if the source of the input is changed.
   *
   * @input Text input to attach a file input to. 
   */
  Editor.prototype._addUploader = function(input) {
    var $input = $(input)

    var template = JST['active_admin/editor/templates/uploader']({ spinner: config.spinner })
    var $uploader = $(template)

    var $dialog = $input.closest('[data-wysihtml5-dialog]')
    $dialog.append($uploader)

    var _this = this
    $uploader.find('input:file').on('change', function() {
      var file = this.files[0]
      if (file) {
        $input.val('')
        _this.upload(file, function(location) {
          $input.val(location)
        })
      }
    })
  }

  /**
   * Initializes the wysihtml5 editor for the textarea.
   */
  Editor.prototype._attachEditor = function() {
    this._editor = new wysihtml5.Editor(this.$textarea.attr('id'), {
      toolbar: this.$toolbar.attr('id'),
      stylesheets: config.stylesheets,
      parserRules: config.parserRules
    })
  }

  /**
   * Sets the internal uploading state to true or false. Adds the .uploading
   * class to the root element for stying.
   *
   * @uploading {Boolean} Whether or not something is being uploaded.
   */
  Editor.prototype._uploading = function(uploading) {
    this.__uploading = uploading
    this.$el.toggleClass('uploading', this.__uploading)
    return this.__uploading
  }

  /**
   * Uploads a file to S3. When the upload is complete, calls callback with the
   * location of the uploaded file.
   *
   * @file The file to upload
   * @callback A function to be called when the upload completes.
   */
  Editor.prototype.upload = function(file, callback) {
    var _this = this
    _this._uploading(true)

    var xhr = new XMLHttpRequest()
      , fd = new FormData()
      , key = config.storage_dir + '/' + Date.now().toString() + '-' + file.name

    fd.append('key', key)
    fd.append('AWSAccessKeyId', config.aws_access_key_id)
    fd.append('acl', 'public-read')
    fd.append('policy', this.policy.document)
    fd.append('signature', this.policy.signature)
    fd.append('Content-Type', file.type)
    fd.append('file', file)

    xhr.upload.addEventListener('progress', function(e) {
      _this.loaded   = e.loaded
      _this.total    = e.total
      _this.progress = e.loaded / e.total
    }, false)

    xhr.onreadystatechange = function() {
      if (xhr.readyState != 4) { return }
      _this._uploading(false)
      if (xhr.status == 204) {
        callback(xhr.getResponseHeader('Location'))
      } else {
        alert('Failed to upload file. Have you configured S3 properly?')
      }
    }

    xhr.open('POST', 'https://' + config.s3_bucket + '.s3.amazonaws.com', true)
    xhr.send(fd)

    return xhr
  }

  window.AA.Editor = Editor
})(window, wysihtml5)

;(function(window, $) {
  if ($.widget) {
    $.widget.bridge('editor', window.AA.Editor)
  }
})(window, jQuery)
