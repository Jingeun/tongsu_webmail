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

function textedit11(message_id, id) {
    $('#wysiwyg' + message_id).attr('rows', '15');
    $('#commet-body-' + message_id).append('<div class="btn-toolbar"><button type="button" class="btn btn-sm btn-default pull-right">Clear</button><button type="button" class="btn btn-sm btn-danger pull-right" onclick="create_comment(' + message_id +', \''+ id +'\')">Send</button></div>');
    $('#wysiwyg' + message_id).wysihtml5();
};

function textedit11cancel(message_id){

};

function create_comment(message_id, id) {
    var content = $('#wysiwyg' + message_id).val();

    if (content == "") {
        console.log("content is empty");
    }
    else {
        $.ajax({
            url: "/mailinglists/create_comments",
            type: "POST",
            data: {id: id, message_id: message_id, content: content},
            success: function(data) {
            },
            error: function(data){
            }
        });   
    }
};


function add_like(channel, id) {
    $.ajax({
        url: "/mailinglists/likes",
        type: "POST",
        data: {id: id, channel: channel},
        success: function(data) {
        },
        error: function(data){
        }
    });
}