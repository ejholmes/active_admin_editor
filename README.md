# Active Admin Editor

This is a wysiyg html editor for the [Active Admin](http://activeadmin.info/)
interface using [wysihtml5](https://github.com/xing/wysihtml5).

![screenshot](http://i.imgur.com/vfX1A.png)

## Installation

```ruby
# Gemfile

gem 'active_admin_editor'
```

Then add the following stylesheet to your application manifest:

```ruby
# app/assets/stylesheets/application.css
//= require active_admin/editor/wysiwyg
```

And the following to your active\_admin.css.scss and active\_admin.js:

```ruby
# app/assets/javascripts/active_admin.js
//= require active_admin/editor
```

```ruby
# app/assets/javascripts/active_admin.css.scss
@import 'active_admin/editor';
```

Now install the migrations:

```bash
$ rake active_admin_editor:install:migrations
$ rake db:migrate
```

And finally install the wysiwyg css file:

```bash
$ rails g active_admin:editor
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
