//= require active_admin/editor/wysihtml5.min
//= require active_admin/editor/wysihtml5/parser_rules

(function($) {
    $(function(){
        var active_admin_editor = $('[active-admin-editor=true]')
        var id = active_admin_editor.attr('id');

        var toolbar = active_admin_editor.parent().find('.active_admin_editor_toolbar');
        var toolbar_id = toolbar.attr('id');

        var editor = new wysihtml5.Editor(id, {
            toolbar: toolbar_id,
            parserRules: wysihtml5ParserRules
        });

        window.editor = editor;
    });
})(jQuery);
