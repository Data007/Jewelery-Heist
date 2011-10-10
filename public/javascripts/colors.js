function set_colors() {
  var colors = []
  $(".color.selected").each(function(){
    if(!colors.includes(this)) { colors.push($(this).attr("color_id")); }
  });
  $("#variation_colors_csv").val(colors.join(","));
}

function get_colors() {
  var colors           = [];
  var variation_colors = $("#variation_colors_csv").val();

  if(variation_colors != undefined) {
    $(variation_colors.split(",")).each(function(){
      if(!colors.includes(this)) { colors.push(this); }
    });
  }

  return colors;
}

function reset_colors() {
  var colors = get_colors();
  $(colors).each(function(){
    $(".position_" + this).addClass("selected")
  });
}

function setup_colors() {
  reset_colors();
  $(".color").click(function(){
    var color = $(this);
    if(color.hasClass("selected")) {
      color.removeClass("selected");
    } else {
      color.addClass("selected");
    }
    set_colors();
  });
}

load_functions.push("setup_colors");
