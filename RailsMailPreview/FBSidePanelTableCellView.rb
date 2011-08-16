#
#  FBSidePanelTableCellView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/15/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class FBSidePanelTableCellView < NSTableCellView
  FIELDS = [:from, :subject, :date, :brief]

  def defaultFont(opts={})
    font_name = "Lucida Grande"
    font_name << " Bold" if opts[:bold] == true
    font_size = 11.0
    font_size = opts[:size] unless opts[:size].nil?
    NSFont.fontWithName(font_name, size:font_size)
  end

  def width
    CGRectGetWidth(self.frame)
  end

  def awakeFromNib
    @from_field = NSTextField.alloc.initWithFrame([0, 3, self.width - 101, 16])
    @from_field.setBezeled(NO)
    @from_field.setEditable(NO)
    @from_field.setFont(self.defaultFont(bold:true))
    @from_field.setBackgroundColor(NSColor.clearColor)
    self.addSubview(@from_field)

    @date_field = NSTextField.alloc.initWithFrame([1 + CGRectGetMaxX(@from_field.frame), 3, 56, 16])
    @date_field.setBezeled(NO)
    @date_field.setEditable(NO)
    @date_field.setFont(self.defaultFont)
    @date_field.setAlignment(NSRightTextAlignment)
    @date_field.setTextColor(NSColor.colorWithCalibratedRed(0.069, green:0.326, blue:0.901, alpha:1.00))
    @date_field.setBackgroundColor(NSColor.clearColor)
    self.addSubview(@date_field)

    @subject_field = NSTextField.alloc.initWithFrame([0, 1 + CGRectGetMaxY(@from_field.frame), self.width, 16])
    @subject_field.setBezeled(NO)
    @subject_field.setEditable(NO)
    @subject_field.setFont(self.defaultFont)
    @subject_field.setBackgroundColor(NSColor.clearColor)
    self.addSubview(@subject_field)

    @brief_field = NSTextField.alloc.initWithFrame([0, 1 + CGRectGetMaxY(@subject_field.frame), self.width, 32])
    @brief_field.setBezeled(NO)
    @brief_field.setEditable(NO)
    @brief_field.setFont(self.defaultFont)
    @brief_field.setBackgroundColor(NSColor.clearColor)
    @brief_field.setTextColor(NSColor.colorWithCalibratedWhite(0.298, alpha:1.00))
    self.addSubview(@brief_field)
  end

  FIELDS.each do |f|
    define_method "#{f}=" do |val|
      var = instance_variable_get("@#{f}_field")
      var.setStringValue(val) unless var.nil?
    end

    define_method "#{f}" do
      var = instance_variable_get("@#{f}_field")
      var.stringValue unless var.nil?
    end
  end

  def isFlipped
    YES
  end
end
