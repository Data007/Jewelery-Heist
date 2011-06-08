function setup_add_quick_line_item() {
  $("#add_quick_line_item_module").hide();
  $("#add_a_quick_line_item a:first")
    .click(function(){
      setup_add_quick_line_item();
      $("#add_quick_line_item_module").show();
      return false;
    });
  $("#cancel_quick_line_item")
    .click(function(){
      $("#add_quick_line_item_module").hide();
      return false;
    });
  $("#payments_form form:first")
    .submit(function(){
      
    });
}

load_functions.push("setup_add_quick_line_item");