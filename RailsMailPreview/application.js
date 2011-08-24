var initializeAttachmentSelection = function() {
  var tile = $("body > #attachments .attachment_tile > div");

  tile.click(function(e) {
    e.preventDefault();
    $(this).focus();
  });

  tile.focus(function() {
    var parent = $(this).parent();
    if (parent.hasClass("attachment_tile") &&
        !parent.hasClass("attachment_tile_selected"))
    {
      parent.addClass("attachment_tile_selected");
    }
  });

  $(document).click(function(e) {
    var element = e.target;
    if (element) {
      var file = $(element).closest(".attachment_tile");
      if (file.length == 0) {
        $(".attachment_tile").removeClass("attachment_tile_selected");
      }
    }
  });
};

$(function(){
  initializeAttachmentSelection();
});
