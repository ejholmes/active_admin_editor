//= require jquery
//= require wysihtml5
//= require active_admin/editor/config
//= require active_admin/editor/parser_rules

(function(window, document, $, wysihtml5, config) {
  window.AA.editors = []

  var Editor = function(el) {
    _this           = this
    this.$el        = $(el)
    this.$textarea  = this.$el.find('textarea')
    this.$toolbar   = this.$el.find('.active_admin_editor_toolbar')
    this.$file      = this.$el.find('input:file')
    this.$image_url = this.$el.find('#image_url')

    this.$file.on('change', function() {
      _this.upload(this.files[0], function(location) {
        _this.$image_url.val(location)
      })
    })

    this.attachEditor()
  }

  Editor.prototype.attachEditor = function() {
    this.editor = new wysihtml5.Editor(this.$textarea.attr('id'), {
      toolbar: this.$toolbar.attr('id'),
      stylesheets: config.stylesheets,
      parserRules: config.parserRules
    })
  }

  Editor.prototype.uploading = function(uploading) {
    if (uploading) {
      this._uploading = true
      this.$el.addClass('uploading')
    } else {
      this._uploading = false
      this.$el.removeClass('uploading')
    }

    return this._uploading
  }

  Editor.prototype.upload = function(file, callback) {
    _this = this
    _this.uploading(true)

    var xhr = new XMLHttpRequest()
      , fd = new FormData()
      , key = config.storage_dir + '/' + file.name

    fd.append('key', key)
    fd.append('AWSAccessKeyId', config.aws_access_key_id)
    fd.append('acl', 'public-read')
    fd.append('policy', config.policy_document)
    fd.append('signature', config.signature)
    fd.append('Content-Type', file.type)
    fd.append('file', file)

    xhr.upload.addEventListener('progress', function(e) {
      _this.loaded   = e.loaded
      _this.total    = e.total
      _this.progress = e.loaded / e.total
    }, false)

    xhr.onreadystatechange = function() {
      if (xhr.readyState != 4) { return }
      _this.uploading(false)
      callback(xhr.getResponseHeader('Location'))
    }

    xhr.open('POST', 'https://' + config.s3_bucket + '.s3.amazonaws.com', true)
    return xhr.send(fd)
  }

  $(function() {
    $('.active_admin_editor').each(function() {
      window.AA.editors.push(new Editor(this))
    })
  })

  window.Editor = Editor
})(window, document, jQuery, wysihtml5, window.AA.editor)
