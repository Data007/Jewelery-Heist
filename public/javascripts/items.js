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
  setup_variation_fields();
}

function check_for_metal_duplicates(value, metal) {
  var token_duplicate = false;
  return token_duplicate;
}

function setup_variation_fields() {
  setup_metal_fields();
  setup_finish_fields();
  setup_gem_fields();
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

load_functions.push("setup_items");
