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
        url: ("/admin/items/" + $(".variation").attr('data-item-id') + "/variations/" + $(".variation").attr('data-variation-id') + "/attachments/" + ui.item.find(".id").attr("id") + "/update_position/?position=" + position)
      });
    }
  });
}

function setup_image_actions() {
  setup_image_delete_links();
  setup_image_positioning();
}

function setup_image_uploader() {
  $(".image_uploader").each(function(){
    var variation_id   = $('.variation').attr('data-variation-id');
    var item_id        = $('.variation').attr('data-item-id');
    var attachment_url = "/admin/items/" + item_id + "/variations/" + variation_id + "/attachments"
    
    $(this).find("input[type='file']").after("<span class='button file_upload_button'>" + "<a href='" + attachment_url + "'>upload image</a></span>");
    $(this).find(".file_upload_button a").click(function(){
      var file_field_value = $(this).parent().parent().find(".original_file_field").val();
      if(file_field_value != undefined && file_field_value != "") {
        var file_form = document.createElement("form");
        file_form.setAttribute("id", "file_upload_form_for_variation_" + variation_id);
        
        $(this).parent().after(file_form);
        $("#file_upload_form_for_variation_" + variation_id)
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
          $("#file_upload_form_for_variation_" + variation_id)
            .find(".original_file_field")
              .clone()
          );
        $("#file_upload_form_for_variation_" + variation_id)
          .ajaxStart(function(){$("#ajax-status").show();})
          .ajaxForm({
            dataType: "json",
            success: function(responseText, status, xhr){
              console.log(responseText);
              var image = new EJS({url: "/javascripts/ejs/items/_image.ejs"}).render(responseText)
              $(".field.images").append(image);
              $("#file_upload_form_for_variation_" + variation_id).remove();
              setup_image_actions();
              $("#ajax-status").hide();
            }
          });
        $("#file_upload_form_for_variation_" + variation_id).submit();
        
      } else {
        $(this).parent().after(new EJS({url: "/ejs/items/_message.ejs"}).render({class: "error", variation_id: variation_id, message: "You must have a file to upload first"}));
        setTimeout("$('#file_upload_error_for_variation_" + variation_id + "').slideUp()", 10000);
      }
      
      return false;
    });
  });
}

function check_for_metal_duplicates(value, metal) {
  var token_duplicate = false;
  return token_duplicate;
}

function setup_variation_fields() {
  $(".variation").each(function(){
    var variation = $(this);
    setup_metal_fields(variation);
    setup_finish_fields(variation);
    setup_gem_fields(variation);
    setup_mold_fields(variation);
  });
}

function setup_metal_fields(variation) {
  var metal_field = variation.find(".metal_field");
  metal_field.tokenizeInput({
    url: "/admin/live_searches/metals/",
    disableQueryToken: true
  });
}

function setup_finish_fields(variation) {
  var finish_field = variation.find(".finish_field");
  finish_field.tokenizeInput({
    url: "/admin/live_searches/finishes/",
    disableQueryToken: true
  });
}

function setup_gem_fields(variation) {
  var gem_field = variation.find(".jewel_field");
  gem_field.tokenizeInput({
    url: "/admin/live_searches/jewels/",
    disableQueryToken: true
  });
}

function setup_mold_fields(variation) {
  var mold_field = variation.find(".mold_field");
  mold_field.tokenizeInput({
    url: "/admin/live_searches/molds/",
    disableQueryToken: true
  });
}

function extract_from_csv(data) {
  // alert(data);
  console.log(data);
  return data.split(",");
}

function refresh_variation_title(variation_element) {
  var variation = $(variation_element);
  var new_title = "";
  var metals = extract_from_csv(variation.find(".metal_field").val());
  var gems = extract_from_csv(variation.find(".gem_field").val());
  var finishes = extract_from_csv(variation.find(".finish_field").val());
  if(metals.length >= 1) {
    $(metals).each(function(){
      if(new_title.length < 1 ) { new_title = this; }
      else { new_title += ", " + this; }
    });
  }
  if(gems.length >= 1) {
    $(gems).each(function(){
      if(new_title.length < 1) { new_title = this; }
      else { new_title += ", " + this; }
    });
  }
  if(finishes.length >= 1) {
    $(finishes).each(function(){
      if(new_title.length < 1) { new_title = this; }
      else { new_title += ", " + this; }
    });
  }
  title = variation.find(".title:first");
  $(title).text(new_title);
}

function setup_form() {
  setup_image_actions();
  setup_image_uploader();
  setup_variation_fields();
}

load_functions.push("setup_form");
