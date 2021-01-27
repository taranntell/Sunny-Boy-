//
//  ColorfulButton.m
//  Poldi
//
//  Created by admin on 09.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "ColorfulButton.h"

@implementation ColorfulButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.725, 0.854, 0.858	, 1.0,
        0.4, 0.8, 0.8, 1.0 };
    
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB(); // Just for iOS
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
}


@end
