//
//  SunPossitionBrain.m
//  Poldi
//
//  Created by admin on 11.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "SunPossitionBrain.h"

@implementation SunPossitionBrain

// clearifying
// circle 360
// middle 180
// middle of the middle 90
// radius 140 = width - 40 / 2
#define ZERO_CIRCLE 0.
#define QUARTER_CIRCLE 90.
#define MIDDLE_CIRCLE 180.
#define THREE_TIMES_QUARTER_CIRCLE 270.
#define COMPLETE_CIRCLE 360.
/*
- (float) findXSunDegree:(float) degree midPointX:(float)midX midPointY:(float)midY withRadius:(float)radius
{    
    float moveTimes = radius / QUARTER_CIRCLE;
    float move = 0.0;
    // 0 -> 0
    // 90 -> 140 (radius)
    if (degree >= ZERO_CIRCLE && degree <= QUARTER_CIRCLE){

        move = degree * moveTimes;
        midX += move;
    }
    // 180 -> 0
    // 90 -> 140 (radius)
    else if (degree > QUARTER_CIRCLE && degree <= MIDDLE_CIRCLE){
        degree -= QUARTER_CIRCLE;
        float temp = QUARTER_CIRCLE - degree;
        move = temp  * moveTimes;
        midX += move;
    
    }
    // 180 <- 0
    // 270 <- 140 (radius)
    else if (degree >= MIDDLE_CIRCLE && degree <= THREE_TIMES_QUARTER_CIRCLE)
    {

        degree -= MIDDLE_CIRCLE;

        move = degree * moveTimes;
        midX -= move;
    }
    //  360 <- 0
    // 270 <- 140 (radius)
    else if (degree > THREE_TIMES_QUARTER_CIRCLE && degree <= COMPLETE_CIRCLE)
    {
        degree -= THREE_TIMES_QUARTER_CIRCLE;
        float temp = QUARTER_CIRCLE - degree;
        move = temp * moveTimes;
        midX -= move;        
    }
     
    return midX;
}

- (float) findYSunDegree:(float) degree midPointX:(float)midX midPointY:(float)midY withRadius:(float)radius
{
    float moveTimes = radius / QUARTER_CIRCLE;
    float move = 0.0;
    //iPhone  midY = 208 - 140; // = 68
    //Logic   midY = 208 - (140) + 70; // 138
    //        midY = 208 - 0;   // = 208
    //        midY = 208 + 140 - 70 = 278
    //        midY = 208 + 140; // = 348
    if (degree >= ZERO_CIRCLE && degree <= QUARTER_CIRCLE){
        move = moveTimes * degree;
        midY = midY - radius + move;
    }
    else if (degree > QUARTER_CIRCLE && degree <= MIDDLE_CIRCLE){
        degree -= QUARTER_CIRCLE;        
        move = moveTimes * degree;
        midY = midY + move;
    }
    else if (degree > MIDDLE_CIRCLE && degree <= THREE_TIMES_QUARTER_CIRCLE){
        degree -= MIDDLE_CIRCLE;
        move = moveTimes * degree;
        midY = midY + radius - move;
    }
    else if (degree > THREE_TIMES_QUARTER_CIRCLE && degree <= COMPLETE_CIRCLE)
    {
        degree -= THREE_TIMES_QUARTER_CIRCLE;
        move = moveTimes * degree;
        midY = midY - move;
    }
    
    NSLog(@"midPointX %f midPointY %f", midX, midY);
    
    return midY;
}
*/

- (CGPoint)pointOnCircle:(int)thisPoint withTotalPointCount:(int)totalPoints withWidth:(float)width andHeight:(float)height andRadius:(float)radius
{
//    NSLog(@"radius %f", radius);
    CGPoint centerPoint = CGPointMake(width / 2, height / 2);
    float angle = ( 2*M_PI / (float)totalPoints ) * (float)thisPoint;
    
    CGPoint newPoint;
    newPoint.x = (centerPoint.x) + (radius * cosf(angle));
    newPoint.y = (centerPoint.y) + (radius * sinf(angle));
//    NSLog(@"point.x %f point.y %f", newPoint.x, newPoint.y);
    return newPoint;

}


@end
