function setup_image_delete_links(){
  $(".image .actions .delete").click(function(event){
    $("#ajax-status").show();
    var image_container = $(this).parent().parent();
    console.log(image_container);
    $.ajax({
      type: "delete",
      dataType: "json",
      url: $(this).attr("href"),
      success: function(json){
        $(image_container).remove();
        $("#ajax-status").hide();
      }
    });
    return false;
  });
}

load_functions.push("setup_image_delete_links");
