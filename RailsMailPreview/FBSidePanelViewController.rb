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

  def init
    self.initWithNibName("FBSidePanelView", bundle:NSBundle.mainBundle)
    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector: :"didPressDeleteKey:",
                                                   name: "didPressDeleteKeyNotification",
                                                   object: nil)
    self
  end

  def didPressDeleteKey(notification)
    if self.table.selectedRow >= 0
      selectedRow = self.table.selectedRow
      item = self.items.objectAtIndex(selectedRow)

      self.table.beginUpdates
      self.table.removeRowsAtIndexes(NSIndexSet.indexSetWithIndex(selectedRow), withAnimation:NSTableViewAnimationSlideDown | NSTableViewAnimationEffectFade)
      self.table.endUpdates

      self.items.removeObjectAtIndex(selectedRow)
      Message.delete_at_index(item.id)

      if self.items.size == 0
        NSNotificationCenter.defaultCenter.postNotificationName("NoMessagesToDisplayNotification", object:nil)
      else
        selectedRow -= 1 if selectedRow > (self.items.size - 1)
        self.table.selectRowIndexes(NSIndexSet.indexSetWithIndex(selectedRow), byExtendingSelection:NO)
      end
    end
  end

  def didSaveMessage
    self.items = Message.all
    self.table.window.makeFirstResponder(self.table)

    self.table.beginUpdates
    self.table.insertRowsAtIndexes(NSIndexSet.indexSetWithIndex(0), withAnimation:NSTableViewAnimationSlideDown | NSTableViewAnimationEffectGap)
    self.table.selectRowIndexes(NSIndexSet.indexSetWithIndex(0), byExtendingSelection:NO)
    self.table.endUpdates
  end

  def didSaveAllMessages
    NSNotificationCenter.defaultCenter.postNotificationName("didSaveNewMessage", object:self.items.first)
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


  def htmlview=(v)
    @htmlview = v
    @htmlview.setWebScriptObjectWithBlock(self.webScriptObjectBlock)
  end

  def plainview=(v)
    @plainview = v
    @plainview.setWebScriptObjectWithBlock(self.webScriptObjectBlock)
  end

  def webScriptObjectBlock
    lambda {|webScriptObject, webFrame|
      webScriptObject.setValue(self, forKey: "controller")
      self.respondsToSelector("onRightClickAttachment:type:")
    }
  end


  attr_accessor :onRightClickAttachment
  def onRightClickAttachment(selectedRid, type:type)
    @selected_rid = selectedRid

    menu = NSMenu.alloc.init
    menuItem = NSMenuItem.alloc.init
    menuItem.setTitle("Open Selected Attachment")
    menuItem.setTarget(self)
    menuItem.setAction(:"openAttachmentAction:")
    menu.addItem(menuItem)

    menuItem = NSMenuItem.alloc.init
    menuItem.setTitle("Quick Look Selected Attachment")
    menuItem.setTarget(self)
    menuItem.setAction(:"openAttachmentInQuickLook:")
    menu.addItem(menuItem)

    loc = self.view.window.mouseLocationOutsideOfEventStream
    theWebView = type == "html" ? @htmlview.webview : @plainview.webview

    event = NSEvent.mouseEventWithType(NSRightMouseDown,
                                            location: loc,
                                       modifierFlags: 0,
                                           timestamp: NSDate.date.timeIntervalSince1970,
                                        windowNumber: theWebView.window.windowNumber,
                                             context: NSGraphicsContext.currentContext,
                                         eventNumber: 1,
                                          clickCount: 1,
                                            pressure: 0.0)

    NSMenu.popUpContextMenu(menu, withEvent:event, forView:nil)
  end

  def self.isSelectorExcludedFromWebScript(selector)
    false
  end

  def create_attachments_directory_if_needed
    if !File.exists?(ATTACHMENTS_DIR)
      fm = NSFileManager.defaultManager
      error = Pointer.new("@")
      fm.createDirectoryAtPath("#{ATTACHMENTS_DIR}", withIntermediateDirectories:YES, attributes:nil, error:error)
      if !error[0].nil?
        NSLog("Error trying to create attachments directory")
        abort()
      end
    end
  end

  def openAttachmentInQuickLook(sender)
    self.view.window.contentView.quickLookDataSource = self
    QLPreviewPanel.sharedPreviewPanel.setNextResponder(self.view.window.contentView)

    if QLPreviewPanel.sharedPreviewPanel.isVisible
      QLPreviewPanel.sharedPreviewPanel.orderOut(nil)
    end

    attachment = Attachment.find_by_id(@selected_rid)
    mime_type = attachment.mime_type
    attachment_data = attachment.data.decode64
    create_attachments_directory_if_needed

    filePathURL = NSURL.fileURLWithPath("#{ATTACHMENTS_DIR}/#{attachment.filename}", isDirectory:NO)
    attachment_data.writeToURL(filePathURL, atomically:YES)
    if AppDelegate.development?
      NSLog("Attachment File Path: #{filePathURL.absoluteString}")
    end

    @previewItem = Struct.new(:previewItemURL).new(filePathURL)

    QLPreviewPanel.sharedPreviewPanel.makeKeyAndOrderFront(self)
  end

  def openAttachmentAction(sender)
    attachment = Attachment.find_by_id(@selected_rid)
    mime_type = attachment.mime_type
    attachment_data = attachment.data.decode64
    create_attachments_directory_if_needed

    filePathURL = NSURL.fileURLWithPath("#{ATTACHMENTS_DIR}/#{attachment.filename}", isDirectory:NO)
    if AppDelegate.development?
      NSLog("Attachment File Path: #{filePathURL.absoluteString}")
    end
    attachment_data.writeToURL(filePathURL, atomically:YES)
    NSWorkspace.sharedWorkspace.openURL(filePathURL)
  end

  def tableViewSelectionDidChange(notification)
    row = self.table.selectedRow
    if row >= 0
      item = self.items.objectAtIndex(row)

      self.htmlview.loadHTMLString(generate_html_template(item))
      self.plainview.loadHTMLString(generate_text_template(item))
      NSNotificationCenter.defaultCenter.postNotificationName("loadHTMLString", object:item)
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

  def tidyup(item)
    html = item.html
    attachment_list = Attachment.where(["message_id = ?", item.id])
    
    doc = NSXMLDocument.alloc.initWithXMLString(html.to_s, options:NSXMLDocumentTidyHTML, error:nil)
    if doc
      doc.setDocumentContentKind(NSXMLDocumentHTMLKind)
      nodes = doc.nodesForXPath("//body/*", error:nil)
      
      # Make sure to include background image
      allnodes = doc.nodesForXPath("//body//*", error:nil)
      allnodes.each {|node|
        nodeItem = node.attributeForName("background")
        if nodeItem.nil?
          nodeItem = node.attributeForName("src")
        end
        next if nodeItem.nil?
        
        if nodeItem.objectValue.to_s[0..3].to_s == "cid:"
          content_id = nodeItem.objectValue.to_s[4..-1]
          inline_image = attachment_list.select {|item| item.content_id =~ /#{content_id}/i }.first
          if !inline_image.nil?
            # Set the Image Source
            node.addAttribute(NSXMLNode.attributeWithName(nodeItem.name, stringValue:"data:#{inline_image.mime_type};base64,#{inline_image.data}"))
          end
        end
      }
      
      nodes.map {|node| node.XMLString }.join("")
    else
      ""
    end
  end

  def nl2br(text)
    text.to_s.gsub(/\n|\r/, "<br />")
  end

  def attachments(item, type)
    list = Attachment.where(["message_id = ?", item.id])
    tiles = list.map {|attachment|
      uti = attachment.filename.fileType.objectForKey("uti")
      iconImage = NSWorkspace.sharedWorkspace.iconForFileType(uti)
      imageData64 = iconImage.resizeTo([32.0, 32.0]).TIFFRepresentation.base64

      %Q{
        <div class="attachment_tile">
          <div data-type="#{type}" data-rid="#{attachment.id}">
            <a href="#" onclick="return false;">
              <img src="data:image/tiff;base64,#{imageData64}" class="attachment_icon" />
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

  # QuickLook Data Source Methods
  def numberOfPreviewItemsInPreviewPanel(panel)
    @previewItem ? 1 : 0
  end

  def previewPanel(panel, previewItemAtIndex:idx)
    if idx == 0
      @previewItem
    else
      nil
    end
  end
end
