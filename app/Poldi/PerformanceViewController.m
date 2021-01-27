//
//  PerformanceViewController.m
//  Poldi
//
//  Created by admin on 01.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "PerformanceViewController.h"
#import "PoldiData.h"
#import "PerformanceBrain.h"
#import "CompassView.h"
#import "LocationBrain.h"
#import <QuartzCore/QuartzCore.h>
//#import "PoldiViewController.h"
//#import <iAd/iAd.h>

@interface PerformanceViewController ()
{
    float degreesTestSunPossition;
    int seatSideKey; // 0 no one, 1 left, 2 right
    BOOL isTransportTypeVisible; // Show the view where the user hast to sit
    float colorOfSky; // 0 day, 0.5 midday, 1 night
    BOOL isFirstViewTransportTypeVisible; // changing between transport types (train and cars)
    BOOL isSunriseViewVisible;
    BOOL isSunriseViewFastShowed; // the first time will be slow showed
    int leftOrRightForNavTitle; // when the user tap once will show best seat, otherwise left or right.
    
}


//@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) PoldiData *poldiData;
@property (strong, nonatomic) PerformanceBrain *performanceBrain;
@property (strong, nonatomic) IBOutlet CompassView *compassView;
@property (strong, nonatomic) LocationBrain *locationBrain;
@property (nonatomic) BOOL isAlreadyLaunched;
@property (nonatomic, strong) UIView *oneTouchView;

@property (strong, nonatomic) UIView *transportTypeView;
@property (strong, nonatomic) UIView *transportTypeTextView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property (strong, nonatomic) UILabel *leftPercentSunny;
@property (strong, nonatomic) UILabel *leftSide;
@property (strong, nonatomic) UILabel *rightPercentSunny;
@property (strong, nonatomic) UILabel *rightSide;
@property (strong, nonatomic) UILabel *fromToDirection;
//@property (strong, nonatomic) UILabel *fromMaxTemp;
//@property (strong, nonatomic) UILabel *fromMinTemp;
//@property (strong, nonatomic) UILabel *toMaxTemp;
//@property (strong, nonatomic) UILabel *toMinTemp;
@property (strong, nonatomic) UILabel *fromMaxTemp;
@property (strong, nonatomic) UILabel *fromMinTemp;
@property (strong, nonatomic) UILabel *toMaxTemp;
@property (strong, nonatomic) UILabel *toMinTemp;
@property (strong, nonatomic) UILabel *tripTime;
@property (strong, nonatomic) UILabel *fromMaxTempLabel;
@property (strong, nonatomic) UILabel *fromMinTempLabel;
@property (strong, nonatomic) UILabel *toMaxTempLabel;
@property (strong, nonatomic) UILabel *toMinTempLabel;

//@property (weak, nonatomic) IBOutlet UILabel *travelTime;

@property (weak, nonatomic) IBOutlet UIButton *pressPullView;


@property (weak, nonatomic) IBOutlet UILabel *displaySeatPossition;
@property (strong, nonatomic) UIBarButtonItem *trashRoute;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUp;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapOneTouch;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTap;

@property (weak, nonatomic) IBOutlet UIButton *pressAfterSunriseButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (nonatomic) float left;
@property (nonatomic) float right;
@property (nonatomic) float leftBack;
@property (nonatomic) float rightBack;
@property (nonatomic) float leftFront;
@property (nonatomic) float rightFront;
@property (nonatomic) float trainLeftFront;
@property (nonatomic) float trainLeftBack;
@property (nonatomic) float trainRightFront;
@property (nonatomic) float trainRightBack;

// CompassView origin: x, y size: width, height
@property (nonatomic) float compassX;
@property (nonatomic) float compassY;
@property (nonatomic) float compassW;
@property (nonatomic) float compassH;

@property (nonatomic) float transportW;
@property (nonatomic) float transportH;

@property (strong, nonatomic) UIFont *fontBG;     // 50
@property (strong, nonatomic) UIFont *fontMD;     // 30
@property (strong, nonatomic) UIFont *fontMS;     // 20
@property (strong, nonatomic) UIFont *fontMSLight;// 20
@property (strong, nonatomic) UIFont *fontSM;     // 14
@property (strong, nonatomic) UIFont *fontXS;     // 10

@property (nonatomic) int seatPosition;
@property (nonatomic) BOOL seatTrainLeftBackPossition;
@property (nonatomic) BOOL seatTrainLeftFrontProssition;
@property (nonatomic) BOOL seatTrainRightBackPossition;
@property (nonatomic) BOOL seatTrainRightFrontPossition;

@property (nonatomic) BOOL isTempFound; // help me to remove fromTemp and toTemp labels; it might happend is no internet conn.

@property (nonatomic, strong) NSString *textForSunriseBox;
@property (nonatomic, strong) NSString *textForSunriseBoxSecond;

@property (nonatomic) NSInteger transportType;

@end

@implementation PerformanceViewController

@synthesize sunPossition = _sunPossition;
@synthesize compassView = _compassView;


- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (CompassView *)compassView
{
    if (!_compassView){
        _compassView = [[CompassView alloc] init];
    }
    return _compassView;
    
}

- (UISwipeGestureRecognizer *)swipeUp
{
    if (!_swipeUp){
        _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showInfoView)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUp;
}

- (IBAction)pressInfo:(id)sender {
    [self showInfoView];
}

- (void) showInfoView
{
    [self performSegueWithIdentifier:@"Show Info" sender:self];
}

- (void)setSunScale:(float)sunScale
{
    _sunScale = sunScale;
    [self.compassView setNeedsDisplay];
}

- (void)setSunPossition:(float)sunPossition
{
    _sunPossition = sunPossition;
    [self.compassView setNeedsDisplay];
}

- (UIBarButtonItem *)trashRoute
{
    _trashRoute = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(pressTrash)];
    return _trashRoute;
}
- (void)pressTrash
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
}

- (LocationBrain *)locationBrain
{
    if (!_locationBrain){
        _locationBrain = [[LocationBrain alloc] init];
    }
    return _locationBrain;
}

- (PerformanceBrain *)performanceBrain
{
    if (!_performanceBrain){
        _performanceBrain = [[PerformanceBrain alloc] init];
    }
    return _performanceBrain;
}

- (PoldiData *)poldiData
{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (float)transportW{
    if (!_transportW) {
        _transportW = self.transportTypeView.bounds.size.width;
    }
    return _transportW;
}

- (float)transportH{
    if (!_transportH) {
        _transportH = self.transportTypeView.bounds.size.height;
    }
    return _transportH;
}

- (float)compassX{
    if (!_compassX) {
        _compassX = self.compassView.bounds.origin.x;
    }
    return _compassX;
}

- (float)compassY{
    if (!_compassY) {
        _compassY = self.compassView.bounds.origin.y;
    }
    return _compassY;
}

- (float)compassW{
    if (!_compassW) {
        _compassW = self.compassView.bounds.size.width;
    }
    return _compassW;
}

- (float)compassH{
    if (!_compassH) {
        _compassH = self.compassView.bounds.size.height;
    }
    return _compassH;
}

- (UIFont *)fontSM{
    if (!_fontSM) {
        _fontSM = [UIFont fontWithName:FONT_TH size:SM_FONT];
    }
    return _fontSM;
}

- (UIFont *)fontXS{
    if (!_fontXS) {
        _fontXS = [UIFont fontWithName:FONT_TH size:XS_FONT];
    }
    return _fontXS;
}

- (UIFont *)fontMS{
    if (!_fontMS) {
        _fontMS = [UIFont fontWithName:FONT_TH size:MS_FONT];
    }
    return _fontMS;
}

- (UIFont *)fontMSLight{
    if (!_fontMSLight) {
        _fontMSLight = [UIFont fontWithName:FONT_LI size:MS_FONT];
    }
    return _fontMSLight;
}

- (UIFont *)fontMD{
    if (!_fontMD) {
        _fontMD = [UIFont fontWithName:FONT_TH size:MD_FONT];
    }
    return _fontMD;
}

- (UIFont *)fontBG{
    if (!_fontBG) {
        _fontBG = [UIFont fontWithName:FONT_UL size:BG_FONT];
    }
    return _fontBG;
}


- (UILabel *)leftPercentSunny{
    if (!_leftPercentSunny) {
        
        _leftPercentSunny = [[UILabel alloc] initWithFrame:CGRectMake(self.compassX + SM_DIS,
                                                                      ((self.compassH + TBAR_H) /2) - (self.fontBG.lineHeight/2),
                                                                      self.compassW /2,
                                                                      self.fontBG.lineHeight)];
        _leftPercentSunny.textAlignment = NSTextAlignmentLeft;
        _leftPercentSunny.font = self.fontBG;
    }
    return _leftPercentSunny;
}

- (UILabel *)leftSide{
    
    if (!_leftSide) {
        _leftSide = [[UILabel alloc] initWithFrame:CGRectMake(self.compassX + SM_DIS,
                                                              self.leftPercentSunny.frame.origin.y + self.fontBG.lineHeight,
                                                              self.compassW /2,
                                                              self.fontSM.lineHeight)];
        _leftSide.textAlignment = NSTextAlignmentLeft;
        _leftSide.font = self.fontSM;
    }
    return _leftSide;
}

- (UILabel *)rightPercentSunny{
    if (!_rightPercentSunny) {
        
        _rightPercentSunny = [[UILabel alloc] initWithFrame:CGRectMake(self.compassW - (self.compassW/2)- SM_DIS,
                                                                       ((self.compassH + TBAR_H) /2) - (self.fontBG.lineHeight/2),
                                                                       self.compassW /2,
                                                                       self.fontBG.lineHeight)];
        _rightPercentSunny.textAlignment = NSTextAlignmentRight;
        _rightPercentSunny.font = self.fontBG;
    }
    return _rightPercentSunny;
}

- (UILabel *)rightSide{
    
    if (!_rightSide) {
        _rightSide = [[UILabel alloc] initWithFrame:CGRectMake(self.compassW - (self.compassW/2) - SM_DIS,
                                                               self.rightPercentSunny.frame.origin.y + self.fontBG.lineHeight,
                                                               self.compassW /2,
                                                               self.fontSM.lineHeight)];
        _rightSide.textAlignment = NSTextAlignmentRight;
        _rightSide.font = self.fontSM;
    }
    return _rightSide;
}

- (UILabel *)fromToDirection{
    if (!_fromToDirection){
        _fromToDirection = [[UILabel alloc] init];
        _fromToDirection.text = [NSString stringWithFormat:@"%@ - %@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:FROM_LOCALITY_KEY],
                                 [[NSUserDefaults standardUserDefaults] objectForKey:TO_LOCALITY_KEY]];
//        CGSize text = [_fromToDirection.text sizeWithFont:self.fontMD];
        CGSize text = [_fromToDirection.text sizeWithAttributes:@{NSFontAttributeName:self.fontMD}];
        CGFloat textW = text.width;
        
        float textMaxW = self.compassW - (BG_DIS * 2);
        float textX = self.compassX + BG_DIS;

        if (textW < textMaxW) {
            textMaxW = textW;
            textX = (self.compassW / 2) - (textW / 2);
        }else{
            textW = textMaxW;
        }
        
        _fromToDirection.frame = CGRectMake(textX, self.compassH - (self.compassH / 6), textW, self.fontMD.lineHeight);
        
        _fromToDirection.textColor = sunnylightyellow;
        _fromToDirection.textAlignment = NSTextAlignmentCenter;
        _fromToDirection.font = self.fontMD;
        _fromToDirection.adjustsFontSizeToFitWidth = YES;
        
    }
    return _fromToDirection;
}



- (UILabel *)fromMaxTemp{
    if (!_fromMaxTemp) {
        
        CGPoint point = self.fromToDirection.frame.origin;
        CGSize  size  = self.fromToDirection.frame.size;
        
        _fromMaxTemp = [[UILabel alloc] init];
        _fromMaxTemp.frame = CGRectMake(point.x, point.y + size.height,  size.width/5, self.fontMS.lineHeight);
        
        _fromMaxTemp.textColor = sunnylightyellow;
        _fromMaxTemp.textAlignment = NSTextAlignmentLeft;
        _fromMaxTemp.font = self.fontMS;
        _fromMaxTemp.adjustsFontSizeToFitWidth = YES;
    }
    return _fromMaxTemp;
}

- (UILabel *)fromMinTemp{
    if (!_fromMinTemp) {
        CGPoint point = self.fromToDirection.frame.origin;
        CGSize  size  = self.fromToDirection.frame.size;
        CGSize fromMaxSize = self.fromMaxTemp.frame.size;
        
        _fromMinTemp = [[UILabel alloc] initWithFrame:CGRectMake(point.x + fromMaxSize.width,
                                                                 point.y + size.height,
                                                                 size.width/5,
                                                                 self.fontMS.lineHeight)];
        _fromMinTemp.textColor = sunnylightyellow;
        _fromMinTemp.textAlignment = NSTextAlignmentLeft;
        _fromMinTemp.font = self.fontMS;
        _fromMinTemp.adjustsFontSizeToFitWidth = YES;
    }
    return _fromMinTemp;
}

- (UILabel *)toMaxTemp{
    if (!_toMaxTemp) {
        CGPoint point = self.fromToDirection.frame.origin;
        CGSize  size  = self.fromToDirection.frame.size;
        
        _toMaxTemp = [[UILabel alloc] initWithFrame:CGRectMake(point.x + size.width - size.width/5,
                                                            point.y + size.height,
                                                            size.width/5,
                                                            self.fontMS.lineHeight)];
        _toMaxTemp.textColor = sunnylightyellow;
        _toMaxTemp.textAlignment = NSTextAlignmentRight;
        _toMaxTemp.font = self.fontMS;
        _toMaxTemp.adjustsFontSizeToFitWidth = YES;

    }
    return _toMaxTemp;
}

- (UILabel *)toMaxTempLabel{
    if (!_toMaxTempLabel) {
        
        CGPoint point = self.toMaxTemp.frame.origin;
        CGSize size = self.toMaxTemp.frame.size;
        
        _toMaxTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x,
                                                                      point.y + size.height - (size.height/6),
                                                                      size.width,
                                                                      self.fontXS.lineHeight)];
        _toMaxTempLabel.textColor = sunnylightyellow;
        _toMaxTempLabel.textAlignment = NSTextAlignmentRight;
        _toMaxTempLabel.font = self.fontXS;
        _toMaxTempLabel.text = @"max";
    }
    
    return _toMaxTempLabel;
}

- (UILabel *)toMinTemp{
    if (!_toMinTemp) {
        CGPoint point = self.toMaxTemp.frame.origin;
        CGSize  size  = self.toMaxTemp.frame.size;
        
        _toMinTemp = [[UILabel alloc] initWithFrame:CGRectMake(point.x - size.width,
                                                            point.y,
                                                            size.width,
                                                            self.fontMS.lineHeight)];
        _toMinTemp.textColor = sunnylightyellow;
        _toMinTemp.textAlignment = NSTextAlignmentRight;
        _toMinTemp.font = self.fontMS;
        _toMinTemp.adjustsFontSizeToFitWidth = YES;
        
    }
    return _toMinTemp;
}

- (UILabel *)toMinTempLabel{
    if (!_toMinTempLabel) {
        
        CGPoint point = self.toMinTemp.frame.origin;
        CGSize size = self.toMinTemp.frame.size;
        
        _toMinTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x,
                                                                    point.y + size.height - (size.height/6),
                                                                    size.width,
                                                                    self.fontXS.lineHeight)];
        _toMinTempLabel.textColor = sunnylightyellow;
        _toMinTempLabel.textAlignment = NSTextAlignmentRight;
        _toMinTempLabel.font = self.fontXS;
        _toMinTempLabel.text = @"min";
    }
    
    return _toMinTempLabel;
}

- (UILabel *)fromMaxTempLabel{
    if (!_fromMaxTempLabel) {

        CGPoint point = self.fromMaxTemp.frame.origin;
        CGSize size = self.fromMaxTemp.frame.size;
        
        _fromMaxTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x,
                                                                     point.y + size.height - (size.height/6),
                                                                     size.width,
                                                                     self.fontXS.lineHeight)];
        _fromMaxTempLabel.textColor = sunnylightyellow;
        _fromMaxTempLabel.textAlignment = NSTextAlignmentLeft;
        _fromMaxTempLabel.font = self.fontXS;
        _fromMaxTempLabel.text = @"max";
    }
    
    return _fromMaxTempLabel;
}

- (UILabel *)fromMinTempLabel{
    if (!_fromMinTempLabel) {
        
        CGPoint point = self.fromMinTemp.frame.origin;
        CGSize size = self.fromMinTemp.frame.size;
        
        _fromMinTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x,
                                                                      point.y + size.height - (size.height/6),
                                                                      size.width,
                                                                      self.fontXS.lineHeight)];
        _fromMinTempLabel.textColor = sunnylightyellow;
        _fromMinTempLabel.textAlignment = NSTextAlignmentLeft;
        _fromMinTempLabel.font = self.fontXS;
        _fromMinTempLabel.text = @"min";
    }
    
    return _fromMinTempLabel;
}

- (UILabel *)tripTime{
    if (!_tripTime) {
        CGPoint point = self.fromToDirection.frame.origin;
        CGSize  size  = self.fromToDirection.frame.size;
        
        CGSize  tempSize  = self.fromMaxTemp.frame.size;
        CGSize  tempSizeLabels = self.fromMaxTempLabel.frame.size;
        
        if (!self.isTempFound) {
            tempSize.height = 0;
            tempSizeLabels.height = 0;
        }
        
        _tripTime = [[UILabel alloc] initWithFrame:CGRectMake(point.x,
                                                              point.y + size.height + tempSize.height + tempSizeLabels.height,
                                                              size.width,
                                                              self.fontSM.lineHeight)];
        _tripTime.text = [NSString stringWithFormat:@"%@ %@ h",[[NSUserDefaults standardUserDefaults] stringForKey:DATE_KEY], [[NSUserDefaults standardUserDefaults] stringForKey:TIME_KEY]];
        _tripTime.font = self.fontSM;
        _tripTime.textAlignment = NSTextAlignmentRight;
        _tripTime.textColor = sunnylightyellow;
        _tripTime.adjustsFontSizeToFitWidth = YES;
    }
    return _tripTime;
}

- (void)showWeather{
    
    NSDictionary * weather = NULL;
    
    float tempLat = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_TEMP_LAT];
    float tempLon = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_TEMP_LON];
    float fromCoordLat = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_COORDINATE_LAT];
    float fromCoordLon = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_COORDINATE_LON];
    float toTempLat = [[NSUserDefaults standardUserDefaults] floatForKey:TO_TEMP_LAT];
    float toCoordLat = [[NSUserDefaults standardUserDefaults] floatForKey:TO_COORDINATE_LAT];
    float toTempLon = [[NSUserDefaults standardUserDefaults] floatForKey:TO_TEMP_LON];
    float toCoordLon = [[NSUserDefaults standardUserDefaults] floatForKey:TO_COORDINATE_LON];
    
    NSDate *now = [NSDate date];
    NSString *strNow = [[NSString alloc] initWithFormat:@"%@", now];
    NSArray *arrNow = [strNow componentsSeparatedByString:@"-"];
    NSArray *arrDay = [[arrNow objectAtIndex:2] componentsSeparatedByString:@" "];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *today = [NSString stringWithFormat:@"%@ %@, %@",
                       [[dateFormatter monthSymbols] objectAtIndex:([[arrNow objectAtIndex:1] integerValue] - 1)],
                       [arrDay objectAtIndex:0],
                       [arrNow objectAtIndex:0]];
    
    if (![[NSUserDefaults standardUserDefaults] floatForKey:FROM_TEMP] ||
        (tempLat != fromCoordLat)  ||
        (tempLon != fromCoordLon)  ||
        (toTempLat   != toCoordLat)||
        (toTempLon   != toCoordLon) ){
        
        if ([today isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:DATE_KEY]]) {
            weather = [self findWeatherLatitue:fromCoordLat longitude:fromCoordLon];
        }
        
        if (weather){
            int tempMax = [[weather objectForKey:@"temp_max"] intValue];
            int tempMin = [[weather objectForKey:@"temp_min"] intValue];
            
            // From location implementation
            NSString *fromTemp = [NSString stringWithFormat:@"%d°", tempMax];
            self.fromMaxTemp.text = fromTemp;
            
            NSString *fromMinTemp = [NSString stringWithFormat:@"%d°", tempMin];

            self.fromMinTemp.text = fromMinTemp;
            [self.compassView addSubview:self.fromMaxTemp];
            [self.compassView addSubview:self.fromMinTemp];
            [self.compassView addSubview:self.fromMaxTempLabel];
            [self.compassView addSubview:self.fromMinTempLabel];

            
            [[NSUserDefaults standardUserDefaults] setObject:fromTemp forKey:FROM_TEMP];
            [[NSUserDefaults standardUserDefaults] setObject:fromMinTemp forKey:FROM_MIN_TEMP];
            [[NSUserDefaults standardUserDefaults] setFloat:tempLat forKey:FROM_TEMP_LAT];
            [[NSUserDefaults standardUserDefaults] setFloat:tempLon forKey:FROM_TEMP_LON];
            
            // To location implementation
            tempLat = [[NSUserDefaults standardUserDefaults] floatForKey:TO_COORDINATE_LAT];
            tempLon = [[NSUserDefaults standardUserDefaults] floatForKey:TO_COORDINATE_LON];
            
            weather = [self findWeatherLatitue:tempLat longitude:tempLon];
            tempMax = [[weather objectForKey:@"temp_max"] intValue];
            tempMin = [[weather objectForKey:@"temp_min"] intValue];
            NSString *toTemp = [NSString stringWithFormat:@"%d°", tempMax];
            NSString *toMinTemp = [NSString stringWithFormat:@"%d°", tempMin];
            self.toMaxTemp.text = toTemp;
            self.toMinTemp.text = toMinTemp;
            [self.compassView addSubview:self.toMaxTemp];
            [self.compassView addSubview:self.toMinTemp];
            [self.compassView addSubview:self.toMaxTempLabel];
            [self.compassView addSubview:self.toMinTempLabel];
            [[NSUserDefaults standardUserDefaults] setObject:toTemp forKey:TO_TEMP];
            [[NSUserDefaults standardUserDefaults] setObject:toMinTemp forKey:TO_MIN_TEMP];
            [[NSUserDefaults standardUserDefaults] setFloat:tempLat forKey:TO_TEMP_LAT];
            [[NSUserDefaults standardUserDefaults] setFloat:tempLon forKey:TO_TEMP_LON];
            
            self.isTempFound = YES;
        }else{
            // remove fromTemp and toTemp space
            self.isTempFound = NO;
        }
    }else{
        if ([today isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:DATE_KEY]]) {
            self.fromMaxTemp.text = [[NSUserDefaults standardUserDefaults] objectForKey:FROM_TEMP];
            self.fromMinTemp.text = [[NSUserDefaults standardUserDefaults] objectForKey:FROM_MIN_TEMP];
            
            self.toMaxTemp.text = [[NSUserDefaults standardUserDefaults] objectForKey:TO_TEMP];
            self.toMinTemp.text = [[NSUserDefaults standardUserDefaults] objectForKey:TO_MIN_TEMP];
            
            [self.compassView addSubview:self.fromMaxTemp];
            [self.compassView addSubview:self.fromMinTemp];
            [self.compassView addSubview:self.fromMaxTempLabel];
            [self.compassView addSubview:self.fromMinTempLabel];
            
            [self.compassView addSubview:self.toMaxTemp];
            [self.compassView addSubview:self.toMinTemp];
            [self.compassView addSubview:self.toMinTempLabel];
            [self.compassView addSubview:self.toMaxTempLabel];

            
            self.isTempFound = YES;
        }else{
            self.isTempFound = NO;
        }

    }
/*
    if (weather) { // check if there is internet
        
        
    }else{
        // remove fromTemp and toTemp space
        self.isTempFound = NO;
    }
*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Adding iAd view

//    CGRect adRect = CGRectMake(0, self.view.bounds.size.height- AD_HEIGHT, AD_WIDTH, AD_HEIGHT);
//    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:adRect];
//    [adView setAutoresizesSubviews:UIViewAutoresizingFlexibleWidth];
//    [self.view addSubview:adView];

    
    self.seatPosition = 505;
    leftOrRightForNavTitle = 404;
    
    self.isAlreadyLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:ALREADY_LANCHED];
    
    
    isTransportTypeVisible = NO;
    isFirstViewTransportTypeVisible = YES;
    
    self.pressAfterSunriseButton.enabled = NO;
    
    [self.view addGestureRecognizer:self.swipeUp];
    
    self.transportType = [[NSUserDefaults standardUserDefaults] integerForKey:TRANSPORT_TYPE];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTransportType)];
    self.tap.numberOfTapsRequired = 1;
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTransportDraw)];
    self.doubleTap.numberOfTapsRequired = 2;
    [self.compassView addGestureRecognizer:self.tap];
    [self.compassView addGestureRecognizer:self.doubleTap];
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    self.navigationItem.leftBarButtonItem = self.trashRoute;
    self.navigationController.navigationBar.tintColor = sunnyblue;
    
    float destinyDegrees = [[NSUserDefaults standardUserDefaults] floatForKey:TRIP_DIRECTION_DEGREES];
    
    float startSunPossitionDegrees = [[NSUserDefaults standardUserDefaults] floatForKey:START_SUN_POSSITION];
    
    float endSunPossitionDegrees = [[NSUserDefaults standardUserDefaults] floatForKey:END_SUN_POSSITION];
    
    [self showWeather];
    
    // write percent in labels
    [self performeForecastOfDestiny:destinyDegrees withStartSun:startSunPossitionDegrees andEndSun:endSunPossitionDegrees];
    [self performeSunPossition:startSunPossitionDegrees endPossition:endSunPossitionDegrees];
    degreesTestSunPossition = startSunPossitionDegrees;
    
    [self.compassView addSubview:self.leftPercentSunny];
    [self.compassView addSubview:self.leftSide];
    [self.compassView addSubview:self.rightPercentSunny];
    [self.compassView addSubview:self.rightSide];
    [self.compassView addSubview:self.fromToDirection];

    //[self.compassView addSubview:self.fromMaxTemp];
    //[self.compassView addSubview:self.fromMinTemp];
//    [self.compassView addSubview:self.toTemp];
    //[self.compassView addSubview:self.toMinTemp];
    //[self.compassView addSubview:self.toMaxTemp];
    [self.compassView addSubview:self.tripTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSDictionary *) findWeatherLatitue:(float)lat longitude:(float)lon
{
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial", lat, lon];

    NSInteger temperatureType  = [[NSUserDefaults standardUserDefaults] integerForKey:TEMPERATURE_TYPE];
    if (temperatureType == 0) {
        url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric", lat, lon];
    }
    
    NSLog(@"URL %@", url);
    
    NSError *theError;
    NSString *weatherApiUrl = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:weatherApiUrl]];

    NSDictionary *weather = nil;
    BOOL success = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&theError];
    if (success) {
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&theError];
        NSDictionary *weatherResponse = [NSJSONSerialization JSONObjectWithData:response options:1 error:nil];
        weather = [weatherResponse objectForKey:@"main"];
    }else{
        // do nothing
    }
    return weather;
    
}


- (void) resetValuesWhenNotSunAtAll{

    [[NSUserDefaults standardUserDefaults] setFloat:0.0 forKey:LEFT_PERCENT];
    [[NSUserDefaults standardUserDefaults] setFloat:0.0 forKey:RIGHT_PERCENT];
    
    self.leftPercentSunny.text = @"";
    self.rightPercentSunny.text = @"";
    self.leftSide.text = @"";
    self.rightSide.text = @"";
    self.navigationItem.title = [NSString stringWithFormat:@"Sunny Boy"];
}


- (void) handleInterfaceWithPercentLeft:(float) percentLeft
{
    [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"Left", @"Left") forKey:BEST_SEAT];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Please Sit Left", @"Please Sit Left")];
    
    self.leftPercentSunny.text = [NSString stringWithFormat:@"%0.f%%", (100. - percentLeft)];
    
    self.rightPercentSunny.text = [NSString stringWithFormat:@"%0.f%%", percentLeft];
    //self.displayLeftPercent.text = [NSString stringWithFormat:@"%0.f%%", (100. - percentLeft)];

    [[NSUserDefaults standardUserDefaults] setFloat:percentLeft forKey:LEFT_PERCENT];
    [[NSUserDefaults standardUserDefaults] setFloat:(100. - percentLeft) forKey:RIGHT_PERCENT];
    
    if (colorOfSky == 1){ // night
        
        self.leftPercentSunny.textColor = sunnywhite;
        //self.displayLeftPercent.textColor = sunnywhite;
        
        self.rightPercentSunny.textColor = sunnyyellow; // yellow
        self.rightSide.textColor = sunnyyellow;
        self.leftSide.textColor = sunnywhite;
        
    } else if (colorOfSky == 0.5){
        
        self.leftPercentSunny.textColor = sunnydarkblue;
        //self.displayLeftPercent.textColor = sunnydarkblue; // dark blue
        
        self.rightPercentSunny.textColor = sunnygreen; // Sunny Boy blue
        self.rightSide.textColor = sunnygreen;
        self.leftSide.textColor = sunnydarkblue; // dark blue
        
        
    }else if(colorOfSky == 0){ // sunset
        
        //self.displayLeftPercent.textColor = sunnydarklightgray;
        self.leftPercentSunny.textColor = sunnydarklightgray;
        
        self.rightPercentSunny.textColor = sunnygreen; // Sunny Boy blue
        self.rightSide.textColor = sunnygreen;
        self.leftSide.textColor = sunnydarklightgray;
    }
    self.leftSide.text = NSLocalizedString(@"Left Side", @"Left Side");
    self.rightSide.text = NSLocalizedString(@"Right Side",@"Right Side");

}

- (void) handleInterfaceWithPercentRight:(float)percentRight
{
    //self.displayLeftPercent.text = [NSString stringWithFormat:@"%0.f%%", percentRight];
    self.leftPercentSunny.text = [NSString stringWithFormat:@"%0.f%%", percentRight];
    
    self.rightPercentSunny.text = [NSString stringWithFormat:@"%0.f%%", (100. - percentRight)];
    [[NSUserDefaults standardUserDefaults] setFloat:percentRight forKey:RIGHT_PERCENT];
    [[NSUserDefaults standardUserDefaults] setFloat:(100. - percentRight) forKey:LEFT_PERCENT];
    
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Please Sit Right",@"Please Sit Right")];
    [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"Right", @"Right") forKey:BEST_SEAT];

    
    if (colorOfSky == 1){ // night
        //self.displayLeftPercent.textColor = sunnyyellow; // yellow
        self.leftPercentSunny.textColor = sunnyyellow; // yellow
        
        self.leftSide.textColor = sunnyyellow;
        self.rightPercentSunny.textColor = sunnywhite;
        self.rightSide.textColor = sunnywhite;

    } else if (colorOfSky == 0.5){
        
        //self.displayLeftPercent.textColor = sunnygreen;
        self.leftPercentSunny.textColor = sunnygreen;
        
        self.rightPercentSunny.textColor = sunnydarkblue; // dark blue
        self.rightSide.textColor = sunnydarkblue; // dark blue
        self.leftSide.textColor = sunnygreen;
        
        
    
    } else if (colorOfSky == 0){ // sunset
        
        //self.displayLeftPercent.textColor = sunnygreen;
        self.leftPercentSunny.textColor = sunnygreen;
        
        self.rightPercentSunny.textColor = sunnydarklightgray;
        self.rightSide.textColor = sunnydarklightgray;
        self.leftSide.textColor = sunnygreen;

    }
    self.leftSide.text = NSLocalizedString(@"Left Side", @"Left Side");
    self.rightSide.text = NSLocalizedString(@"Right Side",@"Right Side");

}

- (void)performeForecastOfDestiny: (float) destinyDegrees withStartSun:(float)startSunPossitionDegrees andEndSun: (float)endSunPossitionDegrees
{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.spinner startAnimating];
    [self.navigationItem.leftBarButtonItem setCustomView:self.spinner];
    
    float travelTime = [[NSUserDefaults standardUserDefaults] floatForKey:TOTAL_TIME_TRAVEL_MINUTES];
    float worldLaps = travelTime / MAX_MINUTES_TIME;
    float month = [[NSUserDefaults standardUserDefaults] integerForKey:MONTH];
    float latitude0 = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY];
    float latitude1 = [[NSUserDefaults standardUserDefaults] floatForKey:TO_LATITUDE_KEY];

    float sunMirror = [self.performanceBrain findMirrorDegreesOfSunPossition:startSunPossitionDegrees];
    
    if (worldLaps <= 1 ){
        dispatch_queue_t performanceQueue = dispatch_queue_create("make calculation performance", NULL);
        dispatch_async(performanceQueue, ^{
            
            float sunAngle = 0;
            int seat = 0;
            float sunMirrorPossition = sunMirror;
            float sunPossition = startSunPossitionDegrees;
            float startTime = [[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES];
            float totalTime = startTime + travelTime;
            float time = startTime;
            
            while (time < totalTime) {
                float latitude = [self.performanceBrain findInterpolationLatitude0:latitude0 latitude1:latitude1 time0:startTime time1:totalTime time:time];

                if (latitude <= 23.f && latitude >= -23){ // check sun angle with different time
                    float timeFromBrain = [self.performanceBrain checkMirrorTimeOfSunAngleBetweenLatitude23andMinus23:latitude inMonth:month withTime:time];
                    sunAngle = [self.locationBrain findPercentOfSunWithLatitude:latitude inMonth:month andTime:timeFromBrain];
                    if (sunAngle < -1){
                        sunAngle *= -1;
                    }
                
                }else{
                    sunAngle = [self.locationBrain findPercentOfSunWithLatitude:latitude inMonth:month andTime:time];
                }
                
                if (sunAngle > 0){
                    seat = [self.performanceBrain findSeatWithSunPossition:sunPossition withMirrorSunPossition:sunMirrorPossition andDestination:destinyDegrees];
                    
                    if ( seat == 2 )    { self.right++; self.rightBack++; self.trainLeftFront++; self.trainRightBack++; self.trainRightFront++; }
                    else if (seat == 3) { self.right++; self.rightBack++; self.trainRightBack++; self.trainRightFront++;}
                    else if (seat == 4) { self.right++; self.rightFront++; self.trainRightBack++; self.trainRightFront++;}
                    else if (seat == 5) { self.right++; self.rightFront++; self.trainLeftBack++; self.trainRightBack++; self.trainRightFront++; }
                    else if (seat == 6) { self.left++;  self.leftBack++; self.trainRightFront++; self.trainLeftBack++; self.trainLeftFront++; }
                    else if (seat == 7) { self.left++;  self.leftBack++; self.trainLeftBack++; self.trainLeftFront++; }
                    else if (seat == 8) { self.left++;  self.leftFront++; self.rightBack++; self.trainLeftBack++; self.trainLeftFront++; }
                    else if (seat == 9) { self.left++;  self.leftFront++; self.trainLeftBack++; self.trainLeftFront++; }
                    
                }else if ( sunAngle <= 0 && (self.left == 0 && self.right == 0 ) ) { // checking if it was not sun at all
                    [self resetValuesWhenNotSunAtAll];
                    self.textForSunriseBox = NSLocalizedString(@"Keep the sun glasses in the bag", @"Keep the sun glasses in the bag");
                    self.textForSunriseBoxSecond = NSLocalizedString(@"not shining", @"not shining");

                }

                sunMirrorPossition += DEGREES_ON_HOUR_BY_TIME;
                if (sunMirrorPossition > 360){
                    sunMirrorPossition = 0;
                }
                
                sunPossition += DEGREES_ON_HOUR_BY_TIME;
                if (startTime > MAX_MINUTES_TIME){
                    startTime = 0;
                    sunPossition = 0;
                    totalTime -= MAX_MINUTES_TIME;
                }
                time ++;

            }
                       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            float totalSeats = self.left + self.right;
            float percentLeft = (self.left / totalSeats) * 100.;
            float percentRight = (self.right / totalSeats) * 100.;
            // CHECK CAR SEATS
            if (self.left > self.right){ // Seat left && Sun right
                seatSideKey = 1;
                if (self.leftBack > self.leftFront){
                    self.seatPosition = 2;
                }else{
                    self.seatPosition = 4;
                }
                
                [self handleInterfaceWithPercentLeft:percentLeft];
                
                leftOrRightForNavTitle = 0;
                
            }else if (self.right > self.left){ // Seat right && Sun left
                seatSideKey = 2;                
                if (self.rightBack > self.rightFront){
                    self.seatPosition = 3;
                }else{
                    self.seatPosition = 5;
                }

                [self handleInterfaceWithPercentRight:percentRight];
                leftOrRightForNavTitle = 1;
            }                

            // CHECK PLUS TRAIN SEATS
            float minimumPercentRequired = totalSeats / 1.8; // 55.5% bigger

            if (self.trainLeftBack >= minimumPercentRequired) {self.seatTrainLeftBackPossition = YES; }
            if (self.trainLeftFront >= minimumPercentRequired){self.seatTrainLeftFrontProssition = YES; }
            if (self.trainRightBack >= minimumPercentRequired){self.seatTrainRightBackPossition = YES; }
            if (self.trainRightFront>= minimumPercentRequired){self.seatTrainRightFrontPossition = YES;}
            
            
            if (latitude0 <= 23.f && latitude0 >= -23){ // check sun angle with different time
                float timeFromBrain = [self.performanceBrain checkMirrorTimeOfSunAngleBetweenLatitude23andMinus23:latitude0 inMonth:month withTime:startTime];
                float sunAngleStart = [self.locationBrain findPercentOfSunWithLatitude:latitude0 inMonth:month andTime:timeFromBrain];
                if (sunAngleStart < - 1){
                    sunAngleStart *= -1;
                }
                [self checkSunriseSitWithSunAngle:sunAngleStart];
                
            } else{
                float sunAngleStart = [self.locationBrain findPercentOfSunWithLatitude:latitude0 inMonth:month andTime:startTime];
                [self checkSunriseSitWithSunAngle:sunAngleStart];
            }
            [self.spinner stopAnimating]; self.navigationItem.leftBarButtonItem = self.trashRoute;
            
        });
    });
        
    }else {// Driving for more than a day is not supported, please reduce the distance.
        
        UIAlertView *moreThanADayAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Driving for more than a day is not supported, please reduce the distance. Thank you!", @"no more than a day") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [moreThanADayAlert show];
        [self.spinner stopAnimating]; self.navigationItem.leftBarButtonItem = self.trashRoute;
    }
}

- (void) checkSunriseSitWithSunAngle:(float)sunAngleStart{
    
    if (sunAngleStart <= 0 && (self.left > 0 || self.right > 0)) {
        if (self.left > self.right){
            //self.displayLeftPercent.textColor = sunnywhite;
            self.leftPercentSunny.textColor = sunnywhite;
            
            self.rightPercentSunny.textColor = sunnyyellow;
            self.rightSide.textColor = sunnyyellow;
            self.leftSide.textColor = sunnywhite;
            
            self.textForSunriseBox = [NSString stringWithFormat:NSLocalizedString(@"afert sunshine left", @"after sunshine left")];
            self.textForSunriseBoxSecond = [NSString stringWithFormat:NSLocalizedString(@"will be right.", @"will be right.")];
        }else{
            //self.displayLeftPercent.textColor = sunnyyellow;
            self.leftPercentSunny.textColor = sunnyyellow;
            
            self.rightPercentSunny.textColor = sunnywhite;
            self.rightSide.textColor = sunnywhite;
            self.leftSide.textColor = sunnyyellow;
            
            self.textForSunriseBox = [NSString stringWithFormat:NSLocalizedString(@"after sunshile right", @"after sunshile right")];
            self.textForSunriseBoxSecond = [NSString stringWithFormat:NSLocalizedString(@"will be left.", @"will be left.")];
        }
        
        self.pressAfterSunriseButton.enabled = YES;
        [self pressAfterSunrise:nil];
    
    }
    else if ( sunAngleStart <= 0 && self.left<= 0 && self.right <= 0){
        self.pressAfterSunriseButton.enabled = YES;
            [self pressAfterSunrise:nil];
    }
}

- (void) displayOneTouchInfo
{
        self.tapOneTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTransportType)];
    self.oneTouchView = [[UIView alloc] init];

    [self.oneTouchView setFrame:CGRectMake(self.view.frame.size.width/2 - ((self.view.frame.size.width - 105) /2),self.view.frame.size.height/2 - ((self.view.frame.size.height - 250) /2), self.view.frame.size.width - 105, self.view.frame.size.height - 250 )];
    [self.oneTouchView setAlpha:0.0f];

    [self.oneTouchView setBackgroundColor:sunnyblack];
    self.oneTouchView.layer.cornerRadius = 10;
    self.oneTouchView.layer.masksToBounds = YES;
    
    [self.oneTouchView addGestureRecognizer:self.tapOneTouch];

    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.oneTouchView.bounds.origin.x, self.oneTouchView.bounds.origin.y - 30, 200, 100)];
    welcomeLabel.textColor = sunnywhite;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = NSLocalizedString(@"Welcome", @"Welcome");
    welcomeLabel.alpha = 0;
    [self.oneTouchView bringSubviewToFront:welcomeLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.oneTouchView.bounds.origin.x, self.oneTouchView.bounds.size.height -100, 210, 100)];
    label.textColor = sunnywhite;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"oneTouch one time", @"oneTouch one time");
    label.alpha = 0;
    
    [self.oneTouchView bringSubviewToFront:label];

    UILabel *labelDos = [[UILabel alloc] initWithFrame:CGRectMake(self.oneTouchView.bounds.origin.x - 1, self.oneTouchView.bounds.size.height -80, 200, 100)];
    labelDos.textColor = sunnywhite;
    labelDos.backgroundColor = [UIColor clearColor];
    labelDos.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    labelDos.textAlignment = NSTextAlignmentCenter;
    labelDos.text = NSLocalizedString(@"oneTouch two times", @"oneTouch two times");
    labelDos.alpha = 0;
    [self.oneTouchView bringSubviewToFront:labelDos];
    
    UIImageView *dialog = [[UIImageView alloc] initWithFrame:CGRectMake(self.oneTouchView.bounds.size.width/2 -42,
                                                                        self.oneTouchView.bounds.size.height/2 - 73.4,
                                                                        84, 116)];
    [dialog setImage:[UIImage imageNamed:@"touchRelease@2x.png"]];
    dialog.alpha = 0;

    [UIView animateWithDuration:1.f delay:2.5f options:0 animations:^{
        [self.oneTouchView setAlpha:0.75f];
        label.alpha = 1.0f;
        labelDos.alpha = 1.0f;
        dialog.alpha = 1.0f;
        welcomeLabel.alpha = 1.0f;
        
    } completion:nil];
        
    [self.oneTouchView addSubview:welcomeLabel];
    [self.oneTouchView addSubview:label];
    [self.oneTouchView addSubview:dialog];
    [self.oneTouchView addSubview:labelDos];
    [self.view addSubview:self.oneTouchView];

    self.isAlreadyLaunched = YES;
    [[NSUserDefaults standardUserDefaults] setBool:self.isAlreadyLaunched forKey:ALREADY_LANCHED];

    
    
}


#define FROM_SUN_INCLINATION @"TravelPlannerTableViewController.FromSunInclinationKey"
- (float) checkDayNightOrReallyNight // > 20 day between 20 middelnight < 20 night
{
    float sunStatus = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_SUN_INCLINATION];
    
//    float sunStatus = [self.poldiData fromSunInclinationData];
    float scale = 0.;
    if (sunStatus > 20){ // day
        self.pressAfterSunriseButton.enabled = NO;
        colorOfSky = 0.;
        scale = 0;
                
        if (seatSideKey == 1){
            //self.displayLeftPercent.textColor = sunnygray;
            self.leftPercentSunny.textColor = sunnygray;
            
            self.rightPercentSunny.textColor = sunnyblue;

        }else if (seatSideKey == 2){
            //self.displayLeftPercent.textColor = sunnyblue;
            self.leftPercentSunny.textColor = sunnyblue;
            
            self.rightPercentSunny.textColor = sunnygray;

        }
        
        [self.pressPullView setImage:[UIImage imageNamed:@"pull@2x.png"] forState:UIControlStateNormal];
        
    }else if (sunStatus > 0 && sunStatus <= 20){
        scale = 0.5;
        colorOfSky = 0.5;
        self.pressAfterSunriseButton.enabled = NO;
        [self.pressPullView setImage:[UIImage imageNamed:@"pullDarkRedRelease@2x.png"] forState:UIControlStateNormal];
    
        if (seatSideKey == 1){
            //self.displayLeftPercent.textColor = sunnydarkgray;
            self.leftPercentSunny.textColor = sunnydarkgray;
            
            self.rightPercentSunny.textColor = sunnywhite;
            

        }else if (seatSideKey == 2){
            //self.displayLeftPercent.textColor = sunnywhite;
            self.leftPercentSunny.textColor = sunnywhite;
            
            self.rightPercentSunny.textColor = sunnydarkgray;
        }
        
        
    }else if (sunStatus == -1){
        scale = 1;
        colorOfSky = 1.;
        
        
        if (seatSideKey == 1){
            //self.displayLeftPercent.textColor = sunnywhite;
            self.leftPercentSunny.textColor = sunnywhite;
            
            self.rightPercentSunny.textColor = sunnyyellow;


        }else if (seatSideKey == 2){
            //self.displayLeftPercent.textColor = sunnyyellow;
            self.leftPercentSunny.textColor = sunnyyellow;
            
            self.rightPercentSunny.textColor = sunnywhite;
        }
        
        [self.pressPullView setImage:[UIImage imageNamed:@"pull_blueSkyRelease@2x.png"] forState:UIControlStateNormal];
        
    }
    
    if ((colorOfSky == 0.5) || (colorOfSky == 0)){ // sunset

        //        self.timeButton.imageView = [UIImage imageNamed:@"time@2x.png"];
        [self.timeButton setImage:[UIImage imageNamed:@"time@2x.png"] forState:UIControlStateNormal];
    }else{
        //self.travelTime.textColor = sunnyyellow;
        [self.timeButton setImage:[UIImage imageNamed:@"sunytime-yellow@2x.png"] forState:UIControlStateNormal];
    }
    
    return scale;
    
}

- (void)performeSunPossition:(float)degrees endPossition:(float)endDegrees;
{
    self.sunPossition = degrees;
    [self.compassView findSunPossition:self.sunPossition endSunPossition:endDegrees sunScale:[self checkDayNightOrReallyNight]];
    float skyType = [self checkDayNightOrReallyNight];
    if (self.isAlreadyLaunched == NO && ( skyType == 0 || skyType == 0.5 ) ){
        [self displayOneTouchInfo];
    }
    
}

- (void) drawACar
{
    UIView *horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/2, self.transportW,LINE_BORDER)];
    horizontalLineView.backgroundColor = sunnydarkgray;
    UIView *verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2, 0, LINE_BORDER, self.transportH/2)];
    verticalLineView.backgroundColor = sunnydarkgray;
    UIView *verticalFirstLineView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/3, self.transportH/2, LINE_BORDER, self.transportH/2)];
    verticalFirstLineView.backgroundColor = sunnydarkgray;
    UIView *verticalSecondLineView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/1.5, self.transportH/2, LINE_BORDER, self.transportH/2)];
    verticalSecondLineView.backgroundColor = sunnydarkgray;
    
    [self.transportTypeView addSubview:verticalSecondLineView];
    [self.transportTypeView addSubview:verticalFirstLineView];
    [self.transportTypeView addSubview:verticalLineView];
    [self.transportTypeView addSubview:horizontalLineView];
}

- (void) drawATrain
{
    UIView *verticalCorridorView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 - 5, 0, 10, self.transportH)];
    verticalCorridorView.backgroundColor = sunnydarkgray;
    
    UIView *horizontalCorridorLeftUp = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/4-5, self.transportW, 10)];
    horizontalCorridorLeftUp.backgroundColor = sunnydarkgray;

    
    UIView *horizontalCorridorLeftDown = [[UIView alloc] initWithFrame:CGRectMake(0, (self.transportH/2 + self.transportH/4) - 5 , self.transportW, 10)];
    horizontalCorridorLeftDown.backgroundColor = sunnydarkgray;
    
    
    UIView *leftSeatUp = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/2)/2, 0, LINE_BORDER, self.transportH)];
    leftSeatUp.backgroundColor = sunnydarkgray;
    
    UIView *rightSeatUp = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/4)*3, 0, LINE_BORDER, self.transportH)];
    rightSeatUp.backgroundColor = sunnydarkgray;
    
    UIView *middleSeat = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/2, self.transportW, LINE_BORDER)];
    middleSeat.backgroundColor = sunnydarkgray;
    
    [self.transportTypeView addSubview:verticalCorridorView];
    [self.transportTypeView addSubview:horizontalCorridorLeftUp];
    [self.transportTypeView addSubview:horizontalCorridorLeftDown];
    [self.transportTypeView addSubview:leftSeatUp];
    [self.transportTypeView addSubview:rightSeatUp];
    [self.transportTypeView addSubview:middleSeat];
}

/*          TRAIN VIEW
 *
 *             |    *    |
 *          *****************
 *             |    *    |
 *          -----------------
 *             |    *    |
 *          *****************
 *             |    *    |
 *
 */

- (void) drawBus{
    UIView *verticalCorridorView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 - 5, 0, 10, self.transportH)];
    verticalCorridorView.backgroundColor = sunnydarkgray;
    
    UIView *verticalCorridorLeftView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/4 - 0.5, 0, LINE_BORDER, self.transportH)];
    verticalCorridorLeftView.backgroundColor = sunnydarkgray;
    
    UIView *verticalCorridorRightView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 + self.transportW/4 - 0.5, 0, LINE_BORDER, self.transportH)];
    verticalCorridorRightView.backgroundColor = sunnydarkgray;
    
    UIView *horizontalCorridorLeftUp = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/3-0.5, self.transportW, LINE_BORDER)];
    horizontalCorridorLeftUp.backgroundColor = sunnydarkgray;
    
    UIView *horizontalCorridorLeftDown = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/1.5 - 0.5 , self.transportW, LINE_BORDER)];
    horizontalCorridorLeftDown.backgroundColor = sunnydarkgray;
    
    [self.transportTypeView addSubview:verticalCorridorView];
    [self.transportTypeView addSubview:verticalCorridorLeftView];
    [self.transportTypeView addSubview:verticalCorridorRightView];
    [self.transportTypeView addSubview:horizontalCorridorLeftUp];
    [self.transportTypeView addSubview:horizontalCorridorLeftDown];

}

- (void) drawRicksaw{
    UIView *verticalCorridorView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 - 0.5, 0, 1, self.transportH)];
    verticalCorridorView.backgroundColor = sunnydarkgray;
    [self.transportTypeView addSubview:verticalCorridorView];

}

- (void) drawTransportType:(int)type sitPlace:(int)sit
{

    
    UIView *sitView;
    if (type == 0){ // train
        [self drawATrain];
        
        if (sit == 0){
            
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW, self.transportH)];
            
            UIImageView *starSitFirst = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/2)/2)-15, (self.transportH/2 + self.transportH/4)+(self.transportH/8)-15, 31, 30)];
            starSitFirst.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitFirst];
            
            UIImageView *starSitSecond = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/4)*3)-15 , (self.transportH/2 + self.transportH/4)+(self.transportH/8)-15, 31, 30)];
            starSitSecond.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitSecond];
            
            UIImageView *starSitThird = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/4)-15, self.transportH/8 -15, 31, 30)];
            starSitThird.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitThird];
            
            UIImageView *starSitFourth = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/4)*3)-15, self.transportH/8 -15, 31, 30)];
            starSitFourth.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitFourth];

            UIImageView *starSitFifth = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/4)-15, (self.transportH/4 + self.transportH/8) - 15, 31, 30)];
            starSitFifth.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitFifth];
            
            UIImageView *starSitSixth = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2  + self.transportW/4 )-15, (self.transportH/2 + self.transportH/8) - 15, 31, 30)];
            starSitSixth.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitSixth];
            
            UIImageView *starSitSeventh = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/4)-15, (self.transportH/2 + self.transportH/8) - 15, 31, 30)];
            starSitSeventh.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitSeventh];

            
            UIImageView *starSitEighth = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2 + self.transportW/4 )-15, (self.transportH/4 + self.transportH/8) - 15, 31, 30)];
            starSitEighth.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitEighth];

        }

        else if (sit == 2){ // LEFT_BACK
//            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/1.5, (self.transportW/2-5)/2, self.transportH/3)]; // einzel
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/2 + self.transportH/4, self.transportW/2, self.transportH/3)]; // doppel
            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/2)/2)-15, (self.transportH/2 + self.transportH/4)+(self.transportH/8)-15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
        }

        else if (sit == 3){ // RIGHT_BACK
//            sitView = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/2)+((self.transportW/2-5)/2), self.transportH/1.5, (self.transportW/2)/2, self.transportH/3)]; // einzel
            sitView = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/2), self.transportH/2 + self.transportH/4, self.transportW/2, self.transportH/3)]; // doppel

            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/4)*3)-15 , (self.transportH/2 + self.transportH/4)+(self.transportH/8)-15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
        }
        else if (sit == 4){ // LEFT_FRONT
//            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.transportW/2-5)/2, self.transportH/3)]; // einzel
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW/2, self.transportH/4)]; // doppel
            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/4)-15, self.transportH/8 -15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
        }
        else if (sit == 5){ // RIGHT_FRONT
//            sitView = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/2)+((self.transportW/2)/2), 0, (self.transportW/2-5)/2, self.transportH/3)];
            sitView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2, 0, self.transportW/2, self.transportH/4)];
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/4)*3)-15, self.transportH/8 -15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
        }
        
        if (self.seatTrainLeftBackPossition == YES){
            // Draw star on sit
            UIView *sitTrainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/2 +0.5, self.transportW/2 -5, self.transportH/4 -5)];
            sitTrainView.backgroundColor = sunnygray;
            [self.transportTypeView addSubview:sitTrainView];
            
            UIView *leftSeatDown = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/2)/2, (self.transportH/2 +5), 1, self.transportH/4)];
            leftSeatDown.backgroundColor = sunnydarkgray;
            [self.transportTypeView addSubview:leftSeatDown];

            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/4)-15, (self.transportH/2 + self.transportH/8) - 15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];

        }

        if (self.seatTrainLeftFrontProssition == YES){
            
            UIView *sitTrainView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.transportH/4+5), self.transportW/2 -5, self.transportH/4 -5)];
            sitTrainView.backgroundColor = sunnygray;
            [self.transportTypeView addSubview:sitTrainView];
            
            UIView *leftSeatUp = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/2)/2, (self.transportH/4+5), 1, self.transportH/4)];
            leftSeatUp.backgroundColor = sunnydarkgray;
            [self.transportTypeView addSubview:leftSeatUp];
            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/4)-15, (self.transportH/4 + self.transportH/8) - 15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
        }

        if (self.seatTrainRightBackPossition == YES){
            UIView *sitTrainView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 +5, ((self.transportH/2)+0.5), self.transportW/2 -5, self.transportH/4 -5)];
            sitTrainView.backgroundColor = sunnygray;
            [self.transportTypeView addSubview:sitTrainView];
            
            UIView *rightSeatDown = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/4)*3,(self.transportH/2 +5), 1, self.transportH/4)];
            rightSeatDown.backgroundColor = sunnydarkgray;
            [self.transportTypeView addSubview:rightSeatDown];

            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2  + self.transportW/4 )-15, (self.transportH/2 + self.transportH/8) - 15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];

        }
        
        if (self.seatTrainRightFrontPossition == YES){
            UIView *sitTrainView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 +5, (self.transportH/2 - (self.transportH/4)+5), self.transportW/2 -5, self.transportH/4 -5)];
            sitTrainView.backgroundColor = sunnygray;
            [self.transportTypeView addSubview:sitTrainView];
            
            UIView *rightSeatUp = [[UIView alloc] initWithFrame:CGRectMake((self.transportW/4)*3,(self.transportH/4+5), 1, self.transportH/4)];
            rightSeatUp.backgroundColor = sunnydarkgray;
            [self.transportTypeView addSubview:rightSeatUp];
            
            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2 + self.transportW/4 )-15, (self.transportH/4 + self.transportH/8) - 15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
            
        }

        
    }if (type == 1){ // car
        [self drawACar];
        
        if (sit == 0){

            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW, self.transportH)];
        
            UIImageView *starSitFirst = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/3)/2-15.5, (self.transportH/2)+((self.transportH/2)/2)-15, 31, 30)];
            
            starSitFirst.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitFirst];
        
            UIImageView *starSitSecond = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/3 + self.transportW/3)+((self.transportW/3)/2-15.5), (self.transportH/2)+((self.transportH/2)/2)-15, 31, 30)];
            
            starSitSecond.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitSecond];

            UIImageView *starSitThird = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/2)/2)-15.5, ((self.transportH/2)/2)-15, 31, 30)];
            starSitThird.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitThird];
            
            UIImageView *starSitFourth = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2+((self.transportW/2)/2)-15, ((self.transportH/2)/2)-15, 31, 30)];
            starSitFourth.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitFourth];

            UIImageView *starSitFifth = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2-15, (self.transportH/2)+((self.transportH/2)/2)-15, 31, 30)];
            starSitFifth.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSitFifth];
        
        
        }
        else if (sit == 2){ // LEFT_BACK
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/2, self.transportW/3, self.transportH/2)];

            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/3)/2-15.5, (self.transportH/2)+((self.transportH/2)/2)-15, 31, 30)];
            
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
            
            
        }else if (sit == 3){ // RIGHT_BACK
            sitView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/3 + self.transportW/3, self.transportH/2, self.transportW/3, self.transportH/2)];
            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/3 + self.transportW/3)+((self.transportW/3)/2-15.5), (self.transportH/2)+((self.transportH/2)/2)-15, 31, 30)];
            
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
            
        
        }else if (sit == 4){ // LEFT_FRONT
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW/2, self.transportH/2)];

            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake(((self.transportW/2)/2)-15.5, ((self.transportH/2)/2)-15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
            
        
        }else if (sit == 5){ // RIGHT_FRONT
            sitView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2, 0, self.transportW/2, self.transportH/2)];
            
            UIImageView *starSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2+((self.transportW/2)/2)-15, ((self.transportH/2)/2)-15, 31, 30)];
            starSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starSit];
            
        }
        
    }else if (type == 2){ // BUS
        [self drawBus];
        if (sit == 0){
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW, self.transportH)];
            
            UIImageView *starLeftCenterSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, self.transportH/2 -15, 31, 30)];
            starLeftCenterSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftCenterSit];
            
            UIImageView *starRightCenterSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + self.transportW/4 -15, self.transportH/2 -15, 31, 30)];
            starRightCenterSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightCenterSit];
            
            
            UIImageView *starLeftUpSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, ((self.transportH/3)/2) -15, 31, 30)];
            starLeftUpSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftUpSit];
            
            UIImageView *starRightUpSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2 + self.transportW/4) -15, ((self.transportH/3)/2) -15, 31, 30)];
            starRightUpSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightUpSit];
            
            
            UIImageView *starLeftDownSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, (self.transportH - self.transportH/3/2 ) -15, 31, 30)];
            starLeftDownSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftDownSit];
            
            UIImageView *starRightDownSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + self.transportW/4 -15, (self.transportH - self.transportH/3/2 ) -15, 31, 30)];
            starRightDownSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightDownSit];
            

            
        }
        else if (sit == 2){ // LEFT_BACK
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, self.transportH/3+0.5, self.transportW/2 , self.transportH/2 + self.transportH/4)];

            UIImageView *starLeftDownSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, (self.transportH - self.transportH/3/2 ) -15, 31, 30)];
            starLeftDownSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftDownSit];
            
            
            UIImageView *starLeftCenterSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, self.transportH/2 -15, 31, 30)];
            starLeftCenterSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftCenterSit];
        
        }else if (sit == 3){ // RIGHT_BACK
            sitView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2 +5, self.transportH/3+0.5, self.transportW/2 , self.transportH/2 + self.transportH/4)];
            
            UIImageView *starRightDownSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + self.transportW/4 -15, (self.transportH - self.transportH/3/2 ) -15, 31, 30)];
            starRightDownSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightDownSit];
            
            UIImageView *starRightCenterSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + self.transportW/4 -15, self.transportH/2 -15, 31, 30)];
            starRightCenterSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightCenterSit];
            
        
            
        }else if (sit == 4){ // LEFT_FRONT
            
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW/2 , self.transportH/1.5 + 0.5)];
            
            
            UIImageView *starLeftCenterSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, self.transportH/2 -15, 31, 30)];
            starLeftCenterSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftCenterSit];
            
            UIImageView *starLeftUpSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/4 -15, ((self.transportH/3)/2) -15, 31, 30)];
            starLeftUpSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftUpSit];
            
        }else if (sit == 5){ // RIGHT_FRONT
            sitView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2, 0, self.transportW/2 , self.transportH/1.5 + 0.5)];
            
            UIImageView *starRightCenterSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + self.transportW/4 -15, self.transportH/2 -15, 31, 30)];
            starRightCenterSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightCenterSit];
            
            UIImageView *starRightUpSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2 + self.transportW/4) -15, ((self.transportH/3)/2) -15, 31, 30)];
            starRightUpSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightUpSit];
        
            
        }
                
    }else if (type == 3){ // RICKSAW
        [self drawRicksaw];
        if (sit == 0){
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW, self.transportH)];

            UIImageView *starLeftSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2 - (self.transportW/2 / 2))-15, (self.transportH/2)-15, 31, 30)];
            starLeftSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftSit];
            
            UIImageView *starRightSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + (self.transportW/2 / 2) -15, (self.transportH/2)-15, 31, 30)];
            starRightSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightSit];
        }
        
        else if (sit == 2 || sit == 4){ // LEFT
            sitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.transportW/2, self.transportH)];
            
            UIImageView *starLeftSit = [[UIImageView alloc] initWithFrame:CGRectMake((self.transportW/2 - (self.transportW/2 / 2))-15, (self.transportH/2)-15, 31, 30)];
            starLeftSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starLeftSit];
        }
        else if (sit == 3 || sit == 5){ // RIGHT
            sitView = [[UIView alloc] initWithFrame:CGRectMake(self.transportW/2, 0, self.transportW/2, self.transportH)];
            
            UIImageView *starRightSit = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportW/2 + (self.transportW/2 / 2) -15, (self.transportH/2)-15, 31, 30)];
            starRightSit.image = [UIImage imageNamed:@"star_sit_dark_grayRelease@2x.png"];
            [self.transportTypeView addSubview:starRightSit];
        }
    
    }
        sitView.backgroundColor = sunnygray;
        //    sitView.backgroundColor = UIColorFromRGB(0x425C74);
        [self.transportTypeView insertSubview:sitView atIndex:0];
        //    [self.transportTypeView addSubview:sitView];
    
}


- (void) changeTransportDraw
{
    [self.transportTypeView removeFromSuperview];

    
    if (self.seatPosition != 505){
//        NSLog(@"in change transport leftOrRight %d", leftOrRightForNavTitle);

        self.navigationItem.title = NSLocalizedString(@"best seats", @"best seats");
        
        NSInteger originalTransportType = [[NSUserDefaults standardUserDefaults] integerForKey:TRANSPORT_TYPE];
        
        if (originalTransportType == 0 || originalTransportType == 1){
            
            if (self.transportType == 0){
                [self makeTheDrawOfType:1];
                [self makeTheDrawForTextType:1];
                self.transportType = 1;
            }else if (self.transportType == 1){
                [self makeTheDrawOfType:0];
                [self makeTheDrawForTextType:0];
                self.transportType = 0;
            }
        }
        else if (originalTransportType == 2){
            if (self.transportType == 2){
                [self makeTheDrawOfType:0];
                [self makeTheDrawForTextType:0];
                self.transportType = 0;
            }else if (self.transportType == 0){
                [self makeTheDrawOfType:2];
                [self makeTheDrawForTextType:2];
                self.transportType = 2;
            }
            
        }
        else if (originalTransportType == 3){
            if (self.transportType == 3){
                [self makeTheDrawOfType:0];
                [self makeTheDrawForTextType:0];
                self.transportType = 0;
            }else if (self.transportType == 0){
                [self makeTheDrawOfType:3];
                [self makeTheDrawForTextType:3];
                self.transportType = 3;
            }
            
        }
        
        [self.compassView addSubview:self.transportTypeView];
        [self.compassView bringSubviewToFront:self.transportTypeView];
        [self.tap requireGestureRecognizerToFail:self.doubleTap];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [self.transportTypeView setAlpha:0.75];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
        isTransportTypeVisible = YES;
        
        [self.compassView addSubview:self.transportTypeTextView];
        [self.compassView bringSubviewToFront:self.transportTypeTextView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [self.transportTypeTextView setAlpha:1];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
        
        [UIView animateWithDuration:2 animations:^{
            [self.transportTypeTextView setAlpha:0];
            
        }];
        
    }

}

- (void) makeTheDrawForTextType:(int)type
{
    self.transportTypeTextView = [[UIView alloc] initWithFrame:CGRectMake(self.compassView.frame.origin.x, self.compassView.frame.origin.y, self.compassView.frame.size.width - 75, self.compassView.frame.size.height/3)];
    [self.transportTypeTextView setAlpha:0];
    self.transportTypeTextView.center = self.transportTypeView.center;
    [self.transportTypeTextView setBackgroundColor:sunnyblack];
    self.transportTypeTextView.layer.borderWidth = 2;
    self.transportTypeTextView.layer.borderColor = sunnyblack.CGColor;
    self.transportTypeTextView.layer.cornerRadius = 5;
    self.transportTypeTextView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.transportTypeTextView.bounds.size.width/2-100, self.transportTypeTextView.bounds.size.height-(self.transportTypeTextView.bounds.size.height/6), 200, 20)];
    
    label.textColor = sunnywhite;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    //label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *dialog = [[UIImageView alloc] init];
    dialog.alpha = 0.90;
    if (type == 0) {
        // WRITE TEXT TRAIN
        label.text = NSLocalizedString(@"Train mode", @"Train mode");
        [dialog setFrame:CGRectMake(self.transportTypeTextView.bounds.size.width/2 -12.5, self.transportTypeTextView.bounds.size.height - (self.transportTypeTextView.bounds.size.height/ 2) - 45, 25, 90)];
        dialog.image = [UIImage imageNamed:@"trainDialogRelease@2x.png"];
        
    }else if (type == 1){
        // WRITE TEXT CAR
        label.text = NSLocalizedString(@"Car mode", @"Car mode");
        [dialog setFrame:CGRectMake(self.transportTypeTextView.bounds.size.width/2 -23, self.transportTypeTextView.bounds.size.height - (self.transportTypeTextView.bounds.size.height/ 2) - 45, 46, 90)];
        dialog.image = [UIImage imageNamed:@"carDialogRelease@2x.png"];
    }else if (type == 2){
        label.text = NSLocalizedString(@"Bus mode", @"Bus mode");
        [dialog setFrame:CGRectMake(self.transportTypeTextView.bounds.size.width/2 -23, self.transportTypeTextView.bounds.size.height - (self.transportTypeTextView.bounds.size.height/ 2) - 45, 46, 90)];
        dialog.image = [UIImage imageNamed:@"busDialogRelease@2x.png"];
    }
    /*
    else if (type == 3){
        label.text = NSLocalizedString(@"Ricksaw mode", @"Ricksaw mode");
        [dialog setFrame:CGRectMake(self.transportTypeTextView.bounds.size.width/2 -23, self.transportTypeTextView.bounds.size.height - (self.transportTypeTextView.bounds.size.height/ 2) - 45, 46, 90)];
        dialog.image = [UIImage imageNamed:@"ricksawDialog.png"];
    }
     */
    
    // Arrow, deleted because doesn't look good on Train views
    UIImageView *directionArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.transportTypeTextView.bounds.size.width/2 - 16, 10, 32, 16)];
    directionArrow.image = [UIImage imageNamed:@"arrow_whiteRelease@2x.png"];
    
    [self.transportTypeTextView addSubview:dialog];
    [self.transportTypeTextView addSubview:directionArrow];
    [self.transportTypeTextView addSubview:label];
}


- (void) makeTheDrawOfType:(int)type
{
    if (self.seatPosition != 505){

        self.transportTypeView = [[UIView alloc] initWithFrame:CGRectMake(self.compassView.frame.origin.x,
                                                                          self.compassView.frame.origin.y,
                                                                          self.compassView.frame.size.width -40,
                                                                          self.compassView.frame.size.height-65)];
//                                                                          self.compassView.frame.size.height - 34)];
        CGPoint center = CGPointMake(self.compassView.center.x, self.compassView.center.y + 20);
        self.transportTypeView.center = center;

        //[self.transportTypeView setBackgroundColor:UIColorFromRGB(0x599AC8)];
        [self.transportTypeView setBackgroundColor:UIColorFromRGB(0x29a2cf)];

        self.transportTypeView.layer.borderWidth = LINE_BORDER;
        self.transportTypeView.layer.borderColor = sunnydarkgray.CGColor;
        self.transportTypeView.layer.cornerRadius = 5;
        self.transportTypeView.layer.masksToBounds = YES;
        [self drawTransportType:type sitPlace:self.seatPosition]; // type:1 = car, sitPlace:2 = leftback
    }
}


- (void) showTransportType
{
    if (self.seatPosition != 505){
        self.oneTouchView.hidden = YES;
        if (isSunriseViewVisible == YES){
            for (UIView *view in [self.compassView subviews]){
                if ([view isKindOfClass:[UILabel class]]){
                }else if ([view isKindOfClass:[UIButton class]]){
                }else if ([view isKindOfClass:[UIImageView class]]){
                }else if ([view isKindOfClass:[UIView class]]){
                    [view removeFromSuperview];
                }
                isSunriseViewVisible = NO;
            }
        }else{
            self.navigationItem.title = NSLocalizedString(@"best seats", @"best seats");
            
            NSInteger trans = [[NSUserDefaults standardUserDefaults] integerForKey:TRANSPORT_TYPE];
            [self makeTheDrawOfType:(int)trans];
            [self makeTheDrawForTextType:(int)trans];
            
            if (isTransportTypeVisible == NO){
                
                [self.compassView addSubview:self.transportTypeView];
                [self.compassView bringSubviewToFront:self.transportTypeView];
                [self.tap requireGestureRecognizerToFail:self.doubleTap];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.4];
                [self.transportTypeView setAlpha:0.75];
                [UIView commitAnimations];
                [UIView setAnimationDuration:0.0];
                
                [self.compassView addSubview:self.transportTypeTextView];
                [self.compassView bringSubviewToFront:self.transportTypeTextView];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                [self.transportTypeTextView setAlpha:0.8];
                [UIView commitAnimations];
                [UIView setAnimationDuration:0.0];
                
                [UIView animateWithDuration:2 animations:^{
                    [self.transportTypeTextView setAlpha:0];
                    
                }];
                isTransportTypeVisible = YES;
            }
            else{
                
                if (leftOrRightForNavTitle == 0){ // left
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Please Sit Left", @"Please Sit Left")];
                }else if (leftOrRightForNavTitle == 1){ // right
                    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Please Sit Right",@"Please Sit Right")];
                }else if (leftOrRightForNavTitle == 404){
                    // not initialized
                }
                                
                for (UIView *view in [self.compassView subviews]){
                    if ([view isKindOfClass:[UILabel class]]){
                    }else if ([view isKindOfClass:[UIButton class]]){
                    }else if ([view isKindOfClass:[UIImageView class]]){
                    }else if ([view isKindOfClass:[UIView class]]){
                        [view removeFromSuperview];
                    }
                }
                isTransportTypeVisible = NO;
            }
        }
        
    }

}

- (IBAction)pressAfterSunrise:(UIButton *)sender {
    isSunriseViewVisible = YES;
    for (UIView *view in [self.compassView subviews]){
        if ([view isKindOfClass:[UILabel class]]){
        }else if ([view isKindOfClass:[UIButton class]]){
        }else if ([view isKindOfClass:[UIImageView class]]){
        }else if ([view isKindOfClass:[UIView class]]){
            [view removeFromSuperview];
        }
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.00000, 0.00000, self.compassW, self.compassH)];
    view.backgroundColor = [UIColor clearColor];
    [view setAlpha:0];
    
    UIView *viewToPeak = [[UIView alloc] initWithFrame:CGRectMake(25.000000, self.compassH/2 - (96/2), 270.000000, 96.000000)];
    [viewToPeak setBackgroundColor:sunnyblack];
    viewToPeak.layer.cornerRadius = 5;
    viewToPeak.layer.masksToBounds = YES;
    [viewToPeak setAlpha:0];
    
    [self.compassView addSubview:viewToPeak];
    [self.compassView bringSubviewToFront:viewToPeak];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(5, - 63.000000, 260, 200)];
    label.text = self.textForSunriseBox;
    label.textAlignment = NSTextAlignmentCenter;
    label.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.f];
    label.textColor = sunnylightgray;
    label.backgroundColor = [UIColor clearColor];
    [label setAlpha:0.0 ];
    
    UIImageView *sunToPeak = [[UIImageView alloc] initWithFrame:CGRectMake(50.500000, 45.000000 , 30, 30)];
    sunToPeak.image = [UIImage imageNamed:@"sunhome@2x.png"];
    [sunToPeak setAlpha:0.0];
    
    UILabel *labelSun = [[UILabel alloc] init];
    [labelSun setFrame:CGRectMake(5, -41.000000, 280, 200)];
    labelSun.text = self.textForSunriseBoxSecond;
    labelSun.textAlignment = NSTextAlignmentCenter;
    labelSun.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.f];
    labelSun.textColor = sunnylightgray;
    labelSun.backgroundColor = [UIColor clearColor];
    [labelSun setAlpha:0.0];

    if (isSunriseViewFastShowed == NO){
        [UIView animateWithDuration:0.5f delay:2.0f options:0 animations:^{
            view.alpha = 0.80;
            viewToPeak.alpha = 0.80;
            sunToPeak.alpha = 1.;
            label.alpha = 1.;
            labelSun.alpha = 1.;
        } completion:nil];
        isSunriseViewFastShowed = YES;
        
    }else{
        [UIView animateWithDuration:0.f animations:^{
            view.alpha = 0.80;
            viewToPeak.alpha = 0.80;
            sunToPeak.alpha = 1.;
            label.alpha = 1.;
            labelSun.alpha = 1.;
        }];
    }
    
    [self.compassView addSubview:view];
    [viewToPeak addSubview:label];
    [viewToPeak addSubview:sunToPeak];
    [viewToPeak addSubview:labelSun];
}

@end
