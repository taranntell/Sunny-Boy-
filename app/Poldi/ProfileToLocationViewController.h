//
//  ProfileToLocationViewController.h
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileToLocationViewController;
@protocol ProfileToLocationViewControllerDelegate <NSObject>

- (void)profileToLocationViewController: (ProfileToLocationViewController *)sender sendToLocation:(NSString *)toLocation;

@end

@interface ProfileToLocationViewController : UIViewController

@property (nonatomic, weak) id <ProfileToLocationViewControllerDelegate>delegate;

@property (nonatomic, strong) NSString *toText;

@end
