#
#  FRBSideView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/13/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


# One thing I could not find was any way to enable the drop shadow for the WebViewFrame
# So I'm drawing it my self.
WebFrameView.class_eval do
  attr_accessor :shouldDrawShadow

  alias_method :orig_drawRect, :drawRect
  def drawRect(rect)
    if self.shouldDrawShadow
     scrollView = self.subviews.first

     rectOffet = scrollView.contentView.bounds

     shadow = NSShadow.alloc.init
     shadow.setShadowBlurRadius(10)
     shadow.setShadowColor(NSColor.colorWithCalibratedWhite(0.0, alpha:0.85))
     shadow.setShadowOffset([0, 0])

     bottomY = (CGRectGetMinY(scrollView.contentView.bounds) + CGRectGetHeight(scrollView.contentView.bounds)) - CGRectGetHeight(scrollView.documentView.bounds)

     # Draw the Right Shadow
     rightMarginX = CGRectGetWidth(scrollView.contentView.bounds) - ((CGRectGetMinX(scrollView.contentView.bounds) + CGRectGetWidth(scrollView.contentView.bounds)) - CGRectGetWidth(scrollView.documentView.bounds))
     if rightMarginX < CGRectGetWidth(scrollView.contentView.bounds)
       shadow.set
       NSRectFill([rightMarginX - 4, (bottomY < 0 ? 0 : bottomY), 4, CGRectGetHeight(scrollView.documentView.bounds) + bottomY])
     end

     # Draw the left Shadow
     leftMarginX = rightMarginX - CGRectGetWidth(scrollView.documentView.bounds)
     if leftMarginX  > 0
       shadow.set
       NSRectFill([leftMarginX, (bottomY < 0 ? 0 : bottomY), 4, CGRectGetHeight(scrollView.documentView.bounds) + bottomY])
     end

     # Draw the top shadow
     if CGRectGetMinY(scrollView.contentView.bounds) < 0
       shadow.set
       NSRectFill([leftMarginX, CGRectGetMaxY(scrollView.contentView.bounds) - 4.0, CGRectGetWidth(scrollView.documentView.bounds), 4])
     end

     # Draw the bottom shadow
     if bottomY > 0
       shadow.set
       NSRectFill([leftMarginX, bottomY, CGRectGetWidth(scrollView.documentView.bounds), 4])
     end

    end
    orig_drawRect(rect)
  end
end

class FRBSideView < NSView
  attr_accessor :webview
  attr_accessor :side
  attr_accessor :view_type
  attr_accessor :webviewDelegate

  def initWithFrame(rect)
    super(rect)
    self.after_init(rect)
    self
  end

  def after_init(rect)
    @webview = WebView.alloc.initWithFrame(rect)
    frameView = @webview.mainFrame.frameView
    frameView.shouldDrawShadow = YES

    @webviewDelegate = FBWebViewDelegate.alloc.init

    @webview.setFrameLoadDelegate(@webviewDelegate)
    @webview.setUIDelegate(@webviewDelegate)
    @webview.setPolicyDelegate(@webviewDelegate)
    @webview.setDrawsBackground(NO)

    self.addSubview(@webview)
    self.setAutoresizingMask(self.resizeMask)
  end

  def setWebScriptObjectWithBlock(block)
    @webviewDelegate.setWebScriptObjectWithBlock(block)
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

  def isFlipped
    YES
  end

  def drawRect(rect)
    NSColor.colorWithPatternImage(NSImage.imageNamed("defaultdesktop.png")).set
    NSRectFill(rect)
  end
end
