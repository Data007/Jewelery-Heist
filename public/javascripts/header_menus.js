function hide_all_dropdowns()
{
  $(".dropdown_menu").addClass("inactive").removeClass("active");
  $(".menu_item").removeClass("active");
}

function add_general_handlers()
{ 
  $("#body").hover(
    function(){hide_all_dropdowns();},
    function(){}
  );
  
  $("#body").click(function(){hide_all_dropdowns();});
  $("body").click(function(){hide_all_dropdowns();});
}

function build_dropdown_menus()
{
  var parents = $(".menu_item");
  var children = $(".dropdown_menu");
  
  hide_all_dropdowns();
  add_general_handlers();
  
  $(parents).each(
    function()
    {
      var parent = $(this);
      var child = String("#" + $(this).attr("id") + "_dropdown_child");
      
      $(parent).hover(
        function()
        {
          hide_all_dropdowns();
          $(child).removeClass("inactive").addClass("active");
          $(parent).addClass("active");
        },
        function(){}
      );
    }
  );
}

load_functions.push("build_dropdown_menus");