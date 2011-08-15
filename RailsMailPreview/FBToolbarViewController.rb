#
#  FBToolbarViewController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/14/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBToolbarViewController < NSViewController
  
  def init
    self.initWithNibName("FBToolbarView", bundle:NSBundle.mainBundle)
    self
  end
end