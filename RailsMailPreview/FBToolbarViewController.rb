#
#  FBToolbarViewController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/14/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBToolbarViewController < NSViewController
  attr_accessor :segmentControl
  attr_accessor :parentController

  def init
    self.initWithNibName("FBToolbarView", bundle:NSBundle.mainBundle)
    self
  end

  def awakeFromNib
    self.view.segmentControl = @segmentControl

    0.upto(@segmentControl.segmentCount - 1) do |i|
      @segmentControl.imageForSegment(i).setTemplate(YES)
      @segmentControl.setSelected(NO, forSegment:i)
    end

    window_width = CGRectGetWidth(@parentController.window.frame)
    @segmentControl.setFrameOrigin([
      (window_width / 2) - (CGRectGetWidth(@segmentControl.frame) / 2),
      @segmentControl.frame.origin.y
    ])
  end

  def segmentedItemSelected(sender)
    case sender.selectedSegment
    when 0
      self.selectLeftPanelAction(sender)
    when 1
      self.selectHorizontalAction(sender)
    when 2
      self.selectRotateAction(sender)
    end
  end

  def selectRotateAction(sender)
    @parentController.toggle_rotate_view
  end

  def selectHorizontalAction(sender)
    @parentController.toggle_horizontal_view
  end

  def selectLeftPanelAction(sender)
    @parentController.toggle_left_panel
  end
end
