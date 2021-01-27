//
//  TravelPlannerTableViewController.m
//  Poldi
//
//  Created by admin on 01.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//


/*
    9th November
    "Via" API is disable
 */

#import "TravelPlannerTableViewController.h"
#import "LocationBrain.h"
#import "PoldiData.h"
#import "CompassView.h"
#import "PerformanceBrain.h"

@interface TravelPlannerTableViewController ()

@property (strong, nonatomic) LocationBrain *locationBrain;
//@property (strong, nonatomic) PoldiData *poldiData;
@property (strong, nonatomic) CompassView *compassView;
@property (strong, nonatomic) PerformanceBrain *performanceBrain;

@property (nonatomic, strong) NSMutableArray *locationPerfil; // Default cell text
@property (nonatomic, strong) NSMutableArray *locationCollections; // Get all the user information
@property (nonatomic, strong) NSString *timeText;
@property (nonatomic, strong) NSMutableArray *timeCollection;
@property (nonatomic, strong) NSString *vehicleText;

@property (nonatomic, strong) IBOutlet UISegmentedControl *temperatureType;
@property (nonatomic, strong) IBOutlet UISegmentedControl *vehicleType;


@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDown;
@property (weak, nonatomic) IBOutlet UILabel *displayInfoNoGuarantee;


@property (weak, nonatomic) IBOutlet UINavigationBar *myTabBar;

@end

@implementation TravelPlannerTableViewController
@synthesize fromLocation = _fromLocation;
@synthesize toLocation = _toLocation;
@synthesize viaLocation = _viaLocation;
@synthesize dateAndTimeProfile = _dateAndTimeProfile;


#define FROM_DATA_KEY @"ProfileFromLocationViewController.FromNameKey"
#define FROM_LOCALITY_KEY @"ProfileFromLocationViewController.FromLocalityKey"
#define FROM_COUNTRY_KEY @"ProfileFromLocationViewController.FromCountryKey"
#define FROM_LATITUDE_KEY @"ProfileFromLocationViewController.FromLatitudeKey"
#define FROM_LONGITUDE_KEY @"ProfileFromLocationViewController.FromLongitudeKey"

#define TO_DATA_KEY @"ProfileToLocationViewController.ToNameKey"
#define TO_LOCALITY_KEY @"ProfileToLocationViewController.ToLocalityKey"
#define TO_COUNTRY_KEY @"ProfileToLocationViewController.ToCountryKey"
#define TO_LATITUDE_KEY @"ProfileToLocationViewController.ToLatitudeKey"
#define TO_LONGITUDE_KEY @"ProfileToLocationViewController.ToLongitudeKey"

#define TIME_KEY @"TravelPlannerTableViewController.TimeKey"
#define DATE_KEY @"TravelPlannerTableViewController.DateKey"
#define MONTH @"TravelPlannerTableViewController.MonthKey"

#define TIME_IN_MINUTES @"TravelPlannerTableViewController.TimeInMinutesKey"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UISwipeGestureRecognizer *)swipeDown
{
    if (!_swipeDown){
        _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showHomeView)];
        _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swipeDown;
}

- (void) showHomeView
{
    [self pressDismiss:nil];
}

- (CompassView *)compassView
{
    if (!_compassView){
        _compassView = [[CompassView alloc] init];
    }
    return _compassView;
}
/*
- (PoldiData *)poldiData{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}*/

- (PerformanceBrain *)performanceBrain{
    if (!_performanceBrain){
        _performanceBrain = [[PerformanceBrain alloc] init];
    }
    return _performanceBrain;
}

- (LocationBrain *)locationBrain
{
    if (!_locationBrain){
        _locationBrain = [[LocationBrain alloc] init];
    }
    return _locationBrain;
}

#define TRANSPORT_TYPE @"TravelPlannerTableViewController.TransportTypeKey"
- (void)inVehicleType{
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.vehicleType.selectedSegmentIndex forKey:TRANSPORT_TYPE];

}


- (void)inTemperatureType{
    [[NSUserDefaults standardUserDefaults] setInteger:self.temperatureType.selectedSegmentIndex forKey:TEMPERATURE_TYPE];
}

- (UISegmentedControl *)temperatureType{
    if (!_temperatureType) {
        NSArray *itemArray = [NSArray arrayWithObjects:@"°C", @"°F", nil];
        _temperatureType = [[UISegmentedControl alloc] initWithItems:itemArray];
        [_temperatureType addTarget:self action:@selector(inTemperatureType) forControlEvents:UIControlEventEditingChanged];
        CGPoint point;
        point.x = (self.view.bounds.size.width / 2) - (self.view.bounds.size.width / 3);
        point.y = 15;
        CGSize size;
        size.width = 212.0;
        size.height = 29.0;
        
        _temperatureType.frame = CGRectMake(point.x, point.y, size.width, size.height);
        _temperatureType.tintColor = UIColorFromRGB(0x3399CC);
        _temperatureType.selectedSegmentIndex = 0;
    }
    return _temperatureType;
}

- (UISegmentedControl *)vehicleType
{
    if (!_vehicleType){
        
//        NSString *transportSegmentTrain =

        NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"Train", @"train type"), NSLocalizedString(@"Car", @"car type"), NSLocalizedString(@"Bus", @"bus type"), nil];
        
// WITH RICKSAW//        NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"Train", @"train type"), NSLocalizedString(@"Car", @"car type"), NSLocalizedString(@"Bus", @"bus type"), NSLocalizedString(@"Ricksaw", @"ricksaw type"), nil];
        _vehicleType = [[UISegmentedControl alloc] initWithItems:itemArray];
        [_vehicleType addTarget:self action:@selector(inVehicleType) forControlEvents:UIControlEventValueChanged];
        
        
        CGPoint point;
        point.x = (self.view.bounds.size.width / 2) - (self.view.bounds.size.width / 3);
        point.y = 15;
        CGSize size;
        size.width = 212.0;
        size.height = 29.0;


        _vehicleType.frame = CGRectMake(point.x, point.y, size.width, size.height);
//        _vehicleType.segmentedControlStyle = UISegmentedControlStyleBar;
//        _vehicleType.tintColor = [[UIColor alloc] initWithRed:50/255.f green:101/255.f blue:152/255.f alpha:1];
        _vehicleType.tintColor = UIColorFromRGB(0x3399CC);
        _vehicleType.selectedSegmentIndex = 0;
        
    }

    
    return _vehicleType;
}

- (NSString *)vehicleText
{
    if (!_vehicleText){
        _vehicleText =  NSLocalizedString(@"Vehicle", @"Vehicle tableview");
    }
    return _vehicleText;
}

- (void)setDateAndTimeProfile:(NSString *)dateAndTimeProfile
{
    _dateAndTimeProfile = dateAndTimeProfile;
    [self.tableView reloadData];
}

- (NSString *)dateAndTimeProfile
{
    if (!_dateAndTimeProfile){
        _dateAndTimeProfile = NSLocalizedString(@"Date", @"Date tableview");
    }
    return _dateAndTimeProfile;
}

- (NSMutableArray *)timeCollection
{
    _timeCollection = [[NSMutableArray alloc] initWithObjects:self.dateAndTimeProfile, nil];

    return _timeCollection;
}

- (NSString *)timeText
{
    if (!_timeText){
        _timeText = NSLocalizedString(@"Time",@"Time tableview");
    }
    return _timeText;
}

- (void)setFromLocation:(NSString *)fromLocation
{
    _fromLocation = fromLocation;
    [self.tableView reloadData];
}


- (NSString *)fromLocation{
    if (!_fromLocation){
        _fromLocation = NSLocalizedString(@"Start Point",@"StartPoint tableview");
    }
    return  _fromLocation;
}

- (void)setToLocation:(NSString *)toLocation
{
    _toLocation = toLocation;
    [self.tableView reloadData];
}

- (NSString *)toLocation
{
    if (!_toLocation){
        _toLocation = NSLocalizedString(@"End Point",@"EndPoint tableview");
    }
    return _toLocation;
}

- (void)setViaLocation:(NSString *)viaLocation
{
    _viaLocation = viaLocation;
    [self.tableView reloadData];
}

- (NSString *)viaLocation
{
    if (!_viaLocation){
        _viaLocation = @"Some State";
    }
    return _viaLocation;
}


- (NSMutableArray *)locationCollections{

//    _locationCollections = [[NSMutableArray alloc] initWithObjects:self.fromLocation, self.toLocation, self.viaLocation, nil];
    _locationCollections = [[NSMutableArray alloc] initWithObjects:self.fromLocation, self.toLocation, nil];
    return _locationCollections;
}

- (NSMutableArray *)locationPerfil
{
    if (!_locationPerfil){
        _locationPerfil = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"From", @"From tableview"), NSLocalizedString(@"To",@"To tableview"), NSLocalizedString(@"Via", @"Via tableview"), nil];
    }
    return _locationPerfil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Show From Location"]){
        [segue.destinationViewController setFromLocation:self.fromLocation];
        [(ProfileFromLocationViewController *)segue.destinationViewController setDelegate:self];
        
    }else if([segue.identifier isEqualToString:@"Show To Location"]){
        [segue.destinationViewController setToText:self.toLocation];
        [(ProfileToLocationViewController *)segue.destinationViewController setDelegate:self];
        
    }else if([segue.identifier isEqualToString:@"Show Via Location"]){
        [segue.destinationViewController setViaText:self.viaLocation];
        [(ProfileViaLocationViewController *)segue.destinationViewController setDelegate:self];
        
    }else if([segue.identifier isEqualToString:@"Show Time Location"]){
        [segue.destinationViewController setDateLocation:self.dateAndTimeProfile];
        [(ProfileTimeTableViewController *)segue.destinationViewController setDelegate:self];
    }
}

- (CLLocation *) calculateStartLocation
{
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY] longitude:[[NSUserDefaults standardUserDefaults] floatForKey:FROM_LONGITUDE_KEY]];
//    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[self.poldiData fromLocationLatitudeCoordinatesData] longitude:[self.poldiData fromLocationLongitudeCoordinatesData]];
    return startLocation;
}

- (CLLocation *) calculateEndLocation
{
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:TO_LATITUDE_KEY] longitude:[[NSUserDefaults standardUserDefaults] floatForKey:TO_LONGITUDE_KEY]];
//    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[self.poldiData toLocationLatitudeCoordinatesData] longitude:[self.poldiData toLocationLongitudeCoordinatesData]];
    
    return  endLocation;
}

- (IBAction)pressDismiss:(UIBarButtonItem *)sender
{
    
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:^{}];
    

    if (![self.fromLocation isEqualToString:@"Start Point"]){     // Not optimal
        
        CLLocationCoordinate2D fromCoordinate;
        fromCoordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY];
//        fromCoordinate.latitude = [self.poldiData fromLocationLatitudeCoordinatesData];
        fromCoordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_LONGITUDE_KEY];
//        fromCoordinate.longitude = [self.poldiData fromLocationLongitudeCoordinatesData];
        
        CLLocationCoordinate2D toCoordinate;
        toCoordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:TO_LATITUDE_KEY];
//        toCoordinate.latitude = [self.poldiData toLocationLatitudeCoordinatesData];
        toCoordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:TO_LONGITUDE_KEY];
//        toCoordinate.longitude = [self.poldiData toLocationLongitudeCoordinatesData];
        
        
//#define FROM_DEGREE_DIRECTION_LATITUDE_KEY @"ProfileFromLocationViewController.FromDegreeDirectionLatitude"
//#define FROM_DEGREE_DIRECTION_LONGITUDE_KEY @"ProfileFromLocationViewController.FromDegreeDirectionLongitude"
//#define TO_DEGREE_DIRECTION_LATITUDE_KEY @"ProfileToLocationViewController.FromDegreeDirectionLatitude"
//#define TO_DEGREE_DIRECTION_LONGITUDE_KEY @"ProfileToLocationViewController.FromDegreeDirectionLongitude"
        CLLocationCoordinate2D fromDegreeOrientationCoordinate;
        fromDegreeOrientationCoordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_COORDINATE_LAT];
        fromDegreeOrientationCoordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_COORDINATE_LON];
        CLLocationCoordinate2D toDegreeOrientationCoordinate;
        toDegreeOrientationCoordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:TO_COORDINATE_LAT];
        toDegreeOrientationCoordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:TO_COORDINATE_LON];
        
        
        
#define TRIP_DIRECTION_DEGREES @"TravelPlannerTableViewController.TripDirectionDegreesKey"
        /* WORKED BEFORE CHANGE SUN ANGLE BETWEEN 24 AND -24 LATITUDE
        float degrees = [self.locationBrain getHeadingForDirectionFromCoordinate:fromCoordinate toCoordinate:toCoordinate];
//        [self.poldiData setTripDirectionData:degrees];
        [[NSUserDefaults standardUserDefaults] setFloat:degrees forKey:TRIP_DIRECTION_DEGREES];
        */
        float degrees = [self.locationBrain getHeadingForDirectionFromCoordinate:fromDegreeOrientationCoordinate toCoordinate:toDegreeOrientationCoordinate];
//        NSLog(@"degrees %f", degrees );
        //        [self.poldiData setTripDirectionData:degrees];
        [[NSUserDefaults standardUserDefaults] setFloat:degrees forKey:TRIP_DIRECTION_DEGREES];

        
//        NSString *orientationLetter = [self.locationBrain findOrienationLetterWithDegrees:degrees];
        
        CLLocationDistance distance = [self.locationBrain findTravelDistanceOfLocation:[self calculateStartLocation] fromNewLocation:[self calculateEndLocation]];
        

        [[NSUserDefaults standardUserDefaults] setInteger:self.vehicleType.selectedSegmentIndex forKey:TRANSPORT_TYPE];
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.temperatureType.selectedSegmentIndex forKey:TEMPERATURE_TYPE];
        
        
#define TOTAL_TIME_TRAVEL_MINUTES @"TravelPlannerTableViewController.TotalTravelMinutesKey"
        int type = (int)self.vehicleType.selectedSegmentIndex;
        float travelTime = [self.locationBrain findTravelTimeOfDistance:distance withTransportType:type];
//        [self.poldiData setTotalTimeTravelMinutesData:travelTime];
//        NSLog(@"travelTimeMinutes %f",travelTime);
        [[NSUserDefaults standardUserDefaults] setFloat:travelTime forKey:TOTAL_TIME_TRAVEL_MINUTES];
        

        
        // 49 Corresponds to Germany || 19 corresponds to mexico city
//        float fromSunsPossition = [self.locationBrain findSunsPossitionFromLocationWithLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY] dependingOfMonth:[[NSUserDefaults standardUserDefaults] integerForKey:MONTH] andTime:[[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES]];
        
        float totalTravelTime = [[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES] + travelTime;
//        float totalTravelTime = [self.poldiData minutesData] + travelTime;
        
//        float toSunsPossition = [self.locationBrain findSunsPossitionFromLocationWithLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:TO_LATITUDE_KEY] dependingOfMonth:[[NSUserDefaults standardUserDefaults] integerForKey:MONTH] andTime:[[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES]];

        
// ORIGINAL       float fromPercent = [self.locationBrain findPercentOfSunWithLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY] inMonth:[[NSUserDefaults standardUserDefaults] integerForKey:MONTH] andTime:[[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES]];

        float latitude = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY];
        float fromPercent = 0.f;
        float lat = [[NSUserDefaults standardUserDefaults] floatForKey:FROM_LATITUDE_KEY];
        NSInteger month = [[NSUserDefaults standardUserDefaults] integerForKey:MONTH];
        if (latitude <= 23.f && latitude >= -23.f){
            

            float timeFromBrain = [self.performanceBrain checkMirrorTimeOfSunAngleBetweenLatitude23andMinus23:lat inMonth:(int)month withTime:[[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES]];


            fromPercent = [self.locationBrain findPercentOfSunWithLatitude:lat inMonth:(int)month andTime:timeFromBrain];
            
            if (fromPercent < -1){
                fromPercent *= -1;
            }
        
        }else{
             fromPercent = [self.locationBrain findPercentOfSunWithLatitude:lat inMonth:(int)month andTime:[[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES]];
        
        }
        
        
        
        
//        float fromPercent = [self.locationBrain findPercentOfSunWithLatitude:[self.poldiData fromLocationLatitudeCoordinatesData] inMonth:[self.poldiData monthData] andTime:[self.poldiData minutesData]];
#define FROM_SUN_INCLINATION @"TravelPlannerTableViewController.FromSunInclinationKey"
//        [self.poldiData setFromSunInclinationData:fromPercent];
        [[NSUserDefaults standardUserDefaults] setFloat:fromPercent forKey:FROM_SUN_INCLINATION];

        
#define TO_SUN_INCLINATION @"TravelPlannerTableViewController.ToSunInclinationKey"        
        float toPercent = [self.locationBrain findPercentOfSunWithLatitude:lat inMonth:(int)month andTime:[[NSUserDefaults standardUserDefaults] floatForKey:TIME_IN_MINUTES]];
//        float toPercent = [self.locationBrain findPercentOfSunWithLatitude:[self.poldiData toLocationLatitudeCoordinatesData] inMonth:[self.poldiData monthData] andTime:totalTravelTime];
//        [self.poldiData setToSunInclinationData:toPercent];
        [[NSUserDefaults standardUserDefaults] setFloat:toPercent forKey:TO_SUN_INCLINATION];
        
        float totalPercentOfSun = [self.locationBrain findTotalSunsPercent:fromPercent withPercent:toPercent];
        
#define TOTAL_SUN_PERCENT @"TravelPlannerTableViewController.TotalSunPercentKey"
//        [self.poldiData setTotalSunPercentData:totalPercentOfSun];
        [[NSUserDefaults standardUserDefaults] setFloat:totalPercentOfSun forKey:TOTAL_SUN_PERCENT];
        
#define START_SUN_POSSITION @"TravelPlannerTableViewController.StartSunPossitionKey"
        float sunStartPossition = [self.locationBrain findSunsDegreePossitionWithTime:[[NSUserDefaults  standardUserDefaults] floatForKey:TIME_IN_MINUTES]];
//        float sunStartPossition = [self.locationBrain findSunsDegreePossitionWithTime:[self.poldiData minutesData]];
//        [self.poldiData setStartSunsPossitionData:sunStartPossition];
//        NSLog(@"START_SUN %f", sunStartPossition);
        [[NSUserDefaults standardUserDefaults] setFloat:sunStartPossition forKey:START_SUN_POSSITION];
        

#define END_SUN_POSSITION @"TravelPlannerTableViewController.EndSunPossitionKey"
        float sunEndPossition = [self.locationBrain findSunsDegreePossitionWithTime:totalTravelTime];
//        NSLog(@"END_SUN %f", sunEndPossition);
//        [self.poldiData setEndSunsPossitionData:sunEndPossition];
        [[NSUserDefaults standardUserDefaults] setFloat:sunEndPossition forKey:END_SUN_POSSITION];
                
//        NSLog(@"\nDistance %f km\nTime to travel %f min\nDegress %f° %@\nFromSunsPossition %f\nToSunsPossition %f\nFromPercent %f%%\nToPercent %f%%\nTotalPercentOfSun %f%%\n SunStartPossition %f\n SunEndPossition %f", distance, travelTime, degrees, orientationLetter, fromSunsPossition, toSunsPossition, fromPercent, toPercent, totalPercentOfSun, sunStartPossition, sunEndPossition);
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}

# define MINUTES_PER_HOUR 60

- (NSString *) findMinutes
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *hour = [dateFormatter stringFromDate:currentDate];
//    [self.poldiData setTimeData:hour];
    [[NSUserDefaults standardUserDefaults] setObject:hour forKey:TIME_KEY];

    [dateFormatter setDateFormat:@"HH"];
    int hourtime = [[dateFormatter stringFromDate:currentDate] intValue];

    [dateFormatter setDateFormat:@"mm"];
    float minutetime = [[dateFormatter stringFromDate:currentDate] floatValue];
#define MINUTES_TO_SHOW_KEY @"TravelPlannerTableViewController.MinutesToShowKey"
    int minutesToShow = (int)minutetime;
    [[NSUserDefaults standardUserDefaults] setInteger:minutesToShow forKey:MINUTES_TO_SHOW_KEY];
    
    float timeInMinutes =  (MINUTES_PER_HOUR * hourtime)  + minutetime;
//    [self.poldiData setMinutesData:timeInMinutes];
    [[NSUserDefaults standardUserDefaults] setFloat:timeInMinutes forKey:TIME_IN_MINUTES];
    
    NSLog(@"Hour: %@", hour);

    return hour;
}

- (NSString *) findDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    NSString *date = [dateFormatter stringFromDate:currentDate];

    [[NSUserDefaults standardUserDefaults] setObject:date forKey:DATE_KEY];
    
    [dateFormatter setDateFormat:@"MM"]; // Adding moth to PoldiData singleton class
//    [self.poldiData setMonthData:[[dateFormatter stringFromDate:currentDate] intValue]];
    [[NSUserDefaults standardUserDefaults] setInteger:[[dateFormatter stringFromDate:currentDate] intValue] forKey:MONTH];
    
    
    return date;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Checking location defaults
    NSString *fromAddress = [[NSUserDefaults standardUserDefaults] objectForKey:FROM_DATA_KEY];
    NSString *toAddress = [[NSUserDefaults standardUserDefaults] objectForKey:TO_DATA_KEY];
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_KEY];
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:TIME_KEY];
    
    
    if (fromAddress) self.fromLocation = fromAddress;
    if (toAddress) self.toLocation = toAddress;
    if (date && time){
        self.dateAndTimeProfile = [NSString stringWithFormat:@"%@, %@", date, time];
    }else{
        self.dateAndTimeProfile = [NSString stringWithFormat:@"%@, %@",[self findDate], [self findMinutes]];
    }
    
    NSInteger transportType = [[NSUserDefaults standardUserDefaults] integerForKey:TRANSPORT_TYPE];
    self.vehicleType.selectedSegmentIndex = transportType;
    
    NSInteger temperatureType = [[NSUserDefaults standardUserDefaults] integerForKey:TEMPERATURE_TYPE];
    self.temperatureType.selectedSegmentIndex = temperatureType;

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.displayInfoNoGuarantee.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    self.displayInfoNoGuarantee.text = NSLocalizedString(@"infoNoGuarantee", @"info no guarantee");
    self.myTabBar.topItem.title = NSLocalizedString(@"Travel Planner", @"title nav");
    
    [self.view addGestureRecognizer:self.swipeDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0:
            return [self.locationCollections count];
        case 1:
            return [self.timeCollection count];
        default:
            return [self.timeCollection count];
    }

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Show Perfil";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:15];
    if (indexPath.section == 0){
        cell.textLabel.text = [self.locationPerfil objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.locationCollections objectAtIndex:indexPath.row];
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.timeText;
        cell.detailTextLabel.text = [self.timeCollection objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2){
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        //        cell.textLabel.text = self.vehicleText;
        //        cell.detailTextLabel.text = nil;
        self.temperatureType.userInteractionEnabled = YES;
        [cell addSubview:self.temperatureType];
        
    }

    else if (indexPath.section == 3){
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        cell.textLabel.text = self.vehicleText;
        cell.detailTextLabel.text = nil;
        self.vehicleType.userInteractionEnabled = YES;
        [cell addSubview:self.vehicleType];
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            [self performSegueWithIdentifier:@"Show From Location" sender:self];
        }else if (indexPath.row == 1){
            [self performSegueWithIdentifier:@"Show To Location" sender:self];
        }        
//        else if (indexPath.row == 2){
//            [self performSegueWithIdentifier:@"Show Via Location" sender:self];
//        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            [self performSegueWithIdentifier:@"Show Time Location" sender:self];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

#pragma mark - ProfileFromLocationViewControllerDelegate

- (void)profileFromLocationViewController:(ProfileFromLocationViewController *)sender sendFromLocation:(NSString *)fromLocation
{
    self.fromLocation = fromLocation;
//    [self.poldiData setFromLocationData:self.fromLocation];
}

#pragma mark - ProfileToLocationViewControllerDelegate

- (void)profileToLocationViewController:(ProfileToLocationViewController *)sender sendToLocation:(NSString *)toLocation
{
    self.toLocation = toLocation;
//    [self.poldiData setToLocationData:self.toLocation];
}

#pragma mark - ProfileViaLocationViewControllerDelegate

- (void)profileViaLocationViewController:(ProfileViaLocationViewController *)sender sendViaLocation:(NSString *)viaLocation
{
    self.viaLocation = viaLocation;
}

#pragma mark - ProfileTimeTableViewController

- (void)profileTimeTableViewController:(ProfileTimeTableViewController *)sender sendDate:(NSString *)date andTime:(NSString *)time
{
    self.dateAndTimeProfile = [NSString stringWithFormat:@"%@, %@", date, time];
//    [self.poldiData setTimeData:time];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:DATE_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:TIME_KEY];

}

@end
