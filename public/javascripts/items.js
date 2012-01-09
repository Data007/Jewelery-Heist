function toggle_one_of_a_kind() {
  if($("#item_one_of_a_kind").is(":checked")) {
    $(".variation:first .quantity_backup").text($(".variation:first .quantity:first").val());
    $(".variation:first .quantity:first").val(1);
  } else {
    if($(".variation:first .quantity:first").val() <= 1) {
      $(".variation:first .quantity:first").val(
        $(".variation:first .quantity_backup").text()
      );
    } else {
      $(".variation:first .quantity_backup").text($(".variation:first .quantity:first").val());
    }
  }
}

function setup_one_of_a_kind() {
  $(".variation").each(function(){
    $(this).children().find(".quantity:first").after(
      "<span class='quantity_backup hidden'>" +
      $(this).children().find(".quantity:first").val() +
      "</span>"
    );
  });
  
  if($("#item_one_of_a_kind").is(":checked")) {
    $(".variation:first .quantity:first").val(1);
  }

  $("#item_one_of_a_kind").click(function(){
    toggle_one_of_a_kind();
  });
}

function setup_customizable() {
  var discontinued = $("#discontinued input[type=checkbox]");
  var discontinued_notes = $("#discontinued_notes");
  
  var customizable = $("#customizable input[type=checkbox]");
  var customizable_notes = $("#customizable_notes");
  
  if(customizable.is(":checked")) {
    customizable_notes.slideDown();
    discontinued.attr("checked", false);
  } else {
    customizable_notes.slideUp();
    if(discontinued_notes.find("textarea").val().length > 0) {
      discontinued.attr("checked", true);
    }
  }
  
  customizable.click(function() {
    if(customizable.is(":checked")) {
      customizable_notes.slideDown();
      discontinued.attr("checked", false);
      setup_discontinued();
    } else {
      customizable_notes.slideUp();
      if(discontinued_notes.find("textarea").val().length > 0) {
        discontinued.attr("checked", true);
        setup_discontinued();
      }
    }
  });
}

function setup_discontinued() {
  var discontinued = $("#discontinued input[type=checkbox]");
  var discontinued_notes = $("#discontinued_notes");
  
  var customizable = $("#customizable input[type=checkbox]");
  var customizable_notes = $("#customizable_notes");
  
  if(discontinued.is(":checked")) {
    discontinued_notes.slideDown();
    customizable.attr("checked", false);
    setup_customizable();
  } else {
    discontinued_notes.slideUp();
    if(customizable_notes.find("textarea").val().length > 0) {
      customizable.attr("checked", true);
      setup_customizable();
    }
  }
  
  discontinued.click(function() {
    if(discontinued.is(":checked")) {
      discontinued_notes.slideDown();
      customizable.attr("checked", false);
      setup_customizable();
    } else {
      discontinued_notes.slideUp();
      if(customizable_notes.find("textarea").val().length > 0) {
        customizable.attr("checked", true);
        setup_customizable();
      }
    }
  });
}

function setup_items() {
  setup_customizable();
  setup_discontinued();
  setup_one_of_a_kind();
  setup_metal_fields();
  setup_finish_fields();
  setup_gem_fields();
  setup_image_actions();
  setup_image_uploader();
}

function check_for_metal_duplicates(value, metal) {
  var token_duplicate = false;
  return token_duplicate;
}

function setup_metal_fields() {
  $("#item_metal_csv").tokenizeInput({
    url: "/admin/live_searches/metals/",
    disableQueryToken: true
  });
}

function setup_finish_fields() {
  $("#item_finish_csv").tokenizeInput({
    url: "/admin/live_searches/finishes/",
    disableQueryToken: true
  });
}

function setup_gem_fields() {
  $("#item_jewel_csv").tokenizeInput({
    url: "/admin/live_searches/jewels/",
    disableQueryToken: true
  });
}

function extract_from_csv(data) {
  return data.split(",");
}

function setup_image_actions(){
  setup_image_delete_links();
  setup_image_positioning();
}

function setup_image_delete_links(){
  $(".image .actions .delete").click(function(event){
    var parent_image_id = ("#" + $(this).attr("parent_image_id"));
    $(parent_image_id).remove();
    $.ajax({
      type: "delete",
      dataType: "json",
      url: $(this).attr("href")
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
        url: ("/admin/items/" + $(".variation").attr('data-item-id') + "/variations/" + $(".variation").attr('data-variation-id') + "/attachments/" + ui.item.find(".id").attr("id") + "/update_position/?position=" + position)
      });
    }
  });
}

function setup_image_uploader() {
  $(".image_uploader").each(function(){
    var item_id        = $(this).attr('data-item-id');
    var attachment_url = "/admin/items/" + item_id + "/assets"
    
    $(this).find("input[type='file']").after("<span class='button file_upload_button'>" + "<a href='" + attachment_url + "'>upload image</a></span>");
    $(this).find(".file_upload_button a").click(function(){
      var file_field_value = $(this).parent().parent().find(".original_file_field").val();
      if(file_field_value != undefined && file_field_value != "") {
        var file_form = document.createElement("form");
        file_form.setAttribute("id", "file_upload_form_for_item_" + item_id);
        
        $(this).parent().after(file_form);
        $("#file_upload_form_for_item_" + item_id)
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
          $("#file_upload_form_for_item_" + item_id)
            .find(".original_file_field")
              .clone()
          );
        $("#file_upload_form_for_item_" + item_id)
          .ajaxStart(function(){$("#ajax-status").show();})
          .ajaxForm({
            dataType: "json",
            success: function(responseText, status, xhr){
              console.log(responseText);
              var image = new EJS({url: "/javascripts/ejs/items/_image.ejs"}).render(responseText)
              $(".field.images").append(image);
              $("#file_upload_form_for_item_" + item_id).remove();
              setup_image_actions();
              $("#ajax-status").hide();
            }
          });
        $("#file_upload_form_for_item_" + item_id).submit();
        
      } else {
        $(this).parent().after(new EJS({url: "/ejs/items/_message.ejs"}).render({class: "error", item_id: item_id, message: "You must have a file to upload first"}));
        setTimeout("$('#file_upload_error_for_item_" + item_id + "').slideUp()", 10000);
      }
      
      return false;
    });
  });
}

load_functions.push("setup_items");
