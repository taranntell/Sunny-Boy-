//
//  PoldiViewController.m
//  Poldi
//
//  Created by Diego Loop on 01.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "PoldiViewController.h"
#import "PoldiData.h"
#import "LocationBrain.h"
#import "ColorfulButton.h"
#import <iAd/iAd.h>

@interface PoldiViewController ()
@property (strong, nonatomic) PoldiData *poldiData;
@property (strong, nonatomic) LocationBrain *locationBrain;
@property (weak, nonatomic) IBOutlet ColorfulButton *pressNewTrip;

@property (nonatomic) BOOL isLanched;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUp;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (weak, nonatomic) IBOutlet UILabel *displayRoute;
@property (weak, nonatomic) IBOutlet UILabel *displayTripTime;

@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property (weak, nonatomic) IBOutlet UIButton *sunnyBoyButton;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *sunnyImage;

@end

@implementation PoldiViewController



- (UIActivityIndicatorView *)spinner{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.frame = CGRectMake(self.sunnyImage.frame.origin.x + self.sunnyImage.bounds.size.width/2 - (_spinner.frame.size.width/2),
                                    self.sunnyImage.frame.origin.y + self.sunnyImage.bounds.size.height/2- (_spinner.frame.size.height/2),
                                    _spinner.bounds.size.width,
                                    _spinner.bounds.size.height);
        self.sunnyImage.alpha = 0.85f;
        [self.view addSubview:self.spinner];
    }
    return _spinner;
}

- (UISwipeGestureRecognizer *)swipeLeft
{
    if (!_swipeLeft){
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPerformance)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _swipeLeft;
}

- (UISwipeGestureRecognizer *)swipeUp
{
    if (!_swipeUp){
        _swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(showTravelPlanner)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUp;
}


- (IBAction)sunnyBoyButton:(id)sender{
    [self.spinner startAnimating];
}

- (void) showPerformance
{
    [self.spinner startAnimating];
    [self performSegueWithIdentifier:@"Show Performance" sender:self];
}

- (void) showTravelPlanner
{
    [self performSegueWithIdentifier:@"Show Trip Profile" sender:self];
}

- (IBAction)pressNewTrip:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"Show Trip Profile" sender:self];
}

- (LocationBrain *)locationBrain
{
    if (!_locationBrain){
        _locationBrain = [[LocationBrain alloc] init];
    }
    return _locationBrain;
}

- (PoldiData *)poldiData{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (UIImageView *)sunnyImage{
    if (!_sunnyImage) {
        _sunnyImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-(150/2),
                                                                    self.view.bounds.size.width/2,
                                                                    150,
                                                                    150)];
        
        _sunnyImage.image = [UIImage imageNamed:@"sunhome@2x.png"];
        _sunnyImage.alpha = 0.0f;
        [self.view addSubview:_sunnyImage];
    }
    return _sunnyImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    [UIView animateWithDuration:1.f animations:^{
        [self.sunnyImage setFrame:CGRectMake((self.view.bounds.size.width/2)    - (200/2),
                                             (self.view.bounds.size.height/2.6) - (200/2),
                                             200,
                                             200)];
        self.sunnyImage.alpha = 1.0f;
        
    }];

    
    [[self.pressNewTrip layer] setCornerRadius:4.0f];
    [[self.pressNewTrip layer] setMasksToBounds:YES];
    [[self.pressNewTrip layer] setBorderWidth:1.0f];
    [[self.pressNewTrip layer] setBorderColor:[UIColor darkGrayColor].CGColor];

    [self.view addGestureRecognizer:self.swipeUp];
    [self.view addGestureRecognizer:self.swipeLeft];
  
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPerformance)];
    [self.view addGestureRecognizer:self.singleTap];
}

- (void) showSwipeView
{
    UIView *swipeView = [[UIView alloc] init];
    [swipeView setFrame:CGRectMake(self.view.frame.size.width/2 - ((self.view.frame.size.width - 105) /2)-1,self.view.frame.size.height/2 - ((self.view.frame.size.height - 250) /2), self.view.frame.size.width - 105, self.view.frame.size.height - 250 )];
    [swipeView setAlpha:0.0f];
    //    self.oneTouchView.center = self.view.center;
    [swipeView setBackgroundColor:[UIColor blackColor]];
    swipeView.layer.cornerRadius = 10;
    swipeView.layer.masksToBounds = YES;
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(swipeView.bounds.origin.x, swipeView.bounds.origin.y - 30, 200, 100)];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.font = [UIFont boldSystemFontOfSize:20];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = NSLocalizedString(@"Welcome", @"Welcome");
    welcomeLabel.alpha = 1.f;
    
    
    
    [UIView animateWithDuration:1.5f delay:1.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
        swipeView.alpha = 0.88f;
    } completion:^(BOOL finished) {
    }];
    

    [self.view bringSubviewToFront:swipeView];
    [self.view addSubview:swipeView];
    [swipeView bringSubviewToFront:welcomeLabel];
    [swipeView addSubview:welcomeLabel];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.sunnyImage.alpha = 1.0f;
    [self.spinner stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isLanched = [[NSUserDefaults standardUserDefaults] boolForKey:FIRST_LAUNCH];
    
    if (self.isLanched == NO){
        
        
        [[NSUserDefaults standardUserDefaults] setObject:FROM_ADRESS forKey:FROM_DATA_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:TO_ADRESS forKey:TO_DATA_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:DATE forKey:DATE_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:TIME forKey:TIME_KEY];
               
        [[NSUserDefaults standardUserDefaults] setFloat:FROM_LAT_LAUNCH_LOCATION forKey:FROM_LATITUDE_KEY];
        [[NSUserDefaults standardUserDefaults] setFloat:FROM_LON_LAUNCH_LOCATION forKey:FROM_LONGITUDE_KEY];
        [[NSUserDefaults standardUserDefaults] setFloat:TO_LAT_LAUNCH_LOCATION forKey:TO_LATITUDE_KEY];
        [[NSUserDefaults standardUserDefaults] setFloat:TO_LON_LAUNCH_LOCATION forKey:TO_LONGITUDE_KEY];
        
        [[NSUserDefaults standardUserDefaults] setFloat:FROM_LAT_LAUNCH_LOCATION forKey:FROM_COORDINATE_LAT];
        [[NSUserDefaults standardUserDefaults] setFloat:FROM_LON_LAUNCH_LOCATION forKey:FROM_COORDINATE_LON];
        [[NSUserDefaults standardUserDefaults] setFloat:TO_LAT_LAUNCH_LOCATION forKey:TO_COORDINATE_LAT];
        [[NSUserDefaults standardUserDefaults] setFloat:TO_LON_LAUNCH_LOCATION forKey:TO_COORDINATE_LON];

        [[NSUserDefaults standardUserDefaults] setFloat:DIRECTION_DEGREES forKey:TRIP_DIRECTION_DEGREES];
        [[NSUserDefaults standardUserDefaults] setInteger:TRANPORT_TYPE_MODE forKey:TRANSPORT_TYPE];
        [[NSUserDefaults standardUserDefaults] setInteger:TIME_MONTH forKey:MONTH];
        [[NSUserDefaults standardUserDefaults] setFloat:TIME_HOUR forKey:TIME_IN_MINUTES];
        [[NSUserDefaults standardUserDefaults] setFloat:TOTAL_TIME forKey:TOTAL_TIME_TRAVEL_MINUTES];
        [[NSUserDefaults standardUserDefaults] setFloat:SUN_START_ANGLE forKey:FROM_SUN_INCLINATION];
        [[NSUserDefaults standardUserDefaults] setFloat:START_SUN forKey:START_SUN_POSSITION];
        [[NSUserDefaults standardUserDefaults] setFloat:END_SUN forKey:END_SUN_POSSITION];
        
        [[NSUserDefaults standardUserDefaults]  setObject:@"Berlin" forKey:FROM_LOCALITY_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:@"Amsterdam" forKey:TO_LOCALITY_KEY];
        [[NSUserDefaults standardUserDefaults] setFloat:480.00000 forKey:TIME_IN_MINUTES];
        [[NSUserDefaults standardUserDefaults] setObject:@"8:00" forKey:TIME_KEY];
        
        
        self.displayRoute.text = NSLocalizedString(@"Berlin - Amsterdam", @"Starting App default route");
        self.displayTripTime.text = NSLocalizedString(@"Athour",@"Starting App time");

        self.isLanched = YES;
        [[NSUserDefaults standardUserDefaults] setBool:self.isLanched forKey:FIRST_LAUNCH];
    
    } else{
    


        NSString *fromAddresse = [[NSUserDefaults standardUserDefaults] objectForKey:FROM_LOCALITY_KEY];

        NSString *toAddresse = [[NSUserDefaults standardUserDefaults] objectForKey:TO_LOCALITY_KEY];
        NSString *tripTime = [[NSUserDefaults standardUserDefaults] objectForKey:TIME_KEY];
        float timeo = [[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES];
//        NSString *timeType = [self.locationBrain checkAMOrPM:timeo];
        

//        int minutesToShow = [[NSUserDefaults standardUserDefaults] integerForKey:MINUTES_TO_SHOW_KEY];
//        NSString *atLocalized = NSLocalizedString(@"at", @"at");
        
        
        if (fromAddresse && toAddresse && tripTime){
            self.displayRoute.text = [NSString stringWithFormat:@"%@ - %@", fromAddresse, toAddresse];
            if (timeo>780.){
//                int hour = (timeo / 60)- 12;

                self.displayTripTime.text = [NSString stringWithFormat:@"%@ h", tripTime];

            }else{
                self.displayTripTime.text = [NSString stringWithFormat:@"%@ h", tripTime];
//                self.displayTripTime.text = [NSString stringWithFormat:@"%@ %@ %@ h",atLocalized, tripTime, timeType];

            }
            
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
