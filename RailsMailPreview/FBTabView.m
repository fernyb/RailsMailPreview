//
//  FBTabView.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "FBTabView.h"
#import "FBTabViewBar.h"


@implementation FBTabView


- (void)awakeFromNib
{
  [(INAppStoreWindow *)[self window] setTitleBarHeight:40];
  INTitlebarView * titleBarView = (INTitlebarView *)[(INAppStoreWindow *)[self window] titleBarView];
  [titleBarView setDelegate:self];
  
  
  NSRect rect = [self frame];
  
  tabviewBar = [[FBTabViewBar alloc] initWithFrame:NSMakeRect(CGRectGetMinX(rect), CGRectGetMaxY(rect), 
                                                              CGRectGetWidth(rect), 23)];
  
  [[self superview] addSubview:tabviewBar];
}


- (NSRect)bottomLineRectForTitleBar:(NSRect)rect
{
  NSRect newRect = rect;
  newRect.size.width = rect.size.width / 2;
  return CGRectZero;
}


- (void)drawRect:(NSRect)dirtyRect
{
  NSRect rect = [self frame];
  [tabviewBar setFrameOrigin:NSMakePoint(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
  [tabviewBar setFrameSize:NSMakeSize(CGRectGetWidth(rect), CGRectGetHeight([tabviewBar frame]))];
  
  [[NSColor greenColor] set];
  NSRectFill([self bounds]);
}


@end
