#
#  AppController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/12/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class AppController < NSWindowController
  attr_accessor :splitview
  attr_accessor :bottomViewController
  attr_accessor :toolbarViewController
  attr_accessor :sidePanelViewController

  def didFinishLaunching
    setup_toolbar
    setup_side_views
    setup_left_panel
    setup_notification
    setup_toolbar
  end

  def setup_notification
    center = NSDistributedNotificationCenter.defaultCenter
    center.addObserver(self,
                       selector: :"receiveNotification:",
                       name: "RailsMailPreview.email",
                       object: nil)
  end

  def receiveNotification(aNotification)
    NSLog("Notification Received")
    msg = aNotification.object
    mail = Mail.new(msg)
    set_mail_message(mail)
    NSLog("Notification Ended...")
  end

  def set_mail_message(mail)
    self.html_sideview.loadHTMLString(mail.html_part.body.to_s)
    self.text_sideview.loadHTMLString(mail.text_part.body.to_s)
  end

  def setup_side_views
    # Setup the left view
    currentLeftView = self.splitview.subviews[0]
    leftView = FRBSideView.alloc.initWithFrame(
      NSMakeRect(0,0, CGRectGetWidth(currentLeftView.frame), CGRectGetHeight(currentLeftView.frame))
    )
    leftView.view_type = :html
    currentLeftView.addSubview(leftView)

    # Setup the right view
    currentRightView = self.splitview.subviews[1]
    rightView = FRBSideView.alloc.initWithFrame(
      NSMakeRect(0,0, CGRectGetWidth(currentRightView.frame), CGRectGetHeight(currentRightView.frame))
    )
    rightView.view_type = :text
    currentRightView.addSubview(rightView)
  end

  def html_sideview
    self.subview_type(:html)
  end

  def text_sideview
    self.subview_type(:text)
  end

  def subview_type(type)
    self.splitview.subviews.each do |v|
      v.subviews.each do |sv|
        if sv.respond_to?(:view_type) && sv.view_type == type
          return sv
        end
      end
    end
    nil
  end

  def setup_toolbar
    self.window.setTitleBarHeight(40.0)
    toolbarViewController = FBToolbarViewController.alloc.init
    self.window.setTitleBarView(toolbarViewController.view)
  end

  def setup_left_panel
    @sidePanelViewController = FBSidePanelViewController.alloc.init
    if @splitview.subviews.count == 2
      @splitview.addSubview(@sidePanelViewController.view,
                            positioned: NSWindowBelow,
                            relativeTo: @splitview.subviews.first)
    end
  end
end
