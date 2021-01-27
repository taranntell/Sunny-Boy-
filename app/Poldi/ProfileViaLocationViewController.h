//
//  ProfileViaLocationViewController.h
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViaLocationViewController;
@protocol ProfileViaLocationViewControllerDelegate <NSObject>

- (void)profileViaLocationViewController: (ProfileViaLocationViewController *)sender sendViaLocation:(NSString *)viaLocation;

@end

@interface ProfileViaLocationViewController : UIViewController

@property (nonatomic, weak) id <ProfileViaLocationViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *viaText;

@end
