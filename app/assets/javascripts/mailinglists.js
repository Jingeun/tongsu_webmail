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
