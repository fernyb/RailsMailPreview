#
#  FBSidePanelTableRowView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/16/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class FBSidePanelTableRowView < NSTableRowView
  def drawBackgroundInRect(rect)
    cellview = viewAtColumn(0)

    if self.window.isKeyWindow
      if self.window.firstResponder.className == "NSTableView"
        cellview.selected = isSelected
      else
        cellview.selected = NO
      end
    elsif self.window.firstResponder.className == "NSTableView"
      cellview.selected = NO
    end

    super(rect)
  end
end
