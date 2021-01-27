//
//  SunPossitionBrain.h
//  Poldi
//
//  Created by admin on 11.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunPossitionBrain : NSObject

/* Not working properly
- (float) findXSunDegree:(float) degree midPointX:(float)midX midPointY:(float)midY withRadius:(float) radius;
- (float) findYSunDegree:(float) degree midPointX:(float)midX midPointY:(float)midY withRadius:(float) radius;
*/
- (CGPoint)pointOnCircle:(int)thisPoint withTotalPointCount:(int)totalPoints withWidth:(float)width andHeight:(float)height andRadius:(float)radius;

@end
