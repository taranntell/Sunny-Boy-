//
//  ProfileViaLocationViewController.m
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "ProfileViaLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PoldiData.h"

@interface ProfileViaLocationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *viaTextField;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PoldiData *poldiData;

@end

@implementation ProfileViaLocationViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (PoldiData *)poldiData{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder){
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (IBAction)pressDismiss:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viaTextField.delegate = self;
    self.viaTextField.placeholder = @"For example: Berlin";
    [self.viaTextField clearButtonMode];
    [self.viaTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) findPlacemarkNameFromLocation:(NSString *)location
{
    [self.geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            UIAlertView *placeNotFound = [[UIAlertView alloc] initWithTitle:@"Place not found" message:@"Your place was not found, please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [self.view addSubview:placeNotFound];
            return;
        }
        
        if(placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            CLLocation *blockLocation = placemark.location;
            self.viaText = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
            
            CLLocationCoordinate2D coords = blockLocation.coordinate;
            [self.poldiData setToLocationLatitudeCoordinatesData:coords.latitude];
            [self.poldiData setToLocationLongitudeCoordinatesData:coords.longitude];
            
            [self.delegate profileViaLocationViewController:self sendViaLocation:self.viaText];
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
            
        }
    }];
}

# define mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField.text length]){
        [self findPlacemarkNameFromLocation:textField.text];
        
    }
    return YES;
}
@end
