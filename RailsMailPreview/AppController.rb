#
#  AppController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/12/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class AppController < NSWindowController
  attr_accessor :splitview
  attr_accessor :leftWebview
  attr_accessor :rightWebview

  def awakeFromNib
    notifier = NSDistributedNotificationCenter.defaultCenter
    notifier.addObserver(self, 
                         selector: :"receiveNotification:", 
                         name:"RailsMailPreview.email",
                         object:nil)
  end

  def receiveNotification(aNotification)
    NSLog("Notification Received")
    msg = aNotification.object
    mail = Mail.new(msg)

    url = NSURL.URLWithString("http://localhost/")

    @leftWebview.mainFrame.loadHTMLString(mail.html_part.body.to_s, baseURL:url)
    @rightWebview.mainFrame.loadHTMLString(mail.text_part.body.to_s, baseURL:url)
    NSLog("Notification Ended")
  end
end
