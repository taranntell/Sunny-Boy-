//
//  ProfileToLocationViewController.m
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "ProfileToLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PoldiData.h"

@interface ProfileToLocationViewController () <UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PoldiData *poldiData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UINavigationBar *myNavBar;
@property (weak, nonatomic) IBOutlet UILabel *displayTo;

@end

@implementation ProfileToLocationViewController


#define TO_DATA_KEY @"ProfileToLocationViewController.ToNameKey"
#define TO_LOCALITY_KEY @"ProfileToLocationViewController.ToLocalityKey"
#define TO_COUNTRY_KEY @"ProfileToLocationViewController.ToCountryKey"
#define TO_LATITUDE_KEY @"ProfileToLocationViewController.ToLatitudeKey"
#define TO_LONGITUDE_KEY @"ProfileToLocationViewController.ToLongitudeKey"


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

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    return _locationManager;
}

- (IBAction)pressCurrentLocation:(UIBarButtonItem *)sender
{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    self.toTextField.placeholder = @"Finding your current location...";
    [self.toTextField resignFirstResponder];
    
    [self.locationManager startUpdatingLocation];
    [self.geocoder reverseGeocodeLocation: self.locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (error) {
             UIAlertView *placeNotFound = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"It seems that we can not find your location, please check your internet connection and try again.", @"no location") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [placeNotFound show];
             [self.spinner stopAnimating];
             self.spinner.hidden = YES;
             return;
         }
         
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = placemarks[0];
             CLLocation *blockLocation = placemark.location;
             self.toText = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
             [self.poldiData setToLocationData:placemark.locality];
             
             CLLocationCoordinate2D coords = blockLocation.coordinate;
             
             float lat = coords.latitude;
             float lon = coords.longitude;
             
             /* Implementation to find travel degrees destination */             
             [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:TO_COORDINATE_LAT];
             [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:TO_COORDINATE_LON];
             

             /* Implementation to find sun angle on latitude*/
             if (lat <= -24 && lat >= -66){
                 lat *= -1;
                 lon *= -1;
             }

             
             [self.poldiData setToLocationLatitudeCoordinatesData:lat];
             [self.poldiData setToLocationLongitudeCoordinatesData:lon];
             
             [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:TO_LOCALITY_KEY];
             [[NSUserDefaults standardUserDefaults] setObject:placemark.country forKey:TO_COUNTRY_KEY];
             [[NSUserDefaults standardUserDefaults] setObject:self.toText forKey:TO_DATA_KEY];
             [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:TO_LATITUDE_KEY];

             [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:TO_LONGITUDE_KEY];
                          
             [self.delegate profileToLocationViewController:self sendToLocation:self.toText];
             [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
             [self.spinner stopAnimating];
             self.spinner.hidden = YES;
             
         }
     }];
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
    
    self.myNavBar.topItem.title = NSLocalizedString(@"Travel Planner", @"title nav");
    self.displayTo.text = NSLocalizedString(@"To", @"to");

    
    self.toTextField.delegate = self;
    self.toTextField.placeholder = NSLocalizedString(@"For example: Hamburg", @"to example");
    [self.toTextField clearButtonMode];
    [self.toTextField becomeFirstResponder];
    self.spinner.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) findPlacemarkNameFromLocation:(NSString *)location
{
    dispatch_queue_t findLocation = dispatch_queue_create("find users location", NULL);
    dispatch_async(findLocation, ^{
        
        [self.geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                UIAlertView *placeNotFound = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"It seems that we can not find your location, please check your internet connection and try again.", @"no location") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [placeNotFound show];
                [self.spinner stopAnimating];
                self.spinner.hidden = YES;
                return;
            }
            
            if(placemarks && placemarks.count > 0)
            {
                CLPlacemark *placemark = placemarks[0];
                CLLocation *blockLocation = placemark.location;
                
                if (placemark.locality != NULL){

                    self.toText = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
                    [self.poldiData setToLocationData:placemark.locality];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:TO_LOCALITY_KEY];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.country forKey:TO_COUNTRY_KEY];
                    
                }else if (placemark.locality == NULL){

                    self.toText = [NSString stringWithFormat:@"%@", placemark.country];
                    [self.poldiData setToLocationData:placemark.country];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.country forKey:TO_LOCALITY_KEY];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TO_COUNTRY_KEY];
                    
                }
                CLLocationCoordinate2D coords = blockLocation.coordinate;
                float lat = coords.latitude;
                float lon = coords.longitude;
                
                /* Implementation to find travel degrees destination */
                [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:TO_COORDINATE_LAT];
                [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:TO_COORDINATE_LON];
                
                
                /* Implementation to find sun angle on latitude*/                
                if (lat <= -24 && lat >= -66){
                    lat *= -1;
                    lon *= -1;
                }

                [self.poldiData setToLocationLatitudeCoordinatesData:lat];
                [self.poldiData setToLocationLongitudeCoordinatesData:lon];
                
                if (placemark.locality != NULL){
                
                [[NSUserDefaults standardUserDefaults] setObject:self.toText forKey:TO_DATA_KEY];
                [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:TO_LATITUDE_KEY];
                [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:TO_LONGITUDE_KEY];
                
                [self.delegate profileToLocationViewController:self sendToLocation:self.toText];
                [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
                [self.spinner stopAnimating];
                self.spinner.hidden = YES;
                }
                else{
                    UIAlertView *placeNotFound = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"It seems that we can not find your location, please check your internet connection and try again.", @"no location") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [placeNotFound show];
                    [self.spinner stopAnimating];
                    self.spinner.hidden = YES;
                    return;
                }
                
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    });
}


# define mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField.text length]){
        [self findPlacemarkNameFromLocation:textField.text];
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
    }
    return YES;
}

@end
