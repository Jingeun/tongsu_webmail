jQuery(function() {
  if ($('#infinite-scrolling').size() > 0) {
    $(window).bindWithDelay('scroll', function() {
      return $(window).on('scroll', function() {
        var more_posts_url;
        more_posts_url = $('#infinite-scrolling a.next_page').attr('href');
        if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 600) {
          $('.pagination').html('<img src="/assets/lightbox/loading.gif" alt="Loading..." title="Loading..."/>');
          $.getScript(more_posts_url, function() {});
        }
      });
    }, 10);
  }
});