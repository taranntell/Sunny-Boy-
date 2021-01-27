//
//  LocationBrain.h
//  Poldi
//
//  Created by admin on 03.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationBrain : NSObject

- (CLLocationDistance) findTravelDistanceOfLocation:(CLLocation *)location
                                      fromNewLocation:(CLLocation *)newLocation;
- (float) findTravelTimeOfDistance:(CLLocationDistance)
distance withTransportType:(int)type;

- (NSString *) findOrientationLetterOfDegrees:(float)degrees;

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc;

- (NSString *) findOrienationLetterWithDegrees:(float) degress;

- (float) findSunsPossitionFromLocationWithLatitude:(float)latitude dependingOfMonth:(int)month andTime:(float)time;

- (float) findSunsPossitionToLocationWithLatitude:(float)latitude dependingOfMonth:(int)month andTime:(float)time;

- (float) findPercentOfSunWithLatitude:(float)latitude inMonth:(int)month andTime:(float)time;

- (float) findTotalSunsPercent:(float)percentFrom withPercent:(float)percentTo;


- (float) findSunsDegreePossitionWithTime:(float)minutes;

- (NSString *)checkAMOrPM:(float)time;
@end
