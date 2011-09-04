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
    NSUserDefaults.standardUserDefaults.setBool(YES, forKey:"WebKitDeveloperExtras")
    NSUserDefaults.standardUserDefaults.synchronize
    self.controller.didFinishLaunching
  end

  def self.development?
    YES
  end
end
