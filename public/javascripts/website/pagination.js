// -- Pagination --
$(function() { // Shortcut for DOM.ready
  $(".pagination").each(function(){
    var node_count = $(this).children().length - 2;
    var pagination = $("<div class='modified_pagination'></div>");
    pagination.css({width: (node_count * 40)});
    $(this).children().each(function(){
      var this_id = $(this).text();
      // alert(this_id);
      if($(this).hasClass("gap")) {this_id = "ellipsis";}
      if($(this).hasClass("prev_page") || $(this).hasClass("next_page")) {
        return;
      } else {
        $(this).addClass("pagination_number_" + this_id);
        pagination.append(this);
      }
    });
    $(this).append(pagination);
  });
});
// --