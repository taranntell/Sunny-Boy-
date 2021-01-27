//
//  HomeView.m
//  Sunny Boy
//
//  Created by Diego Loop on 04.02.13.
//  Copyright (c) 2013 muugs. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView

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
    
    // Drawing code
    CGGradientRef gradient;
    CGColorSpaceRef baseSpace;
//    CGFloat components[12] = {
//        0.4, 0.8, 1.0, 1.0,
//        0.2, 0.4, 0.6, 1.0,
//    };
    
    CGFloat components[8] = {
        0.537, 0.847, 0.858, 1.0,// Start color
        0.2, 0.6, 0.8, 1.0
    }; // End color
    
    size_t num_location = 2;
    CGFloat location[2] = { 0.0,1.0 };
    baseSpace = CGColorSpaceCreateDeviceRGB(); // Just for iOS
    gradient = CGGradientCreateWithColorComponents(baseSpace, components, location, num_location);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    baseSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(baseSpace, components, location, num_location);
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