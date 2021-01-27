//
//  ProfileFromLocationViewController.m
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "ProfileFromLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PoldiData.h"

@interface ProfileFromLocationViewController () <UITextFieldDelegate, UIPickerViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PoldiData *poldiData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UINavigationBar *myNavBar;
@property (weak, nonatomic) IBOutlet UILabel *displayFrom;

@end

@implementation ProfileFromLocationViewController


#define FROM_DATA_KEY @"ProfileFromLocationViewController.FromNameKey"
#define FROM_LOCALITY_KEY @"ProfileFromLocationViewController.FromLocalityKey"
#define FROM_COUNTRY_KEY @"ProfileFromLocationViewController.FromCountryKey"
#define FROM_LATITUDE_KEY @"ProfileFromLocationViewController.FromLatitudeKey"
#define FROM_LONGITUDE_KEY @"ProfileFromLocationViewController.FromLongitudeKey"


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
    self.fromTextField.placeholder = @"Finding your current location...";
    [self.fromTextField resignFirstResponder];

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
             // TODO: Repair, when the users gives an
             // contry insted of a state
             self.fromLocation = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
             [self.poldiData setFromLocationData:placemark.locality];
             
             CLLocationCoordinate2D coords = blockLocation.coordinate;
             
             float lat = coords.latitude;
             float lon = coords.longitude;
             
             /* Implementation to find trip orientation */
             [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:FROM_COORDINATE_LAT];
             [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:FROM_COORDINATE_LON];
             
             /* Implementation to find sun angle on latitde*/
             if (lat <= -24 && lat >= -66){
                 lat *= -1;
                 lon *= -1;
             }
             
             
             [self.poldiData setFromLocationLatitudeCoordinatesData:lat];
             [self.poldiData setFromLocationLongitudeCoordinatesData:lon];
             
             [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:FROM_LOCALITY_KEY];
             [[NSUserDefaults standardUserDefaults] setObject:placemark.country forKey:FROM_COUNTRY_KEY];
             [[NSUserDefaults standardUserDefaults] setObject:self.fromLocation forKey:FROM_DATA_KEY];
             [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:FROM_LATITUDE_KEY];

             [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:FROM_LONGITUDE_KEY];
             
             [self.delegate profileFromLocationViewController:self sendFromLocation:self.fromLocation];
             [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{ }];
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
    self.displayFrom.text = NSLocalizedString(@"From", @"from");
    
    self.fromTextField.delegate = self;
    self.fromTextField.placeholder = NSLocalizedString(@"For example: Berlin", @"from example");
    [self.fromTextField clearButtonMode];
    [self.fromTextField becomeFirstResponder];
    
    
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
                self.spinner.hidden = YES;
                [self.spinner stopAnimating];
                return;
            }
            
            
            if(placemarks && placemarks.count > 0)
            {
                CLPlacemark *placemark = placemarks[0];
                CLLocation *blockLocation = placemark.location;
                
                if (placemark.locality != NULL){
                    self.fromLocation = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
                    [self.poldiData setFromLocationData:placemark.locality];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:FROM_LOCALITY_KEY];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.country forKey:FROM_COUNTRY_KEY];
                
                }else if (placemark.locality == NULL){

                    self.fromLocation = [NSString stringWithFormat:@"%@", placemark.country];
                    [self.poldiData setFromLocationData:placemark.country];
                    [[NSUserDefaults standardUserDefaults] setObject:placemark.country forKey:FROM_LOCALITY_KEY];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FROM_COUNTRY_KEY];
                }
                
                CLLocationCoordinate2D coords = blockLocation.coordinate;
                
                float lat = coords.latitude;
                float lon = coords.longitude;

                
                /* Implementation to find trip orientation */
                [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:FROM_COORDINATE_LAT];
                [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:FROM_COORDINATE_LON];
                
                /* Implementation to find sun angle on latitde*/                
                if (lat <= -24 && lat >= -66){
                    lat *= -1;
                    lon *= -1;
                }
                
                
                //NSLog(@"coods.latitude %f coords.longitude %f country %@ locality %@", coords.latitude, coords.longitude, placemark.country, placemark.locality);
                
                [self.poldiData setFromLocationLatitudeCoordinatesData:lat];
                [self.poldiData setFromLocationLongitudeCoordinatesData:lon];
                

                if (placemark.locality != NULL){

                
                [[NSUserDefaults standardUserDefaults] setObject:self.fromLocation forKey:FROM_DATA_KEY];
                [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:FROM_LATITUDE_KEY];
                [[NSUserDefaults standardUserDefaults] setFloat:lon forKey:FROM_LONGITUDE_KEY];
                
                [self.delegate profileFromLocationViewController:self sendFromLocation:self.fromLocation];
                [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{ }];
                [self.spinner stopAnimating];
                self.spinner.hidden = YES;

                }
                else{
                    //NSLog(@"null fromLocality %@", self.fromLocation);
                    UIAlertView *placeNotFound = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"It seems that we can not find your location, please check your internet connection and try again.", @"no location") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [placeNotFound show];
                    self.spinner.hidden = YES;
                    [self.spinner stopAnimating];
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

# pragma mark UIPickerViewDelegate


@end
