//
//  ProfileTimeTableViewController.h
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileTimeTableViewController;
@protocol ProfileTimeTableViewControllerDelegate <NSObject>

- (void)profileTimeTableViewController: (ProfileTimeTableViewController *) sender sendDate:(NSString *)date andTime: (NSString *)time;

@end

@interface ProfileTimeTableViewController : UITableViewController

@property (nonatomic, strong) NSString *dateLocation;
@property (nonatomic, strong) NSString *timeLocation;

@property (nonatomic, weak) id <ProfileTimeTableViewControllerDelegate>delegate;
@end
