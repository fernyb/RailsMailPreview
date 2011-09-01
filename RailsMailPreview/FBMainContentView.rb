#
#  FBMainContentView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 9/1/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBMainContentView < NSView
  attr_accessor :quickLookDataSource

  def quickLookDataSource=(v)
    if @quickLookDataSource != v
      @quickLookDataSource = v
    end
  end

  def acceptsPreviewPanelControl(panel)
    YES
  end

  def beginPreviewPanelControl(panel)
    if self.quickLookDataSource
      QLPreviewPanel.sharedPreviewPanel.setDataSource(self.quickLookDataSource)
    end
  end

  def endPreviewPanelControl(panel)
  end
end
