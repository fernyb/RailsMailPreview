//
//  HDArtificialBridge.h
//  RailsMailPreview
//
//  Created by Hunter on 11/4/12.
//  Copyright (c) 2012 Fernando Barajas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>


@interface HDArtificialBridge : NSObject

+(int)runCGRectGetMaxY:(CGRect) rect;
+(int)runCGRectGetMaxX:(CGRect) rect;
+(int)runCGRectGetMinY:(CGRect) rect;
+(int)runCGRectGetMinX:(CGRect) rect;

@end
