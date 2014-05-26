/**
Javascript helper for building `image-resizer` url endpoints
 - this file is partially built via the parent ruby process to include the
   available modifiers.
*/


(function(root, factory) {
  'use strict';

  // AMD: import Backbone and underscore into the factory
  if (typeof define === 'function' && define.amd) {
    define([], function(){
      return factory(root);
    });

  // CommonJS: for Node.js or Browserify
  } else if (typeof exports !== 'undefined') {
    module.exports = factory(root);

  // Finally, as a browser global.
  } else {
    root.ImageResizer = factory(root);
  }

}(this, function(root){
  'use strict';

  function IR(){}

  IR.irImageTag = function(source, modifiers){

  };

  <% unless Image::Resizer::Rails.alias_name.nil? %>
    IR.<%= Image::Resizer::Rails.alias_name %> = IR.irImageTag;
  <% end %>

  IR.modifiers = <%= Image::Resizer::Rails.modifiers %>;

  IR.CDN = <%= Image::Resizer::Rails.cdn %>;

  IR.VERSION = <%= Image::Server::Rails.VERSION %>;

  return IR;
}));
