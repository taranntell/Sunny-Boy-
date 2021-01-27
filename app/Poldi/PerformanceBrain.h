//
//  PerformanceBrain.h
//  Poldi
//
//  Created by admin on 07.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceBrain : NSObject

- (float) findInterpolationLatitude0: (float)l0 latitude1:(float)l1 time0:(float)t0 time1:(float)t1 time:(float)t;

- (float) findMirrorDegreesOfSunPossition:(float)startSunPossition;

- (int) findSeatWithSunPossition:(float)sunPossition withMirrorSunPossition:(float)mirrorPossition andDestination:(float)destination;

- (int) checkMirrorTimeOfSunAngleBetweenLatitude23andMinus23:(float)latitude inMonth:(int)month withTime:(int)time;
@end
