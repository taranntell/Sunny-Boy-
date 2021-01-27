//
//  CompassView.h
//  Poldi
//
//  Created by admin on 09.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompassView : UIView


@property (nonatomic) float sunDegreePossition;
@property (nonatomic) float sunDegreeEndPossition;
@property (nonatomic) float scale; // 0 -> day, 0.5 -> almost night, 1 -> night

- (void) findSunPossition:(float) sunPossition endSunPossition:(float)endPossition sunScale:(float)scale;


@end
