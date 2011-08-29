#
#  FBProgressWindowController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/29/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBProgressWindowController < NSWindowController
  def init
    self.initWithWindowNibName("ProgressWindow", owner:self)
    self
  end
end
