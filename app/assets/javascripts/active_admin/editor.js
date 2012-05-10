//= require active_admin/editor/wysihtml5.min
//= require active_admin/editor/wysihtml5/parser_rules
//= require active_admin/editor/quicksave

(function($) {
    $.fn.active_admin_editor = function(options) {
        return this.each(function() {
            var active_admin_editor, textarea_id, toolbar_id;
            active_admin_editor = $(this);

            /* Setup the editor */
            if (active_admin_editor.length > 0) {
                textarea_id         = active_admin_editor.find('textarea').attr('id');
                toolbar_id          = active_admin_editor.find('.active_admin_editor_toolbar').attr('id');

                var editor = new wysihtml5.Editor(textarea_id, {
                    toolbar: toolbar_id,
                    stylesheets: "/assets/wysiwyg.css",
                    parserRules: wysihtml5ParserRules
                });

                editor.on('show:dialog', function(dialog) {
                    if (dialog.command == 'insertImage') {
                        container = active_admin_editor.find('.assets_container').html('').hide();
                        image_input = active_admin_editor.find('[data-wysihtml5-dialog="insertImage"] input[data-wysihtml5-dialog-field="src"]');

                        if (image_input.val() == 'http://') {
                            $.getJSON("/admin/assets.json", function(data) {
                                container.append($('<a class="upload" href="/admin/assets/new">Upload &raquo;</a>'));
                                $.each(data, function(i, asset) {
                                    container.append($('<div class="asset"><img data-image-src="' + asset.storage.url + '" src="' + asset.storage.thumb.url + '" /></div>'));
                                });
                                container.show();

                                var populateSrc = function(el) {
                                    container.find('.asset').removeClass('active');
                                    var domain = el.src.match(/http:\/\/[^/]*/gi);
                                    image_input.val(domain + $(el).data('image-src'));
                                    $(el).parent().addClass('active');
                                }

                                container.find('img').
                                    click(function(e) {
                                        populateSrc(this);
                                    });
                            });
                        }
                    }
                });

                window.editor = editor;
            }
        });
    };

    $(function(){
        $('.active_admin_editor').active_admin_editor();
    });
})(jQuery);
