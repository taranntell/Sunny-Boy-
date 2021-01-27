//
//  PerformanceBrain.m
//  Poldi
//
//  Created by admin on 07.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "PerformanceBrain.h"
#import "PoldiData.h"

@interface PerformanceBrain ()

@property (nonatomic) int rightTimes;
@property (nonatomic) int leftTimes;
@property (nonatomic, strong) PoldiData *poldiData;


@end

@implementation PerformanceBrain


- (PoldiData *)poldiData
{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}

- (float) findInterpolationLatitude0: (float)l0 latitude1:(float)l1 time0:(float)t0 time1:(float)t1 time:(float)t
{
    /************ FORMULA INTERPOLATION **************
     *
     *      l = l0 + ( ( t - t0 ) / ( t1 - t0 ) )( l1 - l0 ) )
     *
     *  l: latitude
     *  t: time
     */
    return l0 + ( ( t - t0 ) / ( t1 - t0 ) ) * ( l1 - l0 );
}


- (float) findMirrorDegreesOfSunPossition:(float)startSunPossition
{
    float degrees = 0.0;
    
    degrees = startSunPossition + 180;
    if (degrees > 360){
        degrees -= 360;
    }
    
    return degrees;
}


typedef enum{
    kLeft = 0,  // 0
    kRight,     // 1
//    kSeatLeftDirectionBack,  // 2 kSeatLeftDirectionBack
//    kSeatRightDirectionBack, // 3 kSeatRightDirectionBack
//    kSeatLeftDirectionFront, // 4 kSeatLeftDirectionFront
//    kSeatRightDirectionFront,// 5 kSeatRightDirectionFront
    kSeatRightDirectionBackTrainLeftFrontRightBackFront, // 2
    kSeatRightDirectionBackTrainRightBackFront,          // 3
    kSeatRightDirectionFrontTrainRightBackFront,         // 4
    kSeatRightDirectionFrontTrainLeftBackRightBackFront, // 5
    kSeatLeftDirectionBackTrainRightFrontLeftBackFront,  // 6
    kSeatLeftDirectionBackTrainLeftBackFront,            // 7
    kSeatLeftDirectionFrontTrainRightBackLeftBackFront,  // 8
    kSeatLeftDirectionFrontTrainLeftBackFront,           // 9
}SitPlace;

#define STAR_COMPASS 0
#define END_COMPASS 360


- (int) findSeatWithSunPossition:(float)sunPossition withMirrorSunPossition:(float)mirrorPossition andDestination:(float)destination
{
    
    float middleSun = 0.0;
    float sunForTrain = 0.0;

    if ( sunPossition < 180 ){
        if (destination < mirrorPossition && destination > sunPossition){ // FIRST: LEFT OR RIGHT


            middleSun = sunPossition + 90;
            // CHEK MIDDLE WITH SUN POSSITION
            if ( destination <= middleSun && destination >= sunPossition ){
                // NSLog(@"sun to the LEFT direction FRONT");
                sunForTrain = sunPossition + 45;
                // CHECK SUN TRAIN WITH SUN POSSITION
                if (destination <= sunForTrain && destination >= sunPossition){
                    //**NSLog(@"sun to the Left direction Front Sun for Train Front"); // LH
                    // kSeatRightDirectionBackTrainLeftFrontRightBackFront
                    return kSeatRightDirectionBackTrainLeftFrontRightBackFront;
                }else{
                    //**nslog(@"sun to the Left direction Front Sun for Train Back"); // LV, LH
                    // kSeatRightDirectionBackTrainRightBackFront
                    return kSeatRightDirectionBackTrainRightBackFront;
                }
//kSeatRightDirectionBack
//                return kSeatRightDirectionBack;
            }else{
                // NSLog(@"sun to the LEFT direction BACK");
                sunForTrain = middleSun + 45;
                // CHECK SUN TRAIN WITH MIDDLE SUN
                if ( destination >= middleSun && destination <= sunForTrain){
                     //**nslog(@"sun to the Left direction Back Sun for Train Front"); // LV, LH
                    // kSeatRightDirectionFrontTrainRightBackFront
                    return kSeatRightDirectionFrontTrainRightBackFront;
                }else{
                     //**nslog(@"sun to the Left direction Back Sun for Train Back"); // LV
                    // kSeatRightDirectionFrontTrainLeftBackRightBackFront
                    return kSeatRightDirectionFrontTrainLeftBackRightBackFront;
                }
//kSeatRightDirectionFront
//                return kSeatRightDirectionFront;
            }
        }else{

            if (sunPossition >= 90 && sunPossition <= 180){
                middleSun = sunPossition - 90;
                // CHECK MIDDLE WITH SUN POSSITION
                if (destination >= middleSun && destination <= sunPossition){
                    // NSLog(@"sun to the RIGHT direction FRONT");
                    sunForTrain = sunPossition - 45;
                    if (destination >= sunForTrain && destination <= sunPossition){
                         //**nslog(@"sun to the Right direction Front Sun for Train Front"); // RH
                        // kSeatLeftDirectionBackTrainRightFrontLeftBackFront
                        return kSeatLeftDirectionBackTrainRightFrontLeftBackFront;
//                    }else{
                         //**nslog(@"sun to the Right direction Front Sun for Train Back"); // RH, RV
                        // kSeatLeftDirectionBackTrainLeftBackFront
                        return kSeatLeftDirectionBackTrainLeftBackFront;
                    }
//kSeatLeftDirectionBack
//                    return kSeatLeftDirectionBack;
                }else{
                    // NSLog(@"sun to the RIGHT direction BACK");
                    if (mirrorPossition <= 315){
                        sunForTrain = mirrorPossition + 45;
                        if ( destination <= sunForTrain && destination >= mirrorPossition){
                             //**nslog(@"sun to the Right direction Back Sun for Train Back"); // RV
                            // kSeatLeftDirectionFrontTrainRightBackLeftBackFront
                            return kSeatLeftDirectionFrontTrainRightBackLeftBackFront;
                        }else{
                             //**nslog(@"sun to the Right direction Back Sun for Train Front"); // RH, RV
                            // kSeatLeftDirectionFrontTrainLeftBackFront
                            return kSeatLeftDirectionFrontTrainLeftBackFront;
                        }
//kSeatLeftDirectionFront
//                        return kSeatLeftDirectionFront;
                    }else if (mirrorPossition > 315){
                        sunForTrain = middleSun - 45;
                        if ( destination >= sunForTrain && destination <= sunPossition ){
                             //**nslog(@"sun to the Right direction Back Sun for Train Front"); // RH, RV
                            // kSeatLeftDirectionFrontTrainLeftBackFront
                            return kSeatLeftDirectionFrontTrainLeftBackFront;
                        }else{
                             //**nslog(@"sun to the Right direction Back Sun for Train Back"); // RV
                            // kSeatLeftDirectionFrontTrainRightBackLeftBackFront
                            return kSeatLeftDirectionFrontTrainRightBackLeftBackFront;
                        }
//kSeatLeftDirectionFront
//                        return kSeatLeftDirectionFront;
                    }
                }

            }else {
                middleSun = sunPossition - 90 + END_COMPASS;
                // CHECK MIDDLE WITH MIRROR
                if (destination <= middleSun && destination >= mirrorPossition){
                    // NSLog(@"sun to the RIGHT direction BACK");
                    sunForTrain = mirrorPossition + 45;
                    if ( destination <= sunForTrain && destination >= mirrorPossition ){
                         //**nslog(@"sun to the Right direction Back Sun for Train Back"); // RV
                        // kSeatLeftDirectionFrontTrainRightBackLeftBackFront
                        return kSeatLeftDirectionFrontTrainRightBackLeftBackFront;
                    }else{
                         //**nslog(@"sun to the Right direction Back Sun for Train Front"); // RH, RV
                        // kSeatLeftDirectionFrontTrainLeftBackFront
                        return kSeatLeftDirectionFrontTrainLeftBackFront;
                    }
//kSeatLeftDirectionFront
//                    return kSeatLeftDirectionFront;
                }else{
                    // NSLog(@"sun to the RIGHT direction FRONT");
                    if (sunPossition >= 45){
                        sunForTrain = sunPossition - 45;
                        if (destination >= sunForTrain && destination <= sunPossition){
                             //**nslog(@"sun to the Right direction Front Sun for Train Front"); // RH
                            // kSeatLeftDirectionBackTrainRightFrontLeftBackFront
                            return kSeatLeftDirectionBackTrainRightFrontLeftBackFront;
                        }else{
                             //**nslog(@"sun to the Right direction Front Sun for Train Back"); // RH, RV
                            // kSeatLeftDirectionBackTrainLeftBackFront
                            return kSeatLeftDirectionBackTrainLeftBackFront;
                        }
//kSeatLeftDirectionBack
//                        return kSeatLeftDirectionBack;
                    }
                    else if ( sunPossition < 45){
                        sunForTrain = mirrorPossition + 45;
                        if (destination >= mirrorPossition && destination <= sunForTrain){
                             //**nslog(@"sun to the Right direction Front Sun for Train Back"); // RH, RV
                            // kSeatLeftDirectionBackTrainLeftBackFront
                            return kSeatLeftDirectionBackTrainLeftBackFront;
                        }else{
                             //**nslog(@"sun to the Right direction Front Sun for Train Front"); // RH
                            // kSeatLeftDirectionBackTrainRightFrontLeftBackFront
                            return kSeatLeftDirectionBackTrainRightFrontLeftBackFront;
                        }
//kSeatLeftDirectionBack
//                        return kSeatLeftDirectionBack;
                    }
                }
            }
            // NSLog(@"-> sun to the RIGHT sunPossition %f", sunPossition);
        }
    
    }else if (sunPossition > 180){                                       // FIRST: LEFT OR RIGHT
        if (destination > mirrorPossition && destination < sunPossition){
            middleSun = sunPossition - 90;
            // CHECK MIDDLE WITH SUN POSSITION
            // NSLog(@"-* sun to the RIGHT sunPossition %f", sunPossition);
            if (destination >= middleSun && destination <= sunPossition){
                // NSLog(@"sun to the RIGHT direction FRONT");
                sunForTrain = sunPossition - 45;
                if (destination >= sunForTrain && destination <= sunPossition){
                     //**nslog(@"sun to the Right direction Front Sun for Train Front"); // RH
                    // kSeatLeftDirectionBackTrainRightFrontLeftBackFront
                    return kSeatLeftDirectionBackTrainRightFrontLeftBackFront;
                }else{
                     //**nslog(@"sun to the Right direction Front Sun for Train Back"); // RH, RV
                    // kSeatLeftDirectionBackTrainLeftBackFront
                    return kSeatLeftDirectionBackTrainLeftBackFront;
                }
//kSeatLeftDirectionBack
//                return kSeatLeftDirectionBack;
            }else{
                // NSLog(@"sun to the RIGHT direction BACK");
                sunForTrain = mirrorPossition + 45;
                if (destination >= mirrorPossition && destination <= sunForTrain){
                     //**nslog(@"sun to the Right direction Back Sun for Train Back"); // RV
                        // kSeatLeftDirectionFrontTrainRightBackLeftBackFront
                    return kSeatLeftDirectionFrontTrainRightBackLeftBackFront;
                }else{
                     //**nslog(@"sun to the Right direction Back Sun for Train Front"); // RH, RV
                        // kSeatLeftDirectionFrontTrainLeftBackFront
                    return kSeatLeftDirectionFrontTrainLeftBackFront;
                }
//kSeatLeftDirectionFront
//                return kSeatLeftDirectionFront;
            }
        }else{
            if (sunPossition >= 180 && sunPossition <= 270){
                middleSun = sunPossition + 90;
                // CHECK MIDDLE WITH SUN POSSITION
                if (destination <= middleSun && destination >= sunPossition){
                    // NSLog(@"sun to the LEFT direction FRONT");
                    sunForTrain = sunPossition + 45;
                    if (destination >= sunPossition && destination <= sunForTrain){
                         //**nslog(@"sun to the Left direction Front Sun for Train Front"); // LH
                        // kSeatRightDirectionBackTrainLeftFrontRightBackFront
                        return kSeatRightDirectionBackTrainLeftFrontRightBackFront;
                    }else{
                         //**nslog(@"sun to the Left direction Front Sun for Train Back"); // LV, LH
                        // kSeatRightDirectionBackTrainRightBackFront
                        return kSeatRightDirectionBackTrainLeftFrontRightBackFront;
                    }
//kSeatRightDirectionBack
//                    return kSeatRightDirectionBack;
                }else{
                    // NSLog(@"sun to the LEFT direction BACK");
                    if (mirrorPossition >= 45){
                        sunForTrain = mirrorPossition - 45;
                        if (destination >= sunForTrain && destination <= mirrorPossition){
                             //**nslog(@"sun to the Left direction Front Sun for Train Back"); // LV, LH
                            // kSeatRightDirectionBackTrainRightBackFront
                            return kSeatRightDirectionBackTrainRightBackFront;
                        }
                        else{
                             //**nslog(@"sun to the Left direction Front Sun for Train Front"); // LH
                            // kSeatRightDirectionBackTrainLeftFrontRightBackFront
                            return kSeatRightDirectionBackTrainLeftFrontRightBackFront;
                        }
//kSeatRightDirectionBack
//                        return kSeatRightDirectionBack;
                    }else if (mirrorPossition <= 45){
                        sunForTrain = middleSun + 45;
                        if (destination >= middleSun && destination <= sunForTrain){
                             //**nslog(@"sun to the Left direction Front Sun for Train Front"); // LH
                            // kSeatRightDirectionBackTrainLeftFrontRightBackFront
                            return kSeatRightDirectionBackTrainLeftFrontRightBackFront;
                        }
                        else{
                             //**nslog(@"sun to the Left direction Front Sun for Train Back"); // LV, LH
                            // kSeatRightDirectionBackTrainRightBackFront
                            return kSeatRightDirectionBackTrainRightBackFront;
                        }
//kSeatRightDirectionBack
//                        return kSeatRightDirectionBack;
                    }
                }
                
            }else if (sunPossition > 270 && sunPossition <= 360){
                middleSun = sunPossition + 90 - END_COMPASS;
                // CHECK MIDDLE WITH MIRROR
                if (destination >= middleSun && destination < mirrorPossition){
                    // NSLog(@"sun to the LEFT direction BACK");
                    sunForTrain = mirrorPossition - 45;
                    if (destination >= sunForTrain && destination <= mirrorPossition)
                    {
                         //**nslog(@"sun to the Left direction Back Sun for Train Back"); // LV
                        // kSeatRightDirectionFrontTrainLeftBackRightBackFront
                        return kSeatRightDirectionFrontTrainLeftBackRightBackFront;
                    }
                    else{
                         //**nslog(@"sun to the Left direction Back Sun for Train Front"); // LV, LH
                        // kSeatRightDirectionFrontTrainRightBackFront
                        return kSeatRightDirectionFrontTrainRightBackFront;
                    }
//kSeatRightDirectionFront
//                    return kSeatRightDirectionFront;
                }else{
                    // NSLog(@"sun to the LEFT direction FRONT");
                    if (sunPossition <= 315){
                        sunForTrain = sunPossition + 45;
                        if (destination >= sunPossition && destination <= sunForTrain){
                            //**nslog(@"sun to the Left direction Front Sun for Train Front"); // LH
                            // kSeatRightDirectionBackTrainLeftFrontRightBackFront
                            return kSeatRightDirectionBackTrainLeftFrontRightBackFront;
                        }else{
                            //**nslog(@"sun to the Left direction Front Sun for Train Back"); // LV, LH
                            // kSeatRightDirectionBackTrainRightBackFront
                            return kSeatRightDirectionBackTrainRightBackFront;
                        }
//kSeatRightDirectionBack
//                        return kSeatRightDirectionBack;
                    }else if (sunPossition > 315){
                        sunForTrain = mirrorPossition - 45;
                        if (destination <= mirrorPossition && destination >= sunForTrain){
                            //**nslog(@"sun to the Left direction Back Sun for Train Back"); // LV
                            // kSeatRightDirectionFrontTrainLeftBackRightBackFront
                            return kSeatRightDirectionFrontTrainLeftBackRightBackFront;
                        }else{
                            //**nslog(@"sun to the Left direction Back Sun for Train Front"); // LV, LH
                            // kSeatRightDirectionFrontTrainRightBackFront
                            return kSeatRightDirectionFrontTrainRightBackFront;
                        }
//kSeatRightDirectionFront
//                        return kSeatRightDirectionFront;
                    }
                }
            }
            // NSLog(@"sun to the LEFT sunPossition %f", sunPossition);
        }
    }

//    NSLog(@"SunPossition %f MIDDLE %f sunForTrain %f MirrorSunPossition %f Destination %f ", sunPossition, middleSun, sunForTrain, mirrorPossition, destination);
    
    return 0;
}


// Time in minutes
#define TOTAL_DAY_MINUTES 1440
#define HALF_DAY_MINUTES 720
- (int) findMirrorTime:(int)time{

    if (time >= 0 && time <= HALF_DAY_MINUTES){
        time += HALF_DAY_MINUTES;
    }
    else{
        time = time + HALF_DAY_MINUTES - TOTAL_DAY_MINUTES;
    }
    
    return time;
}

// Time in minutes
- (int) checkMirrorTimeOfSunAngleBetweenLatitude23andMinus23:(float)latitude inMonth:(int)month withTime:(int)time
{
    if ( latitude <= 23 && latitude >= 21 ){ // sun night in: June
        if (month == 6){
            return [self findMirrorTime:time];
        }
    }
    
    else if ( latitude < 21 && latitude >= 12 ){ // sun night in: May, June, July
        if (month == 5 || month == 6 || month == 7){
            return [self findMirrorTime:time];
        }
    }
    
    else if ( latitude < 12 && latitude >= 0 ){ // sun night in: Apr, May June, July, Ago
        if (month == 4 || month == 5 || month == 6 || month == 7 || month == 8){
            return [self findMirrorTime:time];
        }
        
    }
    
    else if ( latitude < 0 && latitude >= -11 ){ // sun night in: Marz, Apr, May, June, July, Ago, Sep
        if (month == 3 || month == 4 || month == 5 || month == 6 || month == 7 || month == 8 || month == 9){
            return [self findMirrorTime:time];
        }
        
    }
    
    else if ( latitude < -11 && latitude >= -20 ){ // sun night in: Feb, Marz, Apr, May, June, July, Ago, Sep, Oct
        if (month != 1 && month != 11 && month != 12){
            return [self findMirrorTime:time];
        }
    
    }
    
    else if ( latitude < - 20 && latitude >= -23 ){ // sun night in: Ene, Feb, Marz, Apr, May, June, Ago, Sep, Oct, Nov
        if (month != 12){
            return [self findMirrorTime:time];
        }
    }
    return time;
}

@end

