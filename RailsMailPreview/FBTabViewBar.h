//
//  FBTabViewBar.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/2/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FBTabViewItem;

@interface FBTabViewBar : NSView
{
  NSImage * trackImage;
  CGFloat tabWidth;
}

@property(readonly) NSMutableArray * tabs;

- (void)setAllInActive;
- (NSInteger)selectedTabIndex;
- (void)selectTabAtIndex:(NSInteger)idx;
- (CGFloat)animationDuration;

- (void)addTabViewItem:(FBTabViewItem *)tabItem;

- (FBTabViewItem *)tabViewItemAtIndex:(NSInteger)idx;
- (void)setHideTabAtIndex:(NSInteger)idx;
- (void)setShowTabAtIndex:(NSInteger)idx;

@end
