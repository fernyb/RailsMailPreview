#
#  FRBSideView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/13/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class FRBSideView < NSView
  attr_accessor :webview
  attr_accessor :side
  attr_accessor :view_type

  def initWithFrame(rect)
    super(rect)
    self.after_init(rect)
    self
  end

  def after_init(rect)
    @webview = WebView.alloc.initWithFrame(rect)
    @webview.setDrawsBackground(NO)

    self.addSubview(@webview)
    self.setAutoresizingMask(self.resizeMask)
  end

  def setAutoresizingMask(mask)
    super(mask)
    @webview.setAutoresizingMask(mask)
  end

  def loadHTMLString(html)
    base_url = NSURL.URLWithString("file://localhost/")
    @webview.mainFrame.loadHTMLString(html, baseURL:base_url)
  end

  def resizeMask
    NSViewMaxYMargin | NSViewMaxYMargin | NSViewHeightSizable | NSViewWidthSizable
  end

  def drawRect(rect)
    NSColor.colorWithPatternImage(NSImage.imageNamed("defaultdesktop.png")).set
    NSRectFill(rect)
  end
end
