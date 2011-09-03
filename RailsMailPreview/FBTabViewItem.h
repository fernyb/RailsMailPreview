//
//  FBTabViewItem.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FBTabViewItem : NSView
{
  NSImage * leftImage;
  NSImage * centerImage;
  NSImage * rightImage;
  
  NSImage * leftImageInActive;
  NSImage * centerImageInActive;
  NSImage * rightImageInActive;
  
  BOOL active;
  NSTextField * titleField;
  NSInteger itemIndex;
}

@property(assign) BOOL active;
@property(assign) NSInteger itemIndex;

- (void)setTitle:(NSString *)aTitle;
- (NSString *)title;

@end
