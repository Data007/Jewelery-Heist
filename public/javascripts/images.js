function setup_image_delete_links(){
  $(".image .actions .delete").click(function(event){
    $("#ajax-status").show();
    var parent_image_id = ("#" + $(this).attr("parent_image_id"));
    $.ajax({
      type: "delete",
      dataType: "json",
      url: $(this).attr("href"),
      success: function(json){
        $(parent_image_id).remove();
        $("#ajax-status").hide();
      }
    });
    return false;
  });
}

load_functions.push("setup_image_delete_links");