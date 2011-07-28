var scrollTopIntervalID;

function setup_scrollTop(){
  $(".images .minor_images.wrapper-pane").pans({orientation:"vertical"});
  $(".images .content.wrapper-pane").pans({orientation:"vertical"});
  setInterval(function(){clearInterval(scrollTopIntervalID);}, 100000);
}

function start_scrollTop_interval(){
  scrollTopIntervalID = setInterval("setup_scrollTop()", 10);
}

function setup_scrolling(){
  $(".variations.wrapper-pane").pans();
  $(".items.wrapper-pane").pans();
  start_scrollTop_interval();
}

load_functions.push("setup_scrolling");

function setup_add_to_cart(){
  $(".add_to_cart").each(function(){
    var link = $(this);
    var url = link.attr('href') + "&item_size=" + $(this).parents().find("#item_sizes:first").val();
    link.attr('href', url);
  });
}

function setup_item_sizes(){
  setup_add_to_cart();
  $("#item_sizes:first").change(function(){setup_add_to_cart();});
}

load_functions.push("setup_item_sizes");

function setup_image_change(){
  $(".minor_image").each(function(){
    var asset = $(this);
    asset.click(function(){
      // alert($("#major_image img:first").attr('src'));
      $("#major_image img:first").attr('src', asset.attr('src'));
    });
  });
}

load_functions.push("setup_image_change");
