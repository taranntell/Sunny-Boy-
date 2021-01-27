//
//  LocationBrain.m
//  Poldi
//
//  Created by admin on 03.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "LocationBrain.h"
#import "PoldiData.h"

@interface LocationBrain () <CLLocationManagerDelegate>

@property (strong, nonatomic) PoldiData *poldiData;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableArray *orientationLetters;

@end

@implementation LocationBrain

- (PoldiData *)poldiData{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}


- (NSMutableArray *)orientationLetters
{
    if (!_orientationLetters){
        _orientationLetters = [[NSMutableArray alloc] initWithObjects:@"N",@"NNE",@"NE",@"ENE",@"E",@"ESE",@"SE",@"SSE",@"S",@"SSW",@"SW",@"WSW",@"W",@"WNW",@"NW",@"NWW",nil];
    }
    return _orientationLetters;
}

- (NSString *)checkAMOrPM:(float)time
{
    NSString *timeType;
    if (time <= 720 ){
        timeType = @"am";
    }else if (time > 720){
        timeType = @"pm";
    }
    
    return timeType;
}

- (NSString *) findOrienationLetterWithDegrees:(float) degress
{
    int key = 0;

    float orientation = degress;
    
    if (orientation > 348.75 || orientation <= 11.25 ){
        key = 0;
        
    }else if ( orientation > 11.25 && orientation <= 33.75 ){
        key = 1;
        
    }else if ( orientation > 33.75 && orientation <= 56.25 ){
        key = 2;
        
    }else if ( orientation > 56.25 && orientation <= 78.75 ){
        key = 3;
        
    }else if ( orientation > 78.75 && orientation <= 101.25 ){
        key = 4;
        
    }else if ( orientation > 101.25 && orientation <=123.75 ){
        key = 5;
        
    }else if ( orientation > 123.75 && orientation <=146.25 ){
        key = 6;
        
    }else if ( orientation > 146.25 && orientation <=168.75 ){
        key = 7;
        
    }else if ( orientation > 168.75 && orientation <=191.25 ){
        key = 8;
        
    }else if ( orientation > 191.25 && orientation <=213.75 ){
        key = 9;
        
    }else if ( orientation > 213.75 && orientation <=236.25 ){
        key = 10;
        
    }else if ( orientation > 236.25 && orientation <=258.75 ){
        key = 11;
        
    }else if ( orientation > 258.75 && orientation <=281.25 ){
        key = 12;
        
    }else if ( orientation > 281.25 && orientation <=303.75 ){
        key = 13;
        
    }else if ( orientation > 303.75 && orientation <=326.25 ){
        key = 14;
        
    }else if ( orientation > 326.25 && orientation <=348.75 ){
        key = 15;
        
    }
    
    return [self.orientationLetters objectAtIndex:key];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSString *) findOrientationLetterOfDegrees:(float)degrees
{
    NSString *letter;
    
    return letter;
}


#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)
#define RADIANDS_TO_DEGREES(x) (x * 180.0 / M_PI)

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = DEGREES_TO_RADIANS(fromLoc.latitude);
    float fLng = DEGREES_TO_RADIANS(fromLoc.longitude);
    float tLat = DEGREES_TO_RADIANS(toLoc.latitude);
    float tLng = DEGREES_TO_RADIANS(toLoc.longitude);
    
    float degree = RADIANDS_TO_DEGREES(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360 + degree;
    }
}


- (CLLocationDistance) findTravelDistanceOfLocation:(CLLocation *)location
                                      fromNewLocation:(CLLocation *)newLocation
{
    CLLocationDistance distance = [location distanceFromLocation:newLocation];
    return  distance/1000;
}

# define MAX_GRADS 360
# define QUARTER_GRADS 90
- (float) findAzimut:(float)minutes
{
    float azimut = (minutes / MAX_GRADS) * QUARTER_GRADS;
    return azimut;
}

# define CONSTANT_DEGREES_OF_A_YEAR 30.0
# define NORTH_DECLINATION_ANGLE -23.45
# define HUNDERT_EIGHTY_DEGREE 180.0


- (float) findDeclinationAngle:(int)month
{
    float declinationAngle = 0;
    float degree = month * CONSTANT_DEGREES_OF_A_YEAR;
    declinationAngle = NORTH_DECLINATION_ANGLE * cos(degree/HUNDERT_EIGHTY_DEGREE * M_PI);
    return declinationAngle;
}


// Making a linear search, i will find the highest possition of the sun
// from 0 to 1440 min (Maximum minutes per day) depending in the day
# define MINUTES_PER_DAY 1440
# define MINUTES_ON_180_DEGREE 720
- (float) findPercentOfSunWithLatitude:(float)latitude inMonth:(int)month andTime:(float)time
{
    float alpha = [self findSunsPossitionToLocationWithLatitude:latitude dependingOfMonth:month andTime:time];
    
    if (alpha >= 0){
        float gamma = [self findSunsPossitionToLocationWithLatitude:latitude dependingOfMonth:month andTime:MINUTES_ON_180_DEGREE];
        return ( alpha / gamma ) * 100;
        
        
    }else{
        return -1; // 0.0% of sun
    }
}

- (float) findTotalSunsPercent:(float)percentFrom withPercent:(float)percentTo
{
    return (percentFrom + percentTo) / 2;
}


# define NINETY_DEGREE 90.0
# define ELEVATION_HUNDERT_EIGHTY 180.0
- (float) findSunsPossitionFromLocationWithLatitude:(float)latitude dependingOfMonth:(int)month andTime:(float)time
{
    float result = 0.0;
    if ( - ( ( NINETY_DEGREE - latitude ) * cos(ELEVATION_HUNDERT_EIGHTY/ HUNDERT_EIGHTY_DEGREE * M_PI) ) + [self findDeclinationAngle:month] > NINETY_DEGREE )
    {

        result = ( ( NINETY_DEGREE + latitude ) * cos( [self findAzimut:time] / HUNDERT_EIGHTY_DEGREE * M_PI ) ) - [self findDeclinationAngle:month];


    }else {
        result =  - ( ( NINETY_DEGREE - latitude ) * cos( [self findAzimut:time] / HUNDERT_EIGHTY_DEGREE * M_PI ) ) + [self findDeclinationAngle:month];


    }

    [self.poldiData setSunsPossitionFromData:result];
    return result;
}

- (float) findSunsPossitionToLocationWithLatitude:(float)latitude dependingOfMonth:(int)month andTime:(float)time
{
//    NSLog(@"TO latitude %f month %d time %f azimut %f", latitude, month, time, [self findAzimut:time]);
    
    float result = 0.0;
    if ( - ( ( NINETY_DEGREE - latitude ) * cos(ELEVATION_HUNDERT_EIGHTY/ HUNDERT_EIGHTY_DEGREE * M_PI) ) + [self findDeclinationAngle:month] > NINETY_DEGREE )
    {
        
        result = ( ( NINETY_DEGREE + latitude ) * cos( [self findAzimut:time] / HUNDERT_EIGHTY_DEGREE * M_PI ) ) - [self findDeclinationAngle:month];
//        NSLog(@"results %f in", result);
        
    }else {
        result =  - ( ( NINETY_DEGREE - latitude ) * cos( [self findAzimut:time] / HUNDERT_EIGHTY_DEGREE * M_PI ) ) + [self findDeclinationAngle:month];
        
//        NSLog(@"results else %f in", result);
    }
    
    [self.poldiData setSunsPossitionToData:result];
    return result;
    
}

// decresing 15 kmh velocity, latest car_speed 78, slow_train 88.5
# define CAR_SPEED_IN_KM 63
# define SLOW_TRAIN_IN_KM 73.5
# define BUS_SPEED_IN_KM 53
# define RICKSAW_SPEED_IN_KM 8

# define MIN_OF_HOUR 60

// TIME = DISTANCE / SPEED
// DISTANCE = DISTANCE / TIME
- (float) findTravelTimeOfDistance:(CLLocationDistance) distance withTransportType:(int)type
{
    
    float time = 0;
    // Type = 0 -> train
    // Type = 1 -> car
    if (type == 0){
        time = distance / SLOW_TRAIN_IN_KM;
        
    }else if (type == 1){
        time = distance / CAR_SPEED_IN_KM;
        
    }else if (type == 2){
        time = distance / BUS_SPEED_IN_KM;
        
    }else if (type == 3){
        time = distance / RICKSAW_SPEED_IN_KM;  
    }
    
    return (time * MIN_OF_HOUR); // convert total time in minutes
}


- (float) findSunsDegreePossitionWithTime:(float)minutes
{
    if (minutes > 1440){
        minutes -= 1440;
        
    }

    float degrees = (minutes / 360.0) * 90.0;
 
    return  degrees;
}


@end
