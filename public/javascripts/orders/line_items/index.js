function update_totals() {
  var untaxable_subtotal = 0;
  var taxable_subtotal = 0;
  var tax = 0;
  var total = 0;
  $(".line_item").each(function(){
    var price = $(this).children(".price").children("input").val();
    var quantity = 1;
    
    if($(this).children(".quantity").children("input").val() != undefined) {
      quantity = $(this).children(".quantity").children("input").val();
    } else {quantity = $(this).children(".quantity").text();}
    
    var line_total = ($(this).children(".refunded").text() == "REFUNDED") ? 0 : (price * quantity);
    
    if($(this).children(".taxable").children("input:checked").length > 0) {
      taxable_subtotal += (line_total);
    } else {
      untaxable_subtotal += (line_total);
    }
    
    $(this).children(".total").html("$" + line_total.toFixed(2))
  });
  tax = (taxable_subtotal * 0.06);
  shipping = 0;
  
  if($("#ship").children("input:checked").length > 0) {
    if($("#order_shipping_option :selected").text().match(/\d*\.\d\d/) != null) {
      shipping = parseInt($("#order_shipping_option :selected").text().match(/\d*\.\d\d/)[0]);
    }
  }
  
  total = (taxable_subtotal + tax + untaxable_subtotal + shipping);
  // total = (taxable_subtotal + tax + untaxable_subtotal);
  $("#tax").html("$" + tax.toFixed(2));
  $("#total").html("$" + total.toFixed(2));
}

function setup_line_item_updates() {
  $(".line_item").each(function(){
    $(this).find("input").keyup(function(){
      update_totals();
    });
    $(this).find(":checkbox").change(function(){
      update_totals();
    });
  });
  $("#ship").find(":checkbox").change(function(){
    update_totals();
  });
  $("#order_shipping_option").change(function(){
    update_totals();
  });
  update_totals();
}

load_functions.push("setup_line_item_updates");