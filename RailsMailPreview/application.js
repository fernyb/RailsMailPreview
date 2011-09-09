function mousePositionForEvent(e) {
  var posx = 0;
  var posy = 0;
  if (!e) var e = window.event;
  if (e.pageX || e.pageY) {
    posx = e.pageX;
    posy = e.pageY;
  }
  else if (e.clientX || e.clientY)        {
    posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
    posy = e.clientY + document.body.scrollTop  + document.documentElement.scrollTop;
  }

  return {x: posx, y:posy};
}

(function($) {
  $.fn.act_as_attachment = function() {
    $(document).click(function(e) {
      var element = e.target;
      if (element) {
        var file = $(element).closest(".attachment_tile");
        if (file.length == 0) {
          $(".attachment_tile").removeClass("attachment_tile_selected");
        }
      }
    });

    function deselectAll() {
      $(".attachment_tile").removeClass("attachment_tile_selected");
    }

    return this.each(function() {
      var $this = $(this);
      $this.mousedown(function(e) {
        if (e.which == 3 || e.which == 3.0) {
          var self = $(this);
          var type = self.attr('data-type') == 'html' ? "html" : "text";
          var rid  = self.attr('data-rid');
          var pos  = mousePositionForEvent(e);
          self.focus();
          window.controller.setMousePosition_posY_(pos.x, pos.y);
          window.controller.onRightClickAttachment_type_(rid, type);
        }
      });

      $this.click(function(e) {
        e.preventDefault();
        deselectAll();
        $(this).focus();
      });

      $this.focus(function(e) {
        var parent = $(this).parent();
        if (parent.hasClass("attachment_tile") && !parent.hasClass("attachment_tile_selected"))
        {
          parent.addClass("attachment_tile_selected");
        }
      });
   });
  };
})(jQuery);

jQuery(function() {
  jQuery("body > #attachments .attachment_tile > div").act_as_attachment();
});
