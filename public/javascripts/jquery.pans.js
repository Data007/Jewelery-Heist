/* Plugin code */
$.fn.pans = function(options) {
  var options = $.extend(options);
  
  // make sure critical default values are not null
    if(options.orientation == undefined){options.orientation = "horizontal";}
  // --
  
  return this.each(function(){
    var scrollPane = $.ScrollPane(this, options);
  });
}

/* Plugin object */
$.ScrollPane = function(pane, options) {
  // Basic positional variables
    var orientation     = options.orientation;
    var wrapper         = $(pane);
    var wrapper_height  = wrapper.outerHeight();
    var wrapper_width   = wrapper.outerWidth();
    var wrapper_left    = wrapper.offset().left;
    var wrapper_top     = wrapper.offset().top;
    var contentsPane    = wrapper.find(".contents-pane");
    var contents        = contentsPane.children();
    var contents_height = 0;
    var contents_width  = 0;
    var mouse_entry_x   = 0;
    var mouse_entry_y   = 0;
  // --
  
  // Set orientation dependent variables
    if(orientation == "horizontal") {
      contents_height = wrapper.innerHeight();
      $(contents).each(function(){
        contents_width += $(this).outerWidth();
      });
      contentsPane.css("width", contents_width + "px");
    } else if(orientation == "vertical") {
      contents_width = wrapper.innerWidth();
      $(contents).each(function(){
        contents_height += $(this).outerHeight();
      });
      contentsPane.css("height", contents_height + "px")
    }
  // --
  
  // Setup mouse movement
  wrapper.mouseover(function(pointer) {
    mouse_entry_x = pointer.pageX, mouse_entry_y = pointer.pageY;
  });
  
  wrapper.mouseout(function(pointer) {
    mouse_entry_x = 0, mouse_entry_y = 0;
  });
  
  wrapper.mousemove(function(pointer) {
    if(orientation == "horizontal") {
      var new_position = (pointer.pageX - wrapper_left) * contents_width / wrapper_width;
      wrapper.scrollLeft(new_position);
    } else if(orientation == "vertical") {
      var new_position = (pointer.pageY - wrapper_top) * contents_height / wrapper_height;
      wrapper.scrollTop(new_position);
    }
  });
  // --
  
  return wrapper;
}