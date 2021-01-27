//
//  InfoViewController.m
//  Poldi
//
//  Created by admin on 14.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "InfoViewController.h"
#import "LocationBrain.h"
@interface InfoViewController ()

@property (strong, nonatomic) LocationBrain *locationBrain;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeDown;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUp;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRight;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (weak, nonatomic) IBOutlet UILabel *displayStartLocation;
@property (weak, nonatomic) IBOutlet UILabel *displayEndLocation;
@property (weak, nonatomic) IBOutlet UILabel *displaySunPercent;
@property (weak, nonatomic) IBOutlet UILabel *displayBestSeat;
@property (weak, nonatomic) IBOutlet UILabel *displayDate;
@property (weak, nonatomic) IBOutlet UILabel *displayTransportType;
@property (weak, nonatomic) IBOutlet UILabel *displayTripDirection;
@property (weak, nonatomic) IBOutlet UILabel *displayDepartureTime;
@property (weak, nonatomic) IBOutlet UILabel *sunLeftPercent;
@property (weak, nonatomic) IBOutlet UILabel *sunRightPercent;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *displaySeatLocatorExample;
@property (weak, nonatomic) IBOutlet UIButton *url;

@end

@implementation InfoViewController


#define FROM_DATA_KEY @"ProfileFromLocationViewController.FromNameKey"
#define TO_DATA_KEY @"ProfileToLocationViewController.ToNameKey"
#define TIME_KEY @"TravelPlannerTableViewController.TimeKey"
#define TIME_IN_MINUTES @"TravelPlannerTableViewController.TimeInMinutesKey"
#define DATE_KEY @"TravelPlannerTableViewController.DateKey"
#define TRANSPORT_TYPE @"TravelPlannerTableViewController.TransportTypeKey"
#define TRIP_DIRECTION_DEGREES @"TravelPlannerTableViewController.TripDirectionDegreesKey"
#define BEST_SEAT @"PerformanceViewController.BestSeatKey"
#define LEFT_PERCENT @"PerformanceViewController.LeftPercentKey"
#define RIGHT_PERCENT @"PerformanceViewController.RightPercentKey"

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (LocationBrain *)locationBrain
{
    if (!_locationBrain) {
        _locationBrain = [[LocationBrain alloc] init];
    }
    return _locationBrain;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.displayStartLocation.text = [NSString stringWithFormat:@"From %@", [userDefaults objectForKey:FROM_DATA_KEY]];
    self.displayEndLocation.text = [NSString stringWithFormat:@"to %@", [userDefaults objectForKey:TO_DATA_KEY]];
    self.displayDate.text = [NSString stringWithFormat:@"on the %@", [userDefaults objectForKey:DATE_KEY]];
    self.displayDepartureTime.text = [NSString stringWithFormat:@"**at %@", [userDefaults objectForKey:TIME_KEY]];
    NSInteger transportType = [userDefaults integerForKey:TRANSPORT_TYPE];
    if (transportType == 0){
        self.displayTransportType.text = [NSString stringWithFormat:@"going with train" ];
    }else{
        self.displayTransportType.text = [NSString stringWithFormat:@"going with car" ];
    }
    
    
    float tripDirectionDegrees = [userDefaults floatForKey:TRIP_DIRECTION_DEGREES];
    self.displayTripDirection.text = [NSString stringWithFormat:@"**with a direction of %0.1f° (%@)", tripDirectionDegrees, [self.locationBrain findOrienationLetterWithDegrees:tripDirectionDegrees]];
    self.displaySunPercent.text = [NSString stringWithFormat:@"The sun is 34%% higher"]; // NOT REALLY
    
    self.displayBestSeat.text = [NSString stringWithFormat:@"so you better seat %@", [userDefaults objectForKey:BEST_SEAT]];
    self.sunLeftPercent.text = [NSString stringWithFormat:@"cuz the sun is %0.1f%% at your right", [userDefaults floatForKey:LEFT_PERCENT]];
    self.sunRightPercent.text = [NSString stringWithFormat:@"and %0.1f%% at your left", [userDefaults floatForKey:RIGHT_PERCENT]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipeDown];
    [self.view addGestureRecognizer:self.swipeUp];
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeLeft];
  
#define TRANSPORT_TYPE @"TravelPlannerTableViewController.TransportTypeKey"
    NSInteger transportType = [[NSUserDefaults standardUserDefaults] integerForKey:TRANSPORT_TYPE];
    
    if (transportType == 0){ // train
        NSString *locator_image = NSLocalizedString(@"train locator", @"train locator");
        
        [self.infoImage setImage:[UIImage imageNamed:locator_image]];
        self.displaySeatLocatorExample.text = NSLocalizedString(@"seat train locator", @"seat train locator");// @"Train seat locator example:";
        
    }else if (transportType == 1){ // car
        NSString *locator_image = NSLocalizedString(@"car locator", @"car locator");
        [self.infoImage setImage:[UIImage imageNamed:locator_image]];
        self.displaySeatLocatorExample.text =  NSLocalizedString(@"seat car locator", @"seat car locator");// @"Car seat locator example:";
    }else if (transportType == 2){
        NSString *locator_image = NSLocalizedString(@"bus locator", @"bus locator");
        [self.infoImage setImage:[UIImage imageNamed:locator_image]];
                self.displaySeatLocatorExample.text =  NSLocalizedString(@"seat bus locator", @"seat bus locator"); // @"Bus seat locator example:";
    }else if (transportType == 3){
        NSString *locator_image = NSLocalizedString(@"ricksaw locator", @"ricksaw locator");
        [self.infoImage setImage:[UIImage imageNamed:locator_image]];
            self.displaySeatLocatorExample.text =  NSLocalizedString(@"seat riscksaw locator", @"seat riscksaw locator"); //@"Riscksaw seat locator example:";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UISwipeGestureRecognizer *)swipeDown
{
    if (!_swipeDown){
        _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPerformanceView)];
        _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swipeDown;
}

- (UISwipeGestureRecognizer *)swipeUp
{
    if (!_swipeUp){
        _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPerformanceView)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUp;
}

- (UISwipeGestureRecognizer *)swipeRight
{
    if (!_swipeRight){
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPerformanceView)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _swipeRight;
}

- (UISwipeGestureRecognizer *)swipeLeft
{
    if (!_swipeLeft){
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPerformanceView)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _swipeLeft;
}
- (IBAction)openURL:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.muugs.com"]];
}

- (IBAction)closeInfo:(UIButton *)sender {
    [self showPerformanceView];
}


- (void) showPerformanceView
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

@end
