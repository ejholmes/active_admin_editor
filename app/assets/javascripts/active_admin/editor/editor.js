(function(window, document, wysihtml5) {
  var config = null

  var Editor = function(el, cfg) {
    config          = cfg
    _this           = this
    this.$el        = $(el)
    this.$textarea  = this.$el.find('textarea')
    this.$toolbar   = this.$el.find('.toolbar')
    this.$file      = this.$el.find('input:file')
    this.$image_url = this.$el.find('#image_url')

    this.policy     = this.$el.data('policy-document')
    this.signature  = this.$el.data('policy-signature')

    this.$file.on('change', function() {
      _this.$image_url.val('')
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
    this._uploading = uploading
    this.$el.toggleClass('uploading', this._uploading)
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
    fd.append('policy', this.policy)
    fd.append('signature', this.signature)
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
    xhr.send(fd)

    return xhr
  }

  window.Editor = Editor
})(window, document, wysihtml5)
