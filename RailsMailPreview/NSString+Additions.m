//
//  NSString+Additions.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/23/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (NSString_Additions)

- (NSDictionary *)fileType
{
  NSString * uti = [NSMakeCollectable(UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                            (CFStringRef)[self pathExtension],
                                                                            NULL)) autorelease];
  
  NSString * mimeType = [NSMakeCollectable(UTTypeCopyPreferredTagWithClass((CFStringRef)uti, kUTTagClassMIMEType)) autorelease];
  
  return [NSDictionary dictionaryWithObjectsAndKeys:uti, @"uti", mimeType, @"mimeType", nil];
}

@end
