#
#  FBProgressWindowController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/29/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBProgressWindowController < NSWindowController
  attr_accessor :progressbar

  def init
    self.initWithWindowNibName("ProgressWindow", owner:self)
    self
  end

  def awakeFromNib
    @progressbar.startAnimation(self)
  end
end
