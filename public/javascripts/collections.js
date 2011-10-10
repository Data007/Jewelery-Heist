function set_collections() {
  var collections = []
  $(".collection.selected").each(function(){
    if(!collections.includes(this)) { collections.push($(this).attr("collection_id")); }
  });
  $("#item_collections_csv").val(collections.join(","));
}

function get_collections() {
  var collections      = [];
  var item_collections = $("#item_collections_csv").val();

  if(item_collections != undefined) {
    $(item_collections.split(",")).each(function(){
      if(!collections.includes(this)) { collections.push(this); }
    });
  }

  return collections;
}

function reset_collections() {
  var collections = get_collections();
  $(collections).each(function(){
    $(".collection_" + this).addClass("selected")
  });
}

function setup_collections() {
  reset_collections();
  $(".collection").click(function(){
    var collection = $(this);
    if(collection.hasClass("selected")) {
      collection.removeClass("selected");
    } else {
      collection.addClass("selected");
    }
    set_collections();
  });
}

load_functions.push("setup_collections");
