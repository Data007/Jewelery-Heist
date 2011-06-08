function setup_image_delete_links(){
  $(".image .actions .delete").click(function(event){
    var parent_image_id = ("#" + $(this).attr("parent_image_id"));
    $.ajax({
      type: "delete",
      dataType: "json",
      url: $(this).attr("href"),
      success: function(json){
        $(parent_image_id).remove();
      }
    });
    return false;
  });
}

function setup_image_positioning() {
  $(".images").sortable({
    items: ".image",
    handle: "img",
    opacity: 0.9,
    tolerance: "pointer",
    update: function(event, ui) {
      var images = ui.item.parent().children(".image");
      var position = images.index(ui.item);
      $.ajax({
        method: "GET",
        url: ("/admin/molds/" + $("#mold_id").val() + "/attachments/update_positions/" + ui.item.find(".id").attr("id") + "?position=" + position)
      });
    }
  });
}

function setup_image_actions() {
  $(".image")
    .hover(
      function(){
        $(this).children(".actions").animate({top: "0px"});
      },
      function(){
        $(this).children(".actions").animate({top: "-25px"});
      }
    )
    .children(".actions").css({top: "-25px"});
  setup_image_delete_links();
  setup_image_positioning();
}

function setup_image_uploader() {
  $(".image_uploader").each(function(){
    var mold_id = $(this).parent().find("#mold_id").val();
    var attachment_url = "/admin/molds/" + mold_id + "/attachments"
    
    $(this).find("input[type='file']").after("<span class='button file_upload_button'>" + "<a href='" + attachment_url + "'>upload image</a></span>");
    $(this).find(".file_upload_button a").click(function(){
      var file_field_value = $(this).parent().parent().find(".original_file_field").val();
      if(file_field_value != undefined && file_field_value != "") {
        var file_form = document.createElement("form");
        file_form.setAttribute("id", "file_upload_form_for_mold_" + mold_id);
        
        $(this).parent().after(file_form);
        $("#file_upload_form_for_mold_" + mold_id)
          .attr("enctype", "multipart/form-data")
          .attr("action", attachment_url)
          .attr("method", "POST")
          .addClass("ajax_upload_form")
          .append(
            $(this).parent().parent().find(".original_file_field")
              .attr("name", "image")
          )
          .append($("form input[name='authenticity_token']").clone());
        $(this).parent().parent()
          .find("label").after(
          $("#file_upload_form_for_mold_" + mold_id)
            .find(".original_file_field")
              .clone()
          );
        $("#file_upload_form_for_mold_" + mold_id)
          .ajaxStart(function(){$("#ajax-status").show();})
          .ajaxForm({
            dataType: "json",
            success: function(json){
              var image = new EJS({url: "/ejs/molds/_image.ejs"}).render(json)
              $("#images_for_mold_" + mold_id).append(image);
              $("#file_upload_form_for_mold_" + mold_id).remove();
              setup_image_actions();
              $("#ajax-status").hide();
            }
          });
        $("#file_upload_form_for_mold_" + mold_id).submit();
        
      } else {
        $(this).parent().after(new EJS({url: "/ejs/molds/_message.ejs"}).render({class: "error", mold_id: mold_id, message: "You must have a file to upload first"}));
        setTimeout("$('#file_upload_error_for_mold_" + mold_id + "').slideUp()", 10000);
      }
      
      return false;
    });
  });
}

load_functions.push("setup_image_uploader");