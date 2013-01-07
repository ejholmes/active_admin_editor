//= require wysihtml5
//= require active_admin/editor/config
//= require active_admin/editor/editor
//= require active_admin/editor/parser_rules

;(function(window, $) {
  $(function() { $('.html_editor').editor(window.AA.editor_config) })
})(window, jQuery)
