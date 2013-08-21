//= require wysihtml5
//= require active_admin/editor/config
//= require active_admin/editor/editor
//= require active_admin/editor/jquery.wysihtml5_size_matters.js

;(function(window, $) {
  $(function() { 
    $('.html_editor').editor(window.AA.editor_config);
    $('iframe.wysihtml5-sandbox').wysihtml5_size_matters();
  });
})(window, jQuery);
