(function($) {
    $(function(){
        var button = $('.button.quicksave');
        button.click(function(e) {
            e.preventDefault();

            $.ajaxSetup({
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
                }
            });

            var form = $(this).closest('form');
            var url = form.attr('action');
            var textarea = $(this).closest('.active_admin_editor').find('textarea');
            var fields = textarea.attr('id').split('_');
            var content = textarea.val();
            var data = {
                _method: 'PUT'
            };

            data[fields[0]] = {};
            data[fields[0]][fields[1]] = content;

            $.ajax({
                url: url,
                type: 'POST',
                dataType: 'json',
                data: data,
                success: function(response) {
                    console.log('saved');
                }
            });
        });
    });
})(jQuery);
