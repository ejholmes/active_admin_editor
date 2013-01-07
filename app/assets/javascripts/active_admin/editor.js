//= require wysihtml5
//= require active_admin/editor/config
//= require active_admin/editor/editor
//= require active_admin/editor/parser_rules

(function(window, document, $) {
  window.AA.editors = []

  $(function() {
    $('.html_editor').each(function() {
      window.AA.editors.push(new window.AA.Editor(this, window.AA.editor_config))
    })
  })
})(window, document, jQuery)
