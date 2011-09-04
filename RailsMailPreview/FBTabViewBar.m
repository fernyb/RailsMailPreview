//
//  FBTabViewBar.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/2/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "FBTabViewBar.h"
#import "FBTabViewItem.h"


@implementation FBTabViewBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      trackImage = [[NSImage imageNamed:@"tabTrack.png"] retain];
      tabWidth = 264.0;
      NSSize tabSize = NSMakeSize(tabWidth, CGRectGetHeight(frame));
      
      FBTabViewItem * itemView = [[FBTabViewItem alloc] initWithFrame:NSMakeRect(0, 0, tabSize.width, tabSize.height)];
      
      [itemView setAutoresizingMask:NSViewWidthSizable | NSViewMaxXMargin];
      [itemView setItemIndex:0];
      [itemView setActive:YES];
      [itemView setTitle:@"html"];
      [self addSubview:itemView];
      
      FBTabViewItem * itemViewRight = [[FBTabViewItem alloc] initWithFrame:NSMakeRect(CGRectGetMaxX([itemView frame]), 0, tabSize.width, tabSize.height)];
      
      [itemViewRight setAutoresizingMask:NSViewMinXMargin | NSViewWidthSizable];
      [itemViewRight setItemIndex:1];
      [itemViewRight setActive:NO];
      [itemViewRight setTitle:@"text"];
      [self addSubview:itemViewRight];
      
      [itemView release];
      [itemViewRight release];
    }
    
    return self;
}


- (void)setAllInActive
{
  NSEnumerator * e = [[self subviews] objectEnumerator];
  id aview;
  while(aview = [e nextObject]) {
    if ([[aview className] isEqualToString:@"FBTabViewItem"]) {
      [aview setActive:NO];
      [aview setNeedsDisplay:YES];
    }
  }
}


- (void)drawRect:(NSRect)dirtyRect
{
  NSEnumerator * e = [[self subviews] objectEnumerator];
  id aview;
  
  NSInteger i = 0;
  while(aview = [e nextObject] ) {
    if ([[aview className] isEqualToString:@"FBTabViewItem"]) {
     
      [aview setFrameSize:NSMakeSize(tabWidth, CGRectGetHeight([self frame]))];
      
      if (i == 0) {
        [aview setFrameOrigin:NSMakePoint(CGRectGetMinX([self frame]), 0)];
      } 
      else if (i == 1) {
        [aview setFrameOrigin:NSMakePoint(tabWidth - 18.2, 0)];
      }
      i += 1;
    }
  }
  
 NSDrawThreePartImage([self bounds], trackImage, trackImage, trackImage, NO, NSCompositeSourceOver, 1, NO);
}


- (void)dealloc {
  [trackImage release];
  [super dealloc];
}

@end
