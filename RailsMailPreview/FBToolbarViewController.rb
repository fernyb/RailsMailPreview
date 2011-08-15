#
#  FBToolbarViewController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/14/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBToolbarViewController < NSViewController
  attr_accessor :segmentControl

  def init
    self.initWithNibName("FBToolbarView", bundle:NSBundle.mainBundle)
    self
  end

  def awakeFromNib
    0.upto(@segmentControl.segmentCount - 1) do |i|
      @segmentControl.imageForSegment(i).setTemplate(YES)
    end
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
  end

  def selectHorizontalAction(sender)
  end

  def selectLeftPanelAction(sender)
  end
end
