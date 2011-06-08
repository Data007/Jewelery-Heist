function balance() {
  return $("#balance").text().replace("$", "").replace(",","");
}

function setup_add_payment_form() {
  $("#payment_check_number").attr("value","");
  $("#payment_amount").attr("value", balance());
}

function setup_add_payment() {
  $("#add_payment_module").hide();
  $("#add_a_payment a:first")
    .click(function(){
      setup_add_payment_form();
      $("#add_payment_module").show();
      return false;
    });
  $("#cancel_payment")
    .click(function(){
      $("#add_payment_module").hide();
      setup_add_payment_form();
      return false;
    });
  $("#payments_form form:first")
    .submit(function(){
      
    });
}

load_functions.push("setup_add_payment");