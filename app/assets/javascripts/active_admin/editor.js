//= require jquery
//= require wysihtml5
//= require active_admin/editor/config
//= require active_admin/editor/parser_rules

(function(window, document, $, wysihtml5) {
  window.AA = (window.AA || {})
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
      stylesheets: window.AA.editor.stylesheets,
      parserRules: window.AA.editor.parserRules
    })
  }

  Editor.prototype.upload = function(file, callback) {
    var xhr = new XMLHttpRequest()
      , fd = new FormData()
      , key = window.AA.editor.storage_dir + '/' + file.name

    fd.append('key', key)
    fd.append('AWSAccessKeyId', window.AA.editor.aws_access_key_id)
    fd.append('acl', 'public-read')
    fd.append('policy', window.AA.editor.policy_document)
    fd.append('signature', window.AA.editor.signature)
    fd.append('Content-Type', file.type)
    fd.append('file', file)

    xhr.upload.addEventListener('progress', function(e) {
      console.log((e.loaded / e.total) * 100)
    }, false)

    xhr.onreadystatechange = function() {
      if (xhr.readyState != 4) { return }
      callback(xhr.getResponseHeader('Location'))
    }

    xhr.open('POST', 'https://' + window.AA.editor.s3_bucket + '.s3.amazonaws.com', true)

    xhr.send(fd)

    return xhr
  }

  $(function() {
    $('.active_admin_editor').each(function() {
      window.AA.editors.push(new Editor(this))
    })
  })

  window.Editor = Editor
})(window, document, jQuery, wysihtml5)
