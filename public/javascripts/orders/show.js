function setup_refund_order() {
  if($("#paid").text() != "$0.00") {
    $("#cancel-order-button").hide();
  } else {
    $("#refund-order-button").hide();
  }
}

load_functions.push("setup_refund_order");