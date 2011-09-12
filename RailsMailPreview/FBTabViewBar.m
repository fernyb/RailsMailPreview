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
@synthesize tabs;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      trackImage = [[NSImage imageNamed:@"tabTrack.png"] retain];
      trackImageBlur = [[NSImage imageNamed:@"track_blur.png"] retain];
      
      tabWidth = 264.0;
      
      NSSize tabSize = NSMakeSize(tabWidth, CGRectGetHeight(frame));

      FBTabViewItem * itemView = [[FBTabViewItem alloc] initWithFrame:NSMakeRect(0, 0, tabSize.width, tabSize.height)];
      [itemView setAutoresizingMask:NSViewWidthSizable | NSViewMaxXMargin];
      [itemView setItemIndex:0];
      [itemView setActive:YES];
      [itemView setTitle:@"html"];
      [self addTabViewItem:itemView];

      FBTabViewItem * itemViewRight = [[FBTabViewItem alloc] initWithFrame:NSMakeRect(CGRectGetMaxX([itemView frame]), 0, tabSize.width, tabSize.height)];

      [itemViewRight setAutoresizingMask:NSViewMinXMargin | NSViewWidthSizable];
      [itemViewRight setItemIndex:1];
      [itemViewRight setActive:NO];
      [itemViewRight setTitle:@"text"];
      [self addTabViewItem:itemViewRight];

      [itemView release];
      [itemViewRight release];
    }

    return self;
}

- (void)addTabViewItem:(FBTabViewItem *)tabItem
{
  [self addSubview:tabItem];
}

- (void)setAllInActive
{
  NSEnumerator * e = [[self subviews] objectEnumerator];
  id aview;
  while(aview = [e nextObject]) {
    if ([[aview className] isEqualToString:@"FBTabViewItem"]) {
      [aview setActive:NO];
    }
  }
}

- (NSInteger)selectedTabIndex
{
  NSEnumerator * e = [[self subviews] objectEnumerator];
  id aview;
  while(aview = [e nextObject]) {
    if ([[aview className] isEqualToString:@"FBTabViewItem"]) {
      if ([aview active]) {
        return [aview itemIndex];
      }
    }
  }
  return NSNotFound;
}


- (void)selectTabAtIndex:(NSInteger)idx
{
  [self setAllInActive];
  FBTabViewItem * tabItem = [self tabViewItemAtIndex:idx];
  [tabItem setHidden:NO];
  [tabItem setActive:YES];
  [tabItem setNeedsDisplay:YES];
  [self setNeedsDisplay:YES];
}

- (FBTabViewItem *)tabViewItemAtIndex:(NSInteger)idx
{
  NSEnumerator * e = [[self subviews] objectEnumerator];
  id aview;
  NSInteger i = 0;
  while (aview = [e nextObject]) {
    if ([[aview className] isEqualToString:@"FBTabViewItem"]) {
      if (i == idx) {
        return (FBTabViewItem *)aview;
      }
      i += 1;
    }
  }
  return nil;
}

- (void)setHideTabAtIndex:(NSInteger)idx
{
  FBTabViewItem * tabItem = [self tabViewItemAtIndex:idx];
  [tabItem setFrameOrigin:NSMakePoint(CGRectGetMinX([self frame]) - tabWidth, 0)];
  [tabItem setHidden:YES];
  [tabItem setNeedsDisplay:YES];
}

- (void)setShowTabAtIndex:(NSInteger)idx
{
  FBTabViewItem * tabItem = [self tabViewItemAtIndex:idx];
  [tabItem setHidden:NO];
  [tabItem setNeedsDisplay:YES];
}

- (CGFloat)animationDuration
{
  return 0.12;
}

- (void)viewWillDraw
{
  NSEnumerator * e = [[self subviews] objectEnumerator];
  FBTabViewItem * tabItem;
  
  NSInteger i = 0;
  
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:[self animationDuration]];
  
  while(tabItem = [e nextObject] ) {
    if (![[tabItem className] isEqualToString:@"FBTabViewItem"]) {
      continue;
    }
    if ([tabItem isHidden]) {
      continue;
    }
    
    [tabItem setFrameSize:NSMakeSize(tabWidth, CGRectGetHeight([self frame]))];

    CGFloat originX = CGRectGetMinX([self frame]) + (tabWidth * i);
    
    if(i > 0) {
      originX -= 18.2;
    }
    
    [[tabItem animator] setFrameOrigin:NSMakePoint(floor(originX), 0.0)];
  
    i += 1;
  }
  [NSAnimationContext endGrouping];
}


- (void)drawRect:(NSRect)dirtyRect
{ 
  if ([self drawAsMain]) {
    NSDrawThreePartImage([self bounds], trackImage, trackImage, trackImage, NO, NSCompositeSourceOver, 1, NO);
  }
  else {
    NSDrawThreePartImage([self bounds], trackImageBlur, trackImageBlur, trackImageBlur, NO, NSCompositeSourceOver, 1, NO);
  }
}

- (BOOL)drawAsMain
{
  return ([[self window] isMainWindow] && [[NSApplication sharedApplication] isActive]);  
} 



- (void)dealloc {
  [trackImage release];
  [trackImageBlur release];
  [super dealloc];
}

@end
