//= require jquery
//= require wysihtml5
//= require active_admin/editor/config
//= require active_admin/editor/parser_rules

(function(window, document, $, wysihtml5) {
  window.AA = (window.AA || {})
  window.AA.editors = []

  var Editor = function(el) {
    this.$el = $(el)
    this.$textarea = this.$el.find('textarea')
    this.$toolbar = this.$el.find('.active_admin_editor_toolbar')
    this.editor = new wysihtml5.Editor(this.$textarea.attr('id'), {
      toolbar: this.$toolbar.attr('id'),
      stylesheets: window.AA.editor.stylesheets,
      parserRules: window.AA.editor.parserRules
    })
  }

  $(function() {
    $('.active_admin_editor').each(function() {
      window.AA.editors.push(new Editor(this))
    })
  })

  window.Editor = Editor
})(window, document, jQuery, wysihtml5)
