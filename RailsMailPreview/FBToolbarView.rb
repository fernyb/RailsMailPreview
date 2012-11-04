#
#  FBToolbarView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/14/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class RFBToolbarView < INTitlebarView
  attr_accessor :segmentControl

  def viewWillDraw
    super
    @segmentControl.setFrameOrigin([
      CGRectGetWidth(self.frame) - (CGRectGetWidth(self.segmentControl.frame) + 14),
      CGRectGetMinY(@segmentControl.frame)
    ])
  end
end
