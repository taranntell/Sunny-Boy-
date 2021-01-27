//
//  PoldiView.m
//  Sunny Boy
//
//  Created by admin on 03.12.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "PoldiView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PoldiView

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
    
    CGFloat components[8] = {
        0.729, 0.737, 0.737, 1.0,
        0.933, 0.933, 0.933, 1.0,

    };
    
    
    CGGradientRef gradient;
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat location [2] = {0.5, 0.1};
    int num_location = 3;

    gradient = CGGradientCreateWithColorComponents(baseSpace, components, location, num_location);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
//    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxX(rect));
//    CGPoint startPoint;
//    CGPoint endPoint;
//    startPoint.x = 0.0;
//    startPoint.y = 0.0;
//    endPoint.x = 1.0;
//    endPoint.y = 1.0;
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//    CGContextDrawRadialGradient(context, gradient, startPoint, 0, endPoint, gradRadius, kCGGradientDrawsAfterEndLocation);
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);

}


@end
