//= require active_admin/editor/wysihtml5.min
//= require active_admin/editor/wysihtml5/parser_rules
//= require active_admin/editor/quicksave

(function($) {
    $(function(){
        var active_admin_editor, textarea_id, toolbar_id;
        active_admin_editor = $('.active_admin_editor');

        if (active_admin_editor.length > 0) {
            textarea_id         = active_admin_editor.find('textarea').attr('id');
            toolbar_id          = active_admin_editor.find('.active_admin_editor_toolbar').attr('id');

            var editor = new wysihtml5.Editor(textarea_id, {
                toolbar: toolbar_id,
                stylesheets: "/assets/wysiwyg.css",
                parserRules: wysihtml5ParserRules
            });

            window.editor = editor;
        }
    });
})(jQuery);
