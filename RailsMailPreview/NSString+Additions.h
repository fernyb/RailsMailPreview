//
//  NSString+Additions.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/23/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Additions)

- (NSDictionary *)fileType;
- (NSData *)decode64;
- (NSString *)flattenHTML;

@end
