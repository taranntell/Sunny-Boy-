//
//  PoldiData.h
//  Poldi
//
//  Created by admin on 03.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoldiData : NSObject

+ (PoldiData *) sharedPoldiData;

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FROM_COORDINATE_LAT @"ProfileFromLocationViewController.FromCoordinateLatitude"
#define FROM_COORDINATE_LON @"ProfileFromLocationViewController.FromCoordinateLongitud"
#define TO_COORDINATE_LAT @"ProfileFromLocationViewController.ToCoordinateLatitude"
#define TO_COORDINATE_LON @"ProfileFromLocationViewController.ToCoordinateLongitud"

#define AD_WIDTH 320
#define AD_HEIGHT 50

#define LINE_BORDER 0.5

/******** Sunny predefined colors ******************/
#define sunnyyellow UIColorFromRGB(0xFEC328)
#define sunnydarkblue UIColorFromRGB(0x3077a8)
#define sunnyblue UIColorFromRGB(0x3399CC)
#define sunnydarklightgray UIColorFromRGB(0x888888)
#define sunnydarkgray UIColorFromRGB(0x555555)
#define sunnygreen UIColorFromRGB(0xa7ffcc)
#define sunnylightgray UIColorFromRGB(0xdddddd)
#define sunnyblack UIColorFromRGB(0x000000)
#define sunnywhite UIColorFromRGB(0xffffff)
#define sunnygray UIColorFromRGB(0x808080)
#define sunnylightyellow UIColorFromRGB(0xFDF2C8)

/*
 * Three different ranges
 * sunnig > 20
 * almost night < 20 && > -20
 * night < -20
 */
#define ALREADY_LANCHED @"PerformanceViewController.AlreadyLanchedKey"
#define FROM_LATITUDE_KEY @"ProfileFromLocationViewController.FromLatitudeKey"
#define TO_LATITUDE_KEY @"ProfileToLocationViewController.ToLatitudeKey"
#define TIME_IN_MINUTES @"TravelPlannerTableViewController.TimeInMinutesKey"
#define TOTAL_TIME_TRAVEL_MINUTES @"TravelPlannerTableViewController.TotalTravelMinutesKey"
#define MONTH @"TravelPlannerTableViewController.MonthKey"
#define BEST_SEAT @"PerformanceViewController.BestSeatKey"
#define LEFT_PERCENT @"PerformanceViewController.LeftPercentKey"
#define RIGHT_PERCENT @"PerformanceViewController.RightPercentKey"
#define FROM_LOCALITY_KEY @"ProfileFromLocationViewController.FromLocalityKey"
#define TO_LOCALITY_KEY @"ProfileToLocationViewController.ToLocalityKey"

#define TRIP_DIRECTION_DEGREES @"TravelPlannerTableViewController.TripDirectionDegreesKey"
#define START_SUN_POSSITION @"TravelPlannerTableViewController.StartSunPossitionKey"
#define END_SUN_POSSITION @"TravelPlannerTableViewController.EndSunPossitionKey"

#define DATE_KEY @"TravelPlannerTableViewController.DateKey"
#define TIME_KEY @"TravelPlannerTableViewController.TimeKey"

#define TBAR_H 44 // title bar height
#define SM_DIS 10 // side distance
#define BG_DIS 40 // big side distance

#define XS_FONT 10
#define SM_FONT 14
#define MS_FONT 20 // Medium Small Font
#define MD_FONT 30
#define BG_FONT 50

#define FONT_UL @"HelveticaNeue-UltraLight"
#define FONT_TH @"HelveticaNeue-Thin"
#define FONT_LI @"HelveticaNeue-Light"

#define FROM_LATITUDE_KEY @"ProfileFromLocationViewController.FromLatitudeKey"
#define TO_LATITUDE_KEY @"ProfileToLocationViewController.ToLatitudeKey"
#define TRIP_DIRECTION_DEGREES @"TravelPlannerTableViewController.TripDirectionDegreesKey"
#define TRANSPORT_TYPE @"TravelPlannerTableViewController.TransportTypeKey"
#define MONTH @"TravelPlannerTableViewController.MonthKey"
#define TIME_IN_MINUTES @"TravelPlannerTableViewController.TimeInMinutesKey"
#define TOTAL_TIME_TRAVEL_MINUTES @"TravelPlannerTableViewController.TotalTravelMinutesKey"
#define FROM_SUN_INCLINATION @"TravelPlannerTableViewController.FromSunInclinationKey"
#define START_SUN_POSSITION @"TravelPlannerTableViewController.StartSunPossitionKey"
#define END_SUN_POSSITION @"TravelPlannerTableViewController.EndSunPossitionKey"

#define FROM_DATA_KEY @"ProfileFromLocationViewController.FromNameKey"
#define TO_DATA_KEY @"ProfileToLocationViewController.ToNameKey"
#define TIME_KEY @"TravelPlannerTableViewController.TimeKey"
#define DATE_KEY @"TravelPlannerTableViewController.DateKey"

/*
#define FROM_LAT_LAUNCH_LOCATION 40.713055 // New York
#define FROM_LON_LAUNCH_LOCATION -74.007225 // New York
#define TO_LAT_LAUNCH_LOCATION 28.538330 // Orlando
#define TO_LON_LAUNCH_LOCATION -81.378876 // Orlando
*/

#define FROM_LAT_LAUNCH_LOCATION 52.519869 // Berlin
#define FROM_LON_LAUNCH_LOCATION 13.404537 // Berlin
#define TO_LAT_LAUNCH_LOCATION 52.369790 // Amsterdam
#define TO_LON_LAUNCH_LOCATION 4.905137 // Amsterdam


#define TIME_HOUR 480 // 8 am
#define TIME_MONTH 8.0// JULY

#define DIRECTION_DEGREES 271.732727 //*
#define TRANPORT_TYPE_MODE 1	 //*

#define TOTAL_TIME 549.025757 // * minutes -> car
#define SUN_START_ANGLE 66.122101 // *

#define START_SUN 120.000000 // *
#define END_SUN 257.256439 // *
//#define FROM_ADRESS @"New York"
//#define TO_ADRESS @"Orlando"
#define FROM_ADRESS @"Berlin"
#define TO_ADRESS @"Amsterdam"
#define DATE @"1. August 2015"
#define TIME @"8:00"

#define MINUTES_TO_SHOW_KEY @"TravelPlannerTableViewController.MinutesToShowKey"

#define FROM_DATA_KEY @"ProfileFromLocationViewController.FromNameKey"
#define FROM_LOCALITY_KEY @"ProfileFromLocationViewController.FromLocalityKey"
#define FROM_COUNTRY_KEY @"ProfileFromLocationViewController.FromCountryKey"
#define FROM_LATITUDE_KEY @"ProfileFromLocationViewController.FromLatitudeKey"
#define FROM_LONGITUDE_KEY @"ProfileFromLocationViewController.FromLongitudeKey"

#define TO_DATA_KEY @"ProfileToLocationViewController.ToNameKey"
#define TO_LOCALITY_KEY @"ProfileToLocationViewController.ToLocalityKey"
#define TO_COUNTRY_KEY @"ProfileToLocationViewController.ToCountryKey"
#define TO_LATITUDE_KEY @"ProfileToLocationViewController.ToLatitudeKey"
#define TO_LONGITUDE_KEY @"ProfileToLocationViewController.ToLongitudeKey"

#define TIME_KEY @"TravelPlannerTableViewController.TimeKey"

#define TIME_IN_MINUTES @"TravelPlannerTableViewController.TimeInMinutesKey"

#define FIRST_LAUNCH @"PoldiViewController.FirstLauch"

#define TRANSPORT_TYPE @"TravelPlannerTableViewController.TransportTypeKey"

#define DEGREES_ON_HOUR_BY_TIME 0.25 // 15° by 60 min per hour
#define MAX_MINUTES_TIME 1440 // are the minutes by 360°
#define MAX_COMPASS_DEGREES 360
#define DEGREES_ON_HOUR_BY_TIME 0.25 // 15° by 60 min per hour
#define MAX_MINUTES_TIME 1440 // are the minutes by 360°
#define MAX_COMPASS_DEGREES 360

#define FROM_TEMP @"PerformanceViewController.FromTemp"
#define FROM_MIN_TEMP @"PerformanceViewController.FromMinTemp"
#define TO_TEMP @"PerformanceViewController.ToTemp"
#define TO_MIN_TEMP @"PerformanceViewController.ToMinTemp"
#define FROM_TEMP_LON @"PerformanceViewController.FromTempLon"
#define FROM_TEMP_LAT @"PerformanceViewController.FromTempLat"
#define TO_TEMP_LON @"PerformanceViewController.ToTempLon"
#define TO_TEMP_LAT @"PerformanceViewController.ToTempLat"

#define TEMPERATURE_TYPE @"TravelPlannerTableViewController.TemperatureType"




- (void) setFromLocationLatitudeCoordinatesData: (float)fromLocationLatitudeCoordinates;
- (float)fromLocationLatitudeCoordinatesData;

- (void) setFromLocationLongitudeCoordinatesData: (float)fromLocationLongitudeCoordinates;
- (float)fromLocationLongitudeCoordinatesData;

- (void) setToLocationLatitudeCoordinatesData: (float)toLocationLatitudeCoordinates;
- (float)toLocationLatitudeCoordinatesData;

- (void) setToLocationLongitudeCoordinatesData: (float)toLocationLongitudeCoordinates;
- (float)toLocationLongitudeCoordinatesData;

- (void) setViaLocationLatitudeCoordinatesData: (float)viaLocationLatitudeCoordinates;
- (float)viaLocationLatitudeCoordinatesData;

- (void) setViaLocationLongitudeCoordinatesData: (float)viaLocationLongitudeCoordinates;
- (float)viaLocationLongitudeCoordinatesData;

- (void) setMonthData: (int) month;
- (int) monthData;

- (void) setMinutesData: (float)minutes;
- (float)minutesData;

- (void) setSunsPossitionFromData:(float)possition;
- (float)sunsPossitionFromData;

- (void) setSunsPossitionToData:(float)possition;
- (float)sunsPossitionToData;

- (void) setSunsPossitionViaData:(float)possition;
- (float)sunsPossitionViaData;

- (void) setTotalSunPercentData:(float)percent;
- (float) totalSunPercentData;

- (void) setTripDirectionData:(float)tripDirection;
- (float) tripDirectionData;

- (void) setStartSunsPossitionData:(float)startPossition;
- (float) startSunsPossitionData;

- (void) setEndSunsPossitionData:(float)endPossition;
- (float) endSunsPossitionData;

- (void) setFromLocationData: (NSString *)fromLocation;
- (NSString *) fromLocationData;

- (void) setToLocationData: (NSString *)toLocation;
- (NSString *) toLocationData;

- (void) setTimeData:(NSString *)time;
- (NSString *) timeData;

- (void) setFromSunInclinationData:(float)sunInclination; // + day, - night
- (float)fromSunInclinationData;

- (void) setToSunInclinationData:(float)sunInclination; // + day, - night
- (float)toSunInclinationData;

- (void) setTotalTimeTravelMinutesData:(float)totalTime;
- (float)totalTimeTravelMinutesData;

- (void) setTrainWindowSeatLeftFront:(float)times;
- (float)trainWindowSeatLeftFront;

- (void) setTrainWindowSeatLeftBack:(float)times;
- (float)trainWindowSeatLeftBack;

- (void) setTrainWindowSeatRightFront:(float)times;
- (float)trainWindowSeatRightFront;

- (void) setTrainWindowSeatRightBack:(float)times;
- (float)trainWindowSeatRightBack;

@end
