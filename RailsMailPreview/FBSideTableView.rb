#
#  FBSideTableView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 9/8/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBSideTableView < NSTableView
  def keyDown(event)
    if event.keyCode == 51 || event.keyCode == 117
      NSNotificationCenter.defaultCenter.postNotificationName("didPressDeleteKeyNotification", object:nil)
    else
      super(event)
    end
  end
end
