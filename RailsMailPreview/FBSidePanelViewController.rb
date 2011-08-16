#
#  FBSidePanelViewController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/15/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class FBSidePanelViewController < NSViewController
  attr_accessor :table

  def items
    %W(zero one two three four)
  end

  # - (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
  def numberOfRowsInTableView(aTableView)
    5
  end

  # - (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
  def tableView(tableView, viewForTableColumn:tableColumn, row:row)
    cell = tableView.makeViewWithIdentifier(tableColumn.identifier, owner:self)
    cell.from     = "fernyb@fernyb.net"
    cell.subject  = "Rails Mail Preview"
    cell.date     = "8/16/11"
    cell.brief    = "This is one of the best app for a Rails frontend developer"
    cell
  end

  # - (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
  def tableView(tableView, rowViewForRow:row)
    rowView = FBSidePanelTableRowView.alloc.initWithFrame(CGRectZero)
    rowView
  end

  # - (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
  def tableView(tableView, heightOfRow:row)
    64 + 8
  end
end
