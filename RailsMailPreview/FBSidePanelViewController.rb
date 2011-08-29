#
#  FBSidePanelViewController.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/15/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class FBSidePanelViewController < NSViewController
  attr_accessor :table
  attr_accessor :items
  attr_accessor :htmlview
  attr_accessor :plainview

  def saveNewMessage(mail)
    message = Message.new
    message.setMessage(mail)
    if message.save
      NSLog("*** Message Saved")
    else
      NSLog("*** Message did not save")
    end

    self.items = Message.all
    self.table.reloadData
  end

  def items
    if @items.nil?
      self.items = Message.all
    else
      @items
    end
  end

  # - (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
  def numberOfRowsInTableView(aTableView)
    self.items.size
  end

  # - (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
  def tableView(tableView, rowViewForRow:row)
    FBSidePanelTableRowView.new
  end

  # - (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
  def tableView(tableView, viewForTableColumn:tableColumn, row:row)
    cell = tableView.makeViewWithIdentifier(tableColumn.identifier, owner:self)
    item = self.items.objectAtIndex(row)
    cell.from     = item.from
    cell.subject  = item.subject
    cell.date     = item.date
    cell.brief    = item.brief
    cell.selected = false
    cell
  end

  # - (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
  def tableView(tableView, heightOfRow:row)
    64 + 8
  end

  def tableViewSelectionDidChange(notification)
    row = self.table.selectedRow
    if row >= 0
      item = self.items.objectAtIndex(row)

      self.htmlview.loadHTMLString(generate_html_template(item))
      self.plainview.loadHTMLString(generate_text_template(item))
      NSNotificationCenter.defaultCenter.postNotificationName("loadHTMLString", object:nil)
    end
  end

  def generate_html_template(item)
    self.generateTemplate("message.html", withItem:item)
  end

  def generate_text_template(item)
    self.generateTemplate("message.text", withItem:item)
  end

  def render_stylesheet
    css_path = NSBundle.mainBundle.pathForResource("style", ofType:"css")
    %Q{<link href="file://#{css_path}" rel="stylesheet" type="text/css">}
  end

  def render_javascript
    %W(jquery application).map {|name|
      js_path = NSBundle.mainBundle.pathForResource(name, ofType:"js")
      %Q{<script src="file://#{js_path}" type="text/javascript"></script>}
    }.join("\n")
  end

  def render_header(item)
    self.generateTemplate("_header.html", withItem:item)
  end

  def generateTemplate(template_name, withItem:item)
    template_path = NSBundle.mainBundle.pathForResource(template_name, ofType:"erb")
    template = File.open(template_path) {|f| f.read }
    rhtml = ERB.new(template)
    rhtml.result(binding)
  end

  def collect_emails(addresses)
    emails = addresses.to_s.split(",").map {|addr|
      %Q{<span class="email">#{addr.strip}</span>}
    }.join(",")
    %Q{<span class="email-address">#{emails}</span>}
  end

  def tidyup(html)
    doc = NSXMLDocument.alloc.initWithXMLString(html, options:NSXMLDocumentTidyHTML, error:nil)
    doc.setDocumentContentKind(NSXMLDocumentHTMLKind)
    nodes = doc.nodesForXPath("//body/*", error:nil)
    nodes.map {|node| node.XMLString }.join("")
  end

  def nl2br(text)
    text.to_s.gsub(/\n|\r/, "<br />")
  end

  def attachments(item)
    list = Attachment.where(["message_id = ?", item.id])
    tiles = list.map {|attachment|
      uti = attachment.filename.fileType.objectForKey("uti")
      iconImage = NSWorkspace.sharedWorkspace.iconForFileType(uti)
      imageData64 = iconImage.resizeTo([32.0, 32.0]).TIFFRepresentation.base64

      %Q{
        <div class="attachment_tile">
          <div>
            <a href="#" onclick="return false;">
              <img src="data:image/icns;base64,#{imageData64}" class="attachment_icon" />
              <div>#{attachment.filename}</div>
            </a>
          </div>
        </div>
      }
    }.join("")
    if tiles != ""
      %Q{<div id="attachments">#{tiles}</div>}
    end
  end
end
