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

var initializeAttachmentSelection = function() {
  var tile = $("body > #attachments .attachment_tile > div");

  tile.mousedown(function(e) {
    if (e.which == 3 || e.which == 3.0) {
      var type = $(this).attr('data-type') == 'html' ? "html" : "text";
      var rid = $(this).attr('data-rid');
      var pos = mousePositionForEvent(e);
      window.controller.setMousePosition_posY_(pos.x, pos.y);
      window.controller.onRightClickAttachment_type_(rid, type);
    }
  });

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
