#
#  FBSidePanelView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/15/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBSidePanelView < NSView
  def drawRect(dirtyRect)
    NSColor.whiteColor.set
    NSRectFill(self.bounds)
  end
end
