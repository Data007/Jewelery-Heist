Array.prototype.includes = function(value) {
  var length = this.length;
  for(var i=0; i < length; i++) {
    if(this[i] == value) { return true; }
  }
  return false;
}