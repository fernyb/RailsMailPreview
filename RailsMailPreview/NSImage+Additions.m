//
//  NSImage+Additions.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/23/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "NSImage+Additions.h"

@implementation NSImage (NSImage_Additions)

- (NSImage *)resizeTo:(NSSize)aSize
{
  NSImage * resizedImage = [[NSImage alloc] initWithSize:NSMakeSize(aSize.width, aSize.height)];
  [resizedImage lockFocus];
  [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
  [self drawInRect: NSMakeRect(0, 0, aSize.width, aSize.height) 
          fromRect: NSMakeRect(0, 0, [self size].width, [self size].height) 
         operation: NSCompositeSourceOver 
          fraction: 1.0];
  [resizedImage unlockFocus];
  
  return [resizedImage autorelease];  
}

@end
