# Active Admin Editor

[![Build Status](https://travis-ci.org/ejholmes/active_admin_editor.png)](https://travis-ci.org/ejholmes/active_admin_editor)

This is a wysiyg html editor for the [Active Admin](http://activeadmin.info/)
interface using [wysihtml5](https://github.com/xing/wysihtml5).

![screenshot](https://dl.dropbox.com/u/1906634/Captured/6V2rZ.png)

## Installation

Add the following to your Gemfile:

```ruby
gem 'active_admin_editor'
```

Then run:

```bash
$ rails g active_admin:editor:install
```

## Image Uploads

The editor supports uploading of images direct to s3. Add the following to an
initializer:

```ruby
ActiveAdmin::Editor.configure do |config|
  config.s3_bucket = '<your bucket>'
  config.aws_access_key_id = '<your aws access key>'
  config.aws_access_secret = '<your aws secret>'
  # config.storage_dir = 'uploads'
end
```

## Usage

This gem provides you with a custom formtastic input called `:html_editor` to build out an html editor.
All you have to do is specify the `:as` option for your inputs.

**Example**

```ruby
ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :html_editor
    end

    f.buttons
  end
end
```

## Contributing

### Tests

Runy RSpec tests with `bundle exec rake`. Run JavaScript specs with `bundle
exec rake konacha:serve`.
