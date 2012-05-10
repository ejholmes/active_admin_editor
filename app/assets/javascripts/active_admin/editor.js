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

        $('.active_admin_editor_toolbar a.insertImage').click(function(e) {
            container = $(this).closest('.active_admin_editor_toolbar').find('.assets_container');
            $.getJSON("/admin/assets.json", function(data) {
                container.html('').hide;
                $.each(data, function(i, asset) {
                    container.append($('<div class="asset"><img src=' + asset.storage.thumb.url + ' /></div>'));
                });
                container.show();

                var populateSrc = function(el) {
                    container.find('.asset').removeClass('active');
                    input = $(el).closest('.active_admin_editor_toolbar').
                        find('[data-wysihtml5-dialog="insertImage"]').
                        find('input[data-wysihtml5-dialog-field="src"]');
                    input.val(el.src);
                    $(el).parent().addClass('active');
                }

                container.find('img').
                    click(function(e) {
                        populateSrc(this);
                    }).
                    dblclick(function(e) {
                        populateSrc(this);
                        // $(this).closest('.active_admin_editor_toolbar').
                            // find('[data-wysihtml5-dialog="insertImage"] a[data-wysihtml5-dialog-action="save"]').
                            // click();
                    });
            });
        });
    });
})(jQuery);
