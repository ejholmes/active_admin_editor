# Active Admin Editor
[![Build Status](https://travis-ci.org/ejholmes/active_admin_editor.png?branch=master)](https://travis-ci.org/ejholmes/active_admin_editor) [![Code Climate](https://codeclimate.com/github/ejholmes/active_admin_editor.png)](https://codeclimate.com/github/ejholmes/active_admin_editor)

This is a wysiwyg html editor for the [Active Admin](http://activeadmin.info/)
interface using [wysihtml5](https://github.com/xing/wysihtml5).

![screenshot](https://dl.dropbox.com/u/1906634/Captured/OhvTv.png)

[Demo](http://active-admin-editor-demo.herokuapp.com/admin/pages/new)

## Installation

Add the following to your `Gemfile`:

```ruby
gem 'active_admin_editor'
```

And include the wysiwyg styles in your `application.css`:

```scss
//= require active_admin/editor/wysiwyg
```

Then run the following to install the default intializer:

```bash
$ rails g active_admin:editor
```

## Usage

This gem provides you with a custom formtastic input called `:html_editor` to build out a wysihtml5 enabled input.
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

## Uploads

The editor supports uploading of assets directly to an S3 bucket. Edit the initializer that
was installed when you ran `rails g active_admin:editor`.

```ruby
ActiveAdmin::Editor.configure do |config|
  config.s3_bucket = '<your bucket>'
  config.aws_access_key_id = '<your aws access key>'
  config.aws_access_secret = '<your aws secret>'
  # config.storage_dir = 'uploads'
end
```

Then add the following CORS configuration to the S3 bucket:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>PUT</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>HEAD</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <ExposeHeader>Location</ExposeHeader>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

## Configuration

You can configure the editor in the initializer installed with `rails g
active_admin:editor` or you can configure the editor during
`ActiveAdmin.setup`:

```ruby
ActiveAdmin.setup do |config|
  # ...
  config.editor.aws_access_key_id = '<your aws access key>'
  config.editor.s3_bucket = 'bucket'
end
```

## Parser Rules

[Parser rules](https://github.com/xing/wysihtml5/tree/master/parser_rules) can
be configured through the initializer:

```ruby
ActiveAdmin::Editor.configure do |config|
  config.parser_rules['tags']['strike'] = {
    'remove' => 0
  }
end
```

Be sure to clear your rails cache after changing the config:

```bash
rm -rf tmp/cache
```

## Heroku

Since some of the javascript files need to be compiled with access to the env
vars, it's recommended that you add the [user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile)
labs feature to your app.

1. Tell your rails app to run initializers on asset compilation

   ```ruby
   # config/environments/production.rb
   config.initialize_on_precompile = true
   ```
2. Add the labs feature

   ```bash
   heroku labs:enable user-env-compile -a myapp
   ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Tests

Run RSpec tests with `bundle exec rake`. Run JavaScript specs with `bundle
exec rake konacha:serve`.
