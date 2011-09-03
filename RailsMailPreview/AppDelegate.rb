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
  attr_accessor :tabWindowController
  
  def applicationDidFinishLaunching(a_notification)
    NSUserDefaults.standardUserDefaults.setBool(YES, forKey:"WebKitDeveloperExtras")
    NSUserDefaults.standardUserDefaults.synchronize
    self.controller.didFinishLaunching
    
    @tabWindowController = MyTabWindowController.alloc.init
  end

  def self.development?
    YES
  end
end
