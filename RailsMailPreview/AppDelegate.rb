#
#  AppDelegate.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/12/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  attr_accessor :controller

  def applicationDidFinishLaunching(a_notification)
    self.controller.didFinishLaunching
  end
end

