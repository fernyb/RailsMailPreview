#
#  FBToolbarView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/14/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBToolbarView < INTitlebarView
  attr_accessor :segmentControl
  
  def drawRect(rect)
    @segmentControl.setFrameOrigin([
      (CGRectGetWidth(self.frame) / 2) - (CGRectGetWidth(@segmentControl.frame) / 2),
      @segmentControl.frame.origin.y
    ])
    super(rect)
  end
end
