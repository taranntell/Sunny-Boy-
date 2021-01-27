//
//  PoldiData.m
//  Poldi
//
//  Created by admin on 03.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "PoldiData.h"

@implementation PoldiData

+ (PoldiData *) sharedPoldiData
{
    static PoldiData *sharedPoldiData;
    @synchronized(self){
        if (!sharedPoldiData){
            sharedPoldiData = [[PoldiData alloc] init];
        }
        return sharedPoldiData;
    }
}

float fromLocationLatitudeCoordinatesData;
float fromLocationLongitudeCoordinatesData;
float toLocationLatitudeCoordinatesData;
float toLocationLongitudeCoordinatesData;
float viaLocationLatitudeCoordinatesData;
float viaLocationLongitudeCoordinatesData;
int monthData;
float minutesData;
float sunsPossitionFromData;
float sunsPossitionToData;
float sunsPossitionViaData;
float totalSunPercentData;
float tripDirectionData;
float startSunsPossitionData;
float endSunsPossitionData;
NSString *fromLocationData;
NSString *toLocationData;
NSString *timeData;
float fromSunInclinationData;
float toSunInclinationData;
float totalTimeTravelMinutesData;
float trainWindowSeatLeftFront;
float trainWindowSeatLeftBack;
float trainWindowSeatRightFront;
float trainWindowSeatRightBack;


- (void) setFromLocationLatitudeCoordinatesData: (float)fromLocationLatitudeCoordinates
{
    fromLocationLatitudeCoordinatesData = fromLocationLatitudeCoordinates;
}

- (float)fromLocationLatitudeCoordinatesData
{
    return fromLocationLatitudeCoordinatesData;
}

- (void) setFromLocationLongitudeCoordinatesData: (float)fromLocationLongitudeCoordinates
{
    fromLocationLongitudeCoordinatesData = fromLocationLongitudeCoordinates;
}

- (float)fromLocationLongitudeCoordinatesData
{
    return fromLocationLongitudeCoordinatesData;
}

- (void) setToLocationLatitudeCoordinatesData: (float)toLocationLatitudeCoordinates
{
    toLocationLatitudeCoordinatesData = toLocationLatitudeCoordinates;
}

- (float)toLocationLatitudeCoordinatesData
{
    return toLocationLatitudeCoordinatesData;
}

- (void) setToLocationLongitudeCoordinatesData: (float)toLocationLongitudeCoordinates
{
    toLocationLongitudeCoordinatesData = toLocationLongitudeCoordinates;
}

- (float)toLocationLongitudeCoordinatesData
{
    return toLocationLongitudeCoordinatesData;
}

- (void) setViaLocationLatitudeCoordinatesData: (float)viaLocationLatitudeCoordinates
{
    viaLocationLatitudeCoordinatesData = viaLocationLatitudeCoordinates;
}

- (float)viaLocationLatitudeCoordinatesData;
{
    return viaLocationLatitudeCoordinatesData;
}

- (void) setViaLocationLongitudeCoordinatesData: (float)viaLocationLongitudeCoordinates;
{
    viaLocationLongitudeCoordinatesData = viaLocationLongitudeCoordinates;
}

- (float)viaLocationLongitudeCoordinatesData
{
    return viaLocationLongitudeCoordinatesData;
}

- (void) setMonthData: (int) month
{
    monthData = month;
}

- (int) monthData
{
    return monthData;
}

- (void) setMinutesData: (float)minutes
{
    minutesData = minutes;
}

- (float)minutesData
{
    return minutesData;
}

- (void) setSunsPossitionFromData:(float)possition
{
    sunsPossitionFromData = possition;
}

- (float)sunsPossitionFromData
{
    return sunsPossitionFromData;
}

- (void) setSunsPossitionToData:(float)possition
{
    sunsPossitionToData = possition;
}

- (float)sunsPossitionToData
{
    return sunsPossitionToData;
}

- (void) setSunsPossitionViaData:(float)possition
{
    sunsPossitionViaData = possition;
}

- (float)sunsPossitionViaData
{
    return sunsPossitionViaData;
}

- (void) setTotalSunPercentData:(float)percent
{
    totalSunPercentData = percent;
}

- (float) totalSunPercentData
{
    return totalSunPercentData;
}

- (void) setTripDirectionData:(float)tripDirection
{
    tripDirectionData = tripDirection;
}

- (float) tripDirectionData
{
    return tripDirectionData;
}

- (void) setStartSunsPossitionData:(float)startPossition
{
    startSunsPossitionData = startPossition;
}

- (float) startSunsPossitionData
{
    return startSunsPossitionData;
}

- (void) setEndSunsPossitionData:(float)endPossition
{
    endSunsPossitionData = endPossition;
}

- (float) endSunsPossitionData
{
    return endSunsPossitionData;
}

- (void) setFromLocationData: (NSString *)fromLocation
{
    fromLocationData = fromLocation;
}

- (NSString *) fromLocationData
{
    return fromLocationData;
}

- (void) setToLocationData: (NSString *)toLocation
{
    toLocationData = toLocation;
}

- (NSString *) toLocationData
{
    return toLocationData;
}

- (void) setTimeData:(NSString *)time
{
    timeData = time;

}

- (NSString *) timeData;
{
    return timeData;
}


- (void) setFromSunInclinationData:(float)sunInclination
{
    fromSunInclinationData = sunInclination;

}

- (float)fromSunInclinationData
{
    if (!fromSunInclinationData){
        fromSunInclinationData = 21;
    }
    return fromSunInclinationData;
}

- (void) setToSunInclinationData:(float)sunInclination
{
    toSunInclinationData = sunInclination;
}

- (float)toSunInclinationData
{
    return toSunInclinationData;
}

- (void)setTotalTimeTravelMinutesData:(float)totalTime
{
    totalTimeTravelMinutesData = totalTime;
}

- (float)totalTimeTravelMinutesData
{
    return totalTimeTravelMinutesData;
}

- (void) setTrainWindowSeatLeftFront:(float)times
{
    trainWindowSeatLeftFront = times;
}
- (float)trainWindowSeatLeftFront
{
    return trainWindowSeatLeftFront;
}

- (void) setTrainWindowSeatLeftBack:(float)times
{
    trainWindowSeatLeftBack = times;
}

- (float)trainWindowSeatLeftBack
{
    return trainWindowSeatLeftBack;
}

- (void) setTrainWindowSeatRightFront:(float)times
{
    trainWindowSeatRightFront = times;
}

- (float)trainWindowSeatRightFront
{
    return trainWindowSeatRightFront;
}

- (void) setTrainWindowSeatRightBack:(float)times
{
    trainWindowSeatRightBack = times;
}


- (float)trainWindowSeatRightBack
{
    return trainWindowSeatRightBack;
}











@end
