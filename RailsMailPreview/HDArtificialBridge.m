//
//  HDArtificialBridge.m
//  RailsMailPreview
//
//  Created by Hunter on 11/4/12.
//  Copyright (c) 2012 Fernando Barajas. All rights reserved.
//

#import "HDArtificialBridge.h"

@implementation HDArtificialBridge

-(int)runCGRectGetMaxY:(CGRect) rect
{
    return CGRectGetMaxY(rect);
}


-(int)runCGRectGetMaxX:(CGRect) rect
{
    return CGRectGetMaxX(rect);
}


-(int)runCGRectGetMinY:(CGRect) rect
{
    return CGRectGetMinY(rect);
}


-(int)runCGRectGetMinX:(CGRect) rect
{
    return CGRectGetMinX(rect);
}

@end
