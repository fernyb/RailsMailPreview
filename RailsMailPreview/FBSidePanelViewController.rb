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
    rowView = tableView.rowViewAtRow(row, makeIfNecessary:YES)
    if rowView.nil?
      rowView = FBSidePanelTableRowView.alloc.initWithFrame(CGRectZero)
    end
    rowView
  end

  # - (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
  def tableView(tableView, heightOfRow:row)
    64 + 8
  end

  # - (void)tableViewSelectionDidChange:(NSNotification *)aNotification
  def tableViewSelectionDidChange(aNotification)
    row = @table.selectedRow
    return if row == NSNotFound
  end

  # - (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
  def tableView(tableView, shouldSelectRow:row)
    selected_row = tableView.selectedRow
    if selected_row >= 0
      rowView = tableView.viewAtColumn(0, row:selected_row, makeIfNecessary:YES)
      rowView.selected = false
      rowView.setNeedsDisplay(YES)
    end

    if row >= 0
      rowView = tableView.viewAtColumn(0, row:row, makeIfNecessary:YES)
      rowView.selected = true
      rowView.setNeedsDisplay(YES)
      YES
    else
      NO
    end
  end
end
