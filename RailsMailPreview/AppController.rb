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
  attr_accessor :contentSplitView
  attr_accessor :htmlview
  attr_accessor :plainview

  def didFinishLaunching
    setup_toolbar
    setup_side_views
    setup_left_panel
    setup_notification
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
    @sidePanelViewController.saveNewMessage(mail)
  end

  def setup_side_views
    # Setup the left view
    currentLeftView = self.splitview.subviews[0]
    @htmlview = FRBSideView.alloc.initWithFrame(
      NSMakeRect(0,0, CGRectGetWidth(currentLeftView.frame), CGRectGetHeight(currentLeftView.frame))
    )
    @htmlview.view_type = :html

    # Setup the right view
    currentRightView = self.splitview.subviews[1]
    @plainview = FRBSideView.alloc.initWithFrame(
      NSMakeRect(0,0, CGRectGetWidth(currentRightView.frame), CGRectGetHeight(currentRightView.frame))
    )
    @plainview.view_type = :text

    self.splitview.subviews.first.removeFromSuperview
    self.splitview.subviews.last.removeFromSuperview

    self.splitview.addSubview(@htmlview)
    self.splitview.addSubview(@plainview)
  end

  def html_sideview
    self.subview_type(:html)
  end

  def text_sideview
    self.subview_type(:text)
  end

  def subview_type(type)
    self.splitview.subviews.each do |v|
      if v.respond_to?(:view_type) && v.view_type == type
        return sv
      end
    end
    nil
  end

  def setup_toolbar
    self.window.setTitleBarHeight(40.0)
    @toolbarViewController = FBToolbarViewController.alloc.init
    @toolbarViewController.parentController = self
    self.window.setTitleBarView(@toolbarViewController.view)
  end

  def toggle_left_panel
    panelview = @contentSplitView.subviews.first
    if CGRectGetWidth(panelview.frame) <= 1
      panelview.setFrame([0,0, 300, 300])
    else
      panelview.setFrame(CGRectZero)
    end
  end

  def setup_left_panel
    if @sidePanelViewController.nil?
      @sidePanelViewController = FBSidePanelViewController.alloc.init
      @sidePanelViewController.htmlview = @htmlview
      @sidePanelViewController.plainview = @plainview
      @contentSplitView.subviews.first.removeFromSuperview
      @contentSplitView.addSubview(@sidePanelViewController.view,
                              positioned: NSWindowBelow,
                              relativeTo: @contentSplitView.subviews.first)
    end
  end

  def toggle_rotate_view
    leftview = @splitview.subviews.first

    @splitview.subviews.first.removeFromSuperview
    @splitview.subviews.last.removeFromSuperview

    if leftview.view_type == :html
      @splitview.addSubview(@plainview)
      @splitview.addSubview(@htmlview)
    else
      @splitview.addSubview(@htmlview)
      @splitview.addSubview(@plainview)
    end
    @splitview.adjustSubviews
  end

  def toggle_horizontal_view
    @splitview.setVertical(!@splitview.isVertical)
    @splitview.setNeedsDisplay(YES)
    @splitview.adjustSubviews
  end
end
