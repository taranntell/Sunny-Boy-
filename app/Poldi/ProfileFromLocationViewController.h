//
//  ProfileFromLocationViewController.h
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ProfileFromLocationViewController;
@protocol ProfileFromLocationViewControllerDelegate <NSObject>

- (void)profileFromLocationViewController: (ProfileFromLocationViewController *)sender sendFromLocation:(NSString *)fromLocation;

@end
@interface ProfileFromLocationViewController : UIViewController

@property (nonatomic, strong) NSString *fromLocation;
@property (nonatomic, weak) id <ProfileFromLocationViewControllerDelegate> delegate;

@end
