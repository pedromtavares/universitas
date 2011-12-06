if (history && history.pushState) {
  $(function() {
    $(".history").live("click", function(e) {
      history.pushState(null, document.title, this.href);
      e.preventDefault();
    });
    $(".custom-history").live("click", function(e) {
      history.pushState(null, document.title, $(this).data('history'));
      e.preventDefault();
    });
    $(window).bind("popstate", function() {
      $.getScript(location.href);
    });
  });
}