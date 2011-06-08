var item_controller = new ItemController({
  url: "/items/",
  onNextPage: function() {
    append_page_to($("#items"), item_controller.page());
    toggle_pagination_for($("#item_pages"), item_controller);
  },
  onPreviousPage: function() {
    toggle_pagination_for($("#item_pages"), item_controller);
  }
});

function append_page_to(element, page) {
  var page_count = $(element).find(".page").length;
  $(element).append($("<div class='page' id='" + $(element).attr("id") + "_page_" + (page_count + 1) +"'>" + page + "</div>"));
}

function setup_pagination_for(element, controller) {
  $(element)
    .append($("<div class='prev_button'>previous page</div>"))
    .find(".prev_button")
      .click(function(){controller.previous_page();});
  $(element)
    .append($("<div class='next_button'>next page</div>"))
    .find(".next_button")
      .click(function(){controller.next_page();});
}

function toggle_pagination_for(element, controller) {
  var prev_button = $(element).find(".prev_button");
  var next_button = $(element).find(".next_button");
  // -- toggle prev_button --
  if(controller.prev_available) {
    prev_button.show();
    prev_button.addClass("visible");
  } else if(!controller.prev_available && prev_button.hasClass("visible")) {
    prev_button.hide();
    prev_button.removeClass("visible");
  } else {
    prev_button.hide();
    prev_button.removeClass("visible");
  }
  // -- toggle next_button --
  if(controller.next_available) {
    next_button.show();
    next_button.addClass("visible");
  } else if(!controller.next_available && next_button.hasClass("visible")) {
    next_button.hide();
    next_button.removeClass("visible");
  } else {
    next_button.hide();
    next_button.removeClass("visible");
  }
}
/*
function append_items() {
  $("#items").append(item_controller.page());
  $(".item").each(function(){
    $(this).find(".name").truncate(20);
  });
  $("#items")
    .append($("<div class='prev_button'>previous</div>"))
    .find(".prev_button")
      .click(function(){item_controller.previous_page();});
  $("#items")
    .append($("<div class='next_button'>next</div>"))
    .find(".next_button")
      .click(function(){item_controller.next_page();});
  
  // if(item_controller.prev_available) { alert("previous!"); }
  // if(item_controller.next_available) { alert("next!"); }

}
*/