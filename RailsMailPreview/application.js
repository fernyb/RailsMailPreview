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
          self.focus();
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
