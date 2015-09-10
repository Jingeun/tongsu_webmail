function see_more(id) {
    $.ajax({
        url: "/mailinglists/see_more",
        type: "POST",
        data: {id: id},
        success: function(data) {
        },
        error: function(data){
        }
    });
};

function get_comments(id) {
    $.ajax({
        url: "/mailinglists/get_comments",
        type: "POST",
        data: {id: id},
        success: function(data) {
        },
        error: function(data){
        }
    });
};

function textedit11(message_id) {
    $('#wysiwyg' + message_id).attr('rows', '15');
    $('#commet-body-' + message_id).append('<div class="btn-toolbar"><button type="button" class="btn btn-sm btn-default pull-right">Clear</button><button type="button" class="btn btn-sm btn-danger pull-right">Send</button></div>');
    $('#wysiwyg' + message_id).wysihtml5();
};

function textedit11cancel(message_id){

};
