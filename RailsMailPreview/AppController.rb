#
#  AppController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/12/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class AppController < NSWindowController
  attr_accessor :toolbarViewController
  attr_accessor :sidePanelViewController
  attr_accessor :contentSplitView
  attr_accessor :htmlview
  attr_accessor :plainview
  attr_accessor :contentTabView
  attr_accessor :tabviewBar
  attr_accessor :queue


  def didFinishLaunching
    setup_toolbar
    setup_side_views
    setup_left_panel
    setup_notification
  end

  def window(aWindow, willPositionSheet:sheet, usingRect:rect)
    newRect = rect
    newRect.origin.y -= 18.0
    newRect
  end

  def setup_notification
    center = NSDistributedNotificationCenter.defaultCenter
    center.addObserver(self,
                       selector: :"receiveNotification:",
                       name: "RailsMailPreview.email",
                       object: nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
                                                selector: :"tabItemDidChangeNotification:",
                                                    name: "FBTabViewItemDidChange",
                                                  object: nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector: :"receiveDidLoadHTMLString:",
                                                   name: "loadHTMLString",
                                                   object: nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector: :"receiveSaveNewMessage:",
                                                   name: "didSaveNewMessage",
                                                   object: nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector: :"noMessagesToDisplay:",
                                                   name: "NoMessagesToDisplayNotification",
                                                   object: nil)
  end

  def tabItemDidChangeNotification(notification)
    selectedTabIndex = notification.object.itemIndex
    @contentTabView.selectTabViewItemAtIndex(selectedTabIndex)
  end

  def didReceiveNewMessage
    NSApplication.sharedApplication.setSupressNextAttention(YES)
    @progressWindow ||= FBProgressWindowController.alloc.init
    NSApplication.sharedApplication.beginSheet(@progressWindow.window,
                                              modalForWindow: self.window,
                                              modalDelegate: self,
                                              didEndSelector: nil,
                                              contextInfo: nil)
  end

  def didFinishReceivingNewMessage
    NSApplication.sharedApplication.endSheet(@progressWindow.window)
    @progressWindow.setProgressString("")
    @progressWindow.window.orderOut(self)
  end

  def updateProgressString
    msg = @progress_count == 1 ? "Message" : "Messages"
    @progressWindow.setProgressString("Processing #{@progress_count} #{msg}")
  end

  def didCompleteSaveOperation
    @progress_count -= 1
    if @progress_count == 0
      @sidePanelViewController.didSaveAllMessages
    else
      @sidePanelViewController.didSaveMessage
    end
  end

  def didBeginSaveOperation
    self.updateProgressString
  end

  def receiveNotification(aNotification)
    @progress_count ||= 0
    self.didReceiveNewMessage if @progress_count == 0

    @progress_count += 1
    @queue ||= NSOperationQueue.alloc.init
    @queue.setMaxConcurrentOperationCount(1)

    operation = ParseMailMessageOperation.alloc.initWithMessage(aNotification.object)
    operation.controller = self
    @queue.addOperation(operation)
  end

  def receiveSaveNewMessage(notification)
    self.didFinishReceivingNewMessage
    self.receiveDidLoadHTMLString(notification)
    self.show_left_panel
    @sidePanelViewController.table.reloadData
    @sidePanelViewController.didSaveMessage
  end

  def hideTabsIfNeeded(item)
    if item.html.length < 2
      self.setHiddenHTMLTab(YES)
    else
      self.setHiddenHTMLTab(NO)
    end

    if item.text.length < 2
      self.setHiddenTEXTTab(YES)
    else
      self.setHiddenTEXTTab(NO)
    end

    if item.html.length > 2
      self.setSelectTab(:html)
    else
      self.setSelectTab(:text)
    end
  end

  def setSelectTab(type)
    if type == :html
      self.selectTabAtIndex(0)
    else
      self.selectTabAtIndex(1)
    end
  end

  def selectTabAtIndex(idx)
    @contentTabView.selectTabViewItemAtIndex(idx)
    @tabviewBar.selectTabAtIndex(idx)
  end

  def receiveDidLoadHTMLString(notification)
    return if notification.object.nil?
    self.hideTabsIfNeeded(notification.object)

    if self.contentTabView.isHidden
      @startup_view.setHidden(YES) if @startup_view
      self.contentTabView.setHidden(NO)
      self.setHiddenTabBar(NO)
    end
  end

  def setHiddenHTMLTab(b)
    if b == YES
      @tabviewBar.setHideTabAtIndex(0)
    else
      @tabviewBar.setShowTabAtIndex(0)
    end
  end

  def setHiddenTEXTTab(b)
    if b == YES
      @tabviewBar.setHideTabAtIndex(1)
    else
      @tabviewBar.setShowTabAtIndex(1)
    end
  end

  def noMessagesToDisplay(notification)
    self.setHiddenTabBar(YES)
    self.hide_left_panel
    @startup_view.message = "No Messages Available"
    @startup_view.setHidden(NO)
  end

  def setup_startup_view
    self.contentTabView.setHidden(YES)
    self.setHiddenTabBar(YES)

    @startup_view = FBStartupView.alloc.initWithFrame([0,0, CGRectGetWidth(self.contentTabView.superview.frame), CGRectGetHeight(self.contentTabView.superview.frame)])
    if !Message.first
      self.hide_left_panel(animate:NO)
      @startup_view.message = "No Messages Available"
    else
      self.show_left_panel
      @startup_view.message = "No Message Selected"
    end

    self.contentTabView.superview.addSubview(@startup_view.render)
  end

  def setHiddenTabBar(b)
    if b == YES
      NSAnimationContext.beginGrouping
      NSAnimationContext.currentContext.setDuration(self.animationDuration)
      self.tabviewBar.setHidden(YES)
      @contentSplitView.animator.setFrame([0,0, CGRectGetWidth(@contentSplitView.superview.frame), CGRectGetHeight(@contentSplitView.superview.frame)])
      NSAnimationContext.endGrouping
      self.window.titleBarView.setShouldDrawBottomLine(YES)
    else
      NSAnimationContext.beginGrouping
      NSAnimationContext.currentContext.setDuration(self.animationDuration)
      self.tabviewBar.setHidden(NO)
      @contentSplitView.animator.setFrame([0,0,
                                 CGRectGetWidth(@contentSplitView.superview.frame),
                                 CGRectGetHeight(@contentSplitView.superview.frame) - CGRectGetHeight(self.tabviewBar.frame)])
      NSAnimationContext.endGrouping
      self.window.titleBarView.setShouldDrawBottomLine(NO)
    end
  end

  def setup_side_views
    # Setup the left view
    @htmlview = FRBSideView.alloc.initWithFrame(
      [0,0, CGRectGetWidth(@contentTabView.frame), CGRectGetHeight(@contentTabView.frame)]
    )
    @htmlview.view_type = :html

    # Setup the right view
    @plainview = FRBSideView.alloc.initWithFrame(
      [0,0, CGRectGetWidth(@contentTabView.frame), CGRectGetHeight(@contentTabView.frame)]
    )
    @plainview.view_type = :text

    htmlTabItem = @contentTabView.tabViewItemAtIndex(0)
    textTabItem = @contentTabView.tabViewItemAtIndex(1)

    htmlTabItem.setView(@htmlview)
    textTabItem.setView(@plainview)

    @contentTabView.selectTabViewItemAtIndex(0)
  end

  def setup_toolbar
    self.window.setTitleBarHeight(40.0)
    self.window.titleBarView.setShouldDrawBottomLine(YES)

    @toolbarViewController = FBToolbarViewController.alloc.init
    @toolbarViewController.parentController = self
    self.window.setTitleBarView(@toolbarViewController.view)
  end

  def animationDuration
    0.16
  end

  def toggle_left_panel
    panelview = @contentSplitView.subviews.first
    if CGRectGetWidth(panelview.frame) <= 1
      self.show_left_panel
    else
      self.hide_left_panel
    end
  end

  def show_left_panel
    panelview = @contentSplitView.subviews.first
    @toolbarViewController.selectSidePanelButton
    if CGRectGetWidth(panelview.frame) <= 1
      NSAnimationContext.beginGrouping
      NSAnimationContext.currentContext.setDuration(self.animationDuration)
      if @prevContentSplitViewFrame
        panelview.animator.setFrame(@prevContentSplitViewFrame)
      else
        panelview.animator.setFrame([0,0, 300, CGRectGetHeight(panelview.frame)])
      end
      NSAnimationContext.endGrouping
    end
  end

  def hide_left_panel(opts={})
    panelview = @contentSplitView.subviews.first
    @prevContentSplitViewFrame = panelview.frame
    @toolbarViewController.unselectSidePanelButton
    if opts[:animate] == NO
      panelview.setFrameSize([0.0, CGRectGetHeight(panelview.frame)])
    else
      NSAnimationContext.beginGrouping
      NSAnimationContext.currentContext.setDuration(self.animationDuration)
      panelview.animator.setFrameSize([0.0, CGRectGetHeight(panelview.frame)])
      NSAnimationContext.endGrouping
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
      @contentSplitView.setDelegate(self)
      self.setup_startup_view
    end
  end

  # - (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex
  def splitView(aSplitView, constrainMaxCoordinate:proposedMax, ofSubviewAt:dividerIndex)
    dividerIndex == 0 ? 350 : proposedMax
  end

  # - (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
  def splitView(aSplitView, constrainMinCoordinate:proposedMin, ofSubviewAt:dividerIndex)
    dividerIndex == 0 ? 150 : proposedMin
  end

  # - (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
  def splitView(aSplitView, shouldAdjustSizeOfSubview:subview)
   subview.className != "FBSidePanelView"
  end
end
