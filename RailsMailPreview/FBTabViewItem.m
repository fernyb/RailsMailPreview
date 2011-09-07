//
//  FBTabViewItem.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//


#import "FBTabViewItem.h"
#import "FBTabViewBar.h"


@implementation FBTabViewItem
@synthesize active;
@synthesize itemIndex;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    leftImage   = [[NSImage imageNamed:@"tabLeftCap.png"] retain];
    centerImage = [[NSImage imageNamed:@"tabCenter.png"] retain];
    rightImage  = [[NSImage imageNamed:@"tabRightCap.png"] retain];

    leftImageInActive   = [[NSImage imageNamed:@"tabLeftCapInActive.png"] retain];
    centerImageInActive = [[NSImage imageNamed:@"tabCenterCapInActive.png"] retain];
    rightImageInActive  = [[NSImage imageNamed:@"tabRightCapInActive.png"] retain];
    
    leftImageBlur   = [[NSImage imageNamed:@"lc_blur.png"] retain];
    centerImageBlur = [[NSImage imageNamed:@"center_blur.png"] retain];
    rightImageBlur  = [[NSImage imageNamed:@"rc_blur.png"] retain];
    
    leftImageBlurIA   = [[NSImage imageNamed:@"lc_ia_blur.png"] retain];
    centerImageBlurIA = [[NSImage imageNamed:@"center_ia_blur.png"] retain];
    rightImageBlurIA  = [[NSImage imageNamed:@"rc_ia_blur.png"] retain];
    

    titleField  = [[NSTextField alloc] initWithFrame:NSMakeRect(15, 1, 
                                                                CGRectGetWidth(frame) - 32, 
                                                                CGRectGetHeight(frame) - 4)];
    [titleField setEditable:NO];
    [titleField setSelectable:NO];
    [titleField setBezeled:NO];
    [titleField setDrawsBackground:NO];
    [titleField setAutoresizingMask:NSViewMaxXMargin | NSViewWidthSizable];
    [titleField setAlignment:NSCenterTextAlignment];
    [titleField setFont:[NSFont boldSystemFontOfSize:12.0]];
    [[titleField cell] setBackgroundStyle:NSBackgroundStyleRaised];

    [self addSubview:titleField];
  }
  return self;
}

- (void)setTitle:(NSString *)aTitle
{
  [titleField setStringValue:aTitle];
}

- (NSString *)title
{
  return [titleField stringValue];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
  return YES;
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
  [(FBTabViewBar *)[self superview] setAllInActive];
  [self setActive:YES];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"FBTabViewItemDidChange" object:self];
  [(FBTabViewBar *)[self superview] setNeedsDisplay:YES];
  [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
  
  if ([self drawAsMain]) 
  {
    if ([self active]) {
      NSDrawThreePartImage([self bounds], leftImage, centerImage, rightImage, NO, NSCompositeSourceOver, 1, NO);
    } 
    else {
      if (itemIndex == 0) {
        NSDrawThreePartImage([self bounds], leftImageInActive, centerImageInActive, centerImageInActive, NO, NSCompositeSourceOver, 1, NO);
      }
      else if (itemIndex == 1) {
        NSDrawThreePartImage([self bounds], centerImageInActive, centerImageInActive, rightImageInActive, NO, NSCompositeSourceOver, 1, NO);
      }
    }
  }
  else {
    if ([self active]) {
      NSDrawThreePartImage([self bounds], leftImageBlur, centerImageBlur, rightImageBlur, NO, NSCompositeSourceOver, 1, NO);
    } 
    else {
      
      if (itemIndex == 0) {
        NSDrawThreePartImage([self bounds], leftImageBlurIA, centerImageBlurIA, centerImageBlurIA, NO, NSCompositeSourceOver, 1, NO);
      }
      else if (itemIndex == 1) {
       NSDrawThreePartImage([self bounds], centerImageInActive, centerImageInActive, rightImageBlurIA, NO, NSCompositeSourceOver, 1, NO); 
      }
    }
  }
}


- (BOOL)drawAsMain
{
  return ([[self window] isMainWindow] && [[NSApplication sharedApplication] isActive]);  
} 


- (void)dealloc {
  [leftImageInActive release];
  [centerImageInActive release];
  [rightImageInActive release];

  [leftImageBlur release];
  [centerImageBlur release];
  [rightImageBlur release];
  
  [leftImageBlurIA release];  
  [centerImageBlurIA release];
  [rightImageBlurIA release];
  
  
  [leftImage release];
  [centerImage release];
  [rightImage release];
  [titleField release];
  [super dealloc];
}

@end
