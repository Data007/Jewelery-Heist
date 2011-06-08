function setup_ajax_status() {
  var status = $("#ajax-status");
  status.hide();
  // status.ajaxStart(function(){
  //     $(this).show();
  //   });
  //   status.ajaxStop(function(){
  //     $(this).hide();
  //   });
}

load_functions.push("setup_ajax_status");


function validate_not_empty(form) {
  var validates = true;
  $(form).find(".field.required").each(function(){
    var current_value = $(this).attr("value");
    if(current_value == "" || current_value == null) {
      validates = false;
    }
  });
  return validates;
}

function value_checkboxes() {
  $("input[type='checkbox']").valueCheckbox();
}
load_functions.push("value_checkboxes");

$(function() { $(load_functions).each(function() { eval(this + "();"); }); });