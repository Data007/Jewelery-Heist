var Controller = Class.extend({
  init: function(options) {
    this.url = options.url;
    
    // -- Callbacks --
      this.onNextPage     = function() {return true;};
      this.onPreviousPage = function() {return true;};
      
      if(options.onNextPage)      { this.onNextPage = options.onNextPage; }
      if(options.onPreviousPage)  { this.onPreviousPage = options.onPreviousPage; }
    // --
    
    this.pages = [];
    this.current_page = 1;
    this.pages.push(this.get_page(this.url));
    this.next_available = false;
    this.prev_available = false;
    this.new_page = true;
    this.preload_next_page();
  },
  get_page: function(url) {
    return $.ajax({ type: "GET", url: url, dataType: "js", async: false }).responseText;
  },
  next_page: function() {
    var page_number = (this.current_page + 1);
    this.new_page = false;
    
    if(page_number > this.pages.length) {
      var page = this.get_page(this.url + "?page=" + page_number)
      if(page == "" || page == " ") {
        this.next_available = false;
        return false;
      } else {
        this.pages.push(page);
        this.new_page = true;
      }
    }
    
    this.current_page = page_number;
    this.next_available = true;
    this.prev_available = true;
    this.preload_next_page();
    this.onNextPage();
    return this.pages[page_number - 1];
  },
  previous_page: function() {
    var page_number = (this.current_page - 1);
    if(page_number > 0) {
      this.current_page = page_number;
      this.next_available = true;
      this.prev_available = true;
      this.onPreviousPage();
      return this.pages[this.current_page - 1];
    } else {
      this.next_available = true;
      this.prev_available = false;
      return false;
    }
  },
  preload_next_page: function() {
    var page_number = (this.current_page + 1);
    
    if(page_number > this.pages.length) {
      var page = this.get_page(this.url + "?page=" + page_number)
      if(page == "" || page == " ") {
        this.next_available = false;
        return false;
      } else {
        this.pages.push(page);
      }
    }
    
    this.current_page = page_number;
    this.next_available = true;
  },
  page: function() {
    return this.pages[this.current_page - 1];
  }
});

var ItemController = Controller.extend({});