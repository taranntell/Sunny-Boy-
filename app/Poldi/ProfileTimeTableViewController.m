//
//  ProfileTimeTableViewController.m
//  Poldi
//
//  Created by admin on 02.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "ProfileTimeTableViewController.h"
#import "PoldiData.h"

@interface ProfileTimeTableViewController () <UIPickerViewDelegate>
@property (nonatomic, strong) NSMutableArray *time;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSMutableArray *timeCollection;
@property (nonatomic, strong) PoldiData *poldiData;
@property (weak, nonatomic) IBOutlet UINavigationBar *myNavBar;

@end

@implementation ProfileTimeTableViewController
@synthesize dateLocation = _dateLocation;
@synthesize timeLocation = _timeLocation;

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (PoldiData *)poldiData
{
    if (!_poldiData){
        _poldiData = [[PoldiData alloc] init];
    }
    return _poldiData;
}

# define MINUTES_PER_HOUR 60

- (void) showDateText: (id)sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    NSString *currentDate = [NSString stringWithFormat:@"%@",
                             [dateFormatter stringFromDate:self.datePicker.date]];
    self.dateLocation = currentDate;
    
    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [dateFormatter stringFromDate:self.datePicker.date];
    self.timeLocation = currentTime;
    [[NSUserDefaults standardUserDefaults] setObject:self.timeLocation forKey:TIME_KEY];
    
    [self.delegate profileTimeTableViewController:self sendDate:self.dateLocation andTime:self.timeLocation];
#define DATE_KEY @"TravelPlannerTableViewController.DateKey"
    [[NSUserDefaults standardUserDefaults] setObject:self.dateLocation forKey:DATE_KEY];
    
#define TIME_IN_MINUTES @"TravelPlannerTableViewController.TimeInMinutesKey"
    [dateFormatter setDateFormat:@"HH"];
    int hourtime = [[dateFormatter stringFromDate:self.datePicker.date] intValue];
    [dateFormatter setDateFormat:@"mm"];
    float minutetime = [[dateFormatter stringFromDate:self.datePicker.date] floatValue];
#define MINUTES_TO_SHOW_KEY @"TravelPlannerTableViewController.MinutesToShowKey"
    int minutesToShow = (int)minutetime;
    [[NSUserDefaults standardUserDefaults] setInteger:minutesToShow forKey:MINUTES_TO_SHOW_KEY];
    
    
    float timeInMinutes =  (MINUTES_PER_HOUR * hourtime)  + minutetime;
    [self.poldiData setMinutesData:timeInMinutes];
    [[NSUserDefaults standardUserDefaults] setFloat:timeInMinutes forKey:TIME_IN_MINUTES];    
    [dateFormatter setDateFormat:@"MM"]; // Adding moth to PoldiData singleton class
    [self.poldiData setMonthData:[[dateFormatter stringFromDate:self.datePicker.date] intValue]];
#define MONTH @"TravelPlannerTableViewController.MonthKey"
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[dateFormatter stringFromDate:self.datePicker.date] intValue] forKey:MONTH];
}

- (void)setTimeLocation:(NSString *)timeLocation{
    _timeLocation = timeLocation;
    [self.tableView  reloadData];
}


- (void)setDateLocation:(NSString *)dateLocation{

    _dateLocation = dateLocation;
    [self.tableView  reloadData];
}

- (NSMutableArray *)time
{
    if (!_time){
        _time = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Date", @"Date"), NSLocalizedString(@"Time", @"Time"), nil];
    }
    return _time;
}

- (NSMutableArray *)timeCollection
{

    _timeCollection = [[NSMutableArray alloc] initWithObjects:self.dateLocation, self.timeLocation, nil];

    return _timeCollection;
}

- (IBAction)pressDismiss:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myNavBar.topItem.title = NSLocalizedString(@"Time Planner", @"title nav");

    [self showDateText:nil];
    [self.datePicker addTarget:self action:@selector(showDateText:) forControlEvents:UIControlEventValueChanged];
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.time count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Show Time";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:15];
    cell.textLabel.text = [self.time objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.timeCollection objectAtIndex:indexPath.row];
    
    return cell;
}
@end
