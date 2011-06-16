$(function() {
  $(".comments").each(function() {
    var container = $(this);
    $.get("/" +
          $(this).attr('data-commentable-type') +
          "/" +
          $(this).attr('data-commentable-id') +
          "/comments", function(response) {
            $(container).html(response);
          });
  });

  $(".cancel-new-comment").live("click", function(event) {
    event.preventDefault();
    $(this).parents("#new_comment").remove();
  });
});
