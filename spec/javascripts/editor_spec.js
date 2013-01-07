//= require spec_helper
//= require support/mock_wysihtml5
//= require active_admin/editor/editor

describe('Editor', function() {
  beforeEach(function() {
    this.xhr = sinon.useFakeXMLHttpRequest()
    $('body').append(JST['templates/editor']())
    this.config = sinon.stub()
    this.editor = new window.AA.Editor(this.config, $('.html_editor'))
  })

  afterEach(function() {
    this.xhr.restore()
  })

  it('sets .$el', function() {
    expect(this.editor.$el).to.exist
  })

  it('sets .$textarea', function() {
    expect(this.editor.$textarea).to.exist
  })

  it('sets .$toolbar', function() {
    expect(this.editor.$toolbar).to.exist
  })

  it('sets .policy', function() {
    expect(this.editor.policy.document).to.eq('policy document')
  })

  it('sets .signature', function() {
    expect(this.editor.policy.signature).to.eq('policy signature')
  })

  it('attaches wysihtml5', function() {
    expect(wysihtml5.Editor).to.have.been.calledWith('page_content')
  })

  describe('.editor', function() {
    it('returns the wysihtml5 editor', function() {
      expect(this.editor.editor()).to.eq(this.editor._editor)
    })
  })

  describe('._uploading', function() {
    describe('when set to true', function() {
      beforeEach(function() {
        this.uploading = this.editor._uploading(true)
      })

      it('returns true', function() {
        expect(this.uploading).to.be.true
      })

      it('sets ._uploading', function() {
        expect(this.editor.__uploading).to.be.true
      })

      it('adds the .uploading class', function() {
        expect(this.editor.$el).to.have.class('uploading')
      })
    })

    describe('when set to false', function() {
      beforeEach(function() {
        this.uploading = this.editor._uploading(false)
      })

      it('returns false', function() {
        expect(this.uploading).to.be.false
      })

      it('sets ._uploading', function() {
        expect(this.editor.__uploading).to.be.false
      })

      it('adds the .uploading class', function() {
        expect(this.editor.$el).to.not.have.class('uploading')
      })
    })
  })

  describe('.upload', function() {
    beforeEach(function() {
      this.xhr.prototype.upload = { addEventListener: sinon.stub() }
    })

    it('opens the connection to the proper bucket', function() {
      this.xhr.prototype.open = sinon.stub()
      this.xhr.prototype.send = sinon.stub()
      this.config.s3_bucket = 'bucket'
      xhr = this.editor.upload(sinon.stub(), function() {})
      expect(xhr.open).to.have.been.calledWith('POST', 'https://bucket.s3.amazonaws.com', true)
    })

    it('sends the request', function() {
      this.xhr.prototype.send = sinon.stub()
      xhr = this.editor.upload(sinon.stub(), function() {})
      expect(xhr.send).to.have.been.called
    })

    describe('when the upload succeeds', function() {
      it('calls the callback with the location', function(done) {
        this.xhr.prototype.open = sinon.stub()
        this.xhr.prototype.send = sinon.stub()
        this.config.s3_bucket = 'bucket'
        xhr = this.editor.upload(sinon.stub(), function(location) {
          expect(location).to.eq('foo')
          done()
        })
        xhr.getResponseHeader = sinon.stub().returns('foo')
        xhr.readyState = 4
        xhr.status = 204
        xhr.onreadystatechange()
      })
    })

    describe('when the upload fails', function() {
      it('shows an alert', function() {
        this.xhr.prototype.open = sinon.stub()
        this.xhr.prototype.send = sinon.stub()
        this.config.s3_bucket = 'bucket'
        alert = sinon.stub()
        xhr = this.editor.upload(sinon.stub(), function() {})
        xhr.readyState = 4
        xhr.status = 403
        xhr.onreadystatechange()
        expect(alert).to.have.been.calledWith('Failed to upload file. Have you configured S3 properly?')
      })
    })

    describe('form data', function() {
      beforeEach(function() {
        file = this.file = { name: 'foobar', type: 'image/jpg' }
        append = this.append = sinon.stub()
        FormData = function() { return { append: append } }

        Date.now = function() { return { toString: function() { return '1234' } } }

        this.xhr.prototype.open = sinon.stub()
        this.xhr.prototype.send = sinon.stub()

        this.config.s3_bucket         = 'bucket'
        this.config.storage_dir       = 'uploads'
        this.config.aws_access_key_id = 'access key'

        this.editor.upload(file, function() {})
      })

      it('sets "key"', function() {
        expect(this.append).to.have.been.calledWith('key', 'uploads/1234-foobar')
      })

      it('sets "AWSAccessKeyId"', function() {
        expect(this.append).to.have.been.calledWith('AWSAccessKeyId', 'access key')
      })

      it('sets "acl"', function() {
        expect(this.append).to.have.been.calledWith('acl', 'public-read')
      })

      it('sets "policy"', function() {
        expect(this.append).to.have.been.calledWith('policy', 'policy document')
      })

      it('sets "signature"', function() {
        expect(this.append).to.have.been.calledWith('signature', 'policy signature')
      })

      it('sets "Content-Type"', function() {
        expect(this.append).to.have.been.calledWith('Content-Type', 'image/jpg')
      })

      it('sets "file"', function() {
        expect(this.append).to.have.been.calledWith('file', this.file)
      })
    })
  })
})
