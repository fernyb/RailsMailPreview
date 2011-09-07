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
  end

  def segmentedItemSelected(sender)
    case sender.selectedSegment
    when 0
      self.selectLeftPanelAction(sender)
    end
  end

  def selectLeftPanelAction(sender)
    @parentController.toggle_left_panel
  end

  def selectSidePanelButton
    @segmentControl.setSelected(YES, forSegment:0)
  end

  def unselectSidePanelButton
    @segmentControl.setSelected(NO, forSegment:0)
  end
end
