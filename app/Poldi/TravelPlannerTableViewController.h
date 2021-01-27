//
//  TravelPlannerTableViewController.h
//  Poldi
//
//  Created by admin on 01.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileFromLocationViewController.h"
#import "ProfileToLocationViewController.h"
#import "ProfileViaLocationViewController.h"
#import "ProfileTimeTableViewController.h"

@interface TravelPlannerTableViewController : UITableViewController <ProfileFromLocationViewControllerDelegate, ProfileToLocationViewControllerDelegate, ProfileViaLocationViewControllerDelegate, ProfileTimeTableViewControllerDelegate>

// Model Implementation Listener
@property (nonatomic, strong) NSString *fromLocation;
@property (nonatomic, strong) NSString *toLocation;
@property (nonatomic, strong) NSString *viaLocation;
@property (nonatomic, strong) NSString *dateAndTimeProfile;
@property BOOL *isCelsius;
@end
