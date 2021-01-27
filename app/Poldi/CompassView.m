//
//  CompassView.m
//  Poldi
//
//  Created by admin on 09.11.12.
//  Copyright (c) 2012 muugs. All rights reserved.
//

#import "CompassView.h"
#import "SunPossitionBrain.h"
#import <QuartzCore/QuartzCore.h>


@interface CompassView ()
{
    float testX;
    float testY;
}
@property (strong, nonatomic) SunPossitionBrain *sunPossitionBrain;

@property (nonatomic) float sunPointX;
@property (nonatomic) float sunPointY;
@property (nonatomic, strong) UIImageView *sunImage;
@property (nonatomic, strong) CAKeyframeAnimation *frameAnimation;


@end

@implementation CompassView
@synthesize sunDegreePossition = _sunDegreePossition;
@synthesize scale = _scale;


- (UIImageView *)sunImage
{
    if (!_sunImage){
        _sunImage = [[UIImageView alloc] init];
    }
    return _sunImage;
}
- (SunPossitionBrain *)sunPossitionBrain
{
    if (!_sunPossitionBrain){
        _sunPossitionBrain = [[SunPossitionBrain alloc] init];
    }
    return _sunPossitionBrain;
}

- (void)setSunDegreePossition:(float)sunDegreePossition
{
    _sunDegreePossition = sunDegreePossition;
    [self setNeedsDisplay];
}

- (float)sunDegreePossition
{
    if (!_sunDegreePossition){

        return 360.;
        
    }else{
        return _sunDegreePossition;
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];

    }
    return self;
}


-(NSMutableArray *)GetPointsForCircle
{
    NSMutableArray *Points = [[NSMutableArray alloc] init];
    CGPoint CenterPoint = CGPointMake(160, 208);
    CGPoint Point;
    for (float Angel = 0; Angel <= 360; Angel+= 60)
    {
        Point.x = CenterPoint.x + 100 * cos(Angel);
        Point.y = CenterPoint.y + 100 * sin(Angel);
        [Points addObject:[NSValue valueWithCGPoint:Point]];

    }
    return Points;
}

- (CGPoint)pointOnCircle:(int)thisPoint withTotalPointCount:(int)totalPoints
{
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    float radius = 130.0;
    float angle = ( 2 * M_PI / (float)totalPoints ) * (float)thisPoint;
    CGPoint newPoint;
    newPoint.x = (centerPoint.x) + (radius * cosf(angle));
    newPoint.y = (centerPoint.y) + (radius * sinf(angle));

    return newPoint;
}

- (CGPoint) findRandomXY{
    CGFloat x = arc4random() % (int)self.frame.size.width;
    CGFloat y = arc4random() % (int)self.frame.size.height;
    
    CGPoint point = CGPointMake(x, y);
    return point;
    
}

- (void) setRandomLocationForView:(UIView *)view point:(CGPoint)point
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    view.center = CGPointMake(x, y);
}

- (void) setRandomLocationInitForView:(UIView *)view {
    CGRect poldiBounds = CGRectInset(self.bounds, view.frame.size.width/2, 0);
    CGFloat x = arc4random() % (int)poldiBounds.size.width + view.frame.size.width/2;
    CGFloat y = 0;
    view.center = CGPointMake(x, y);
}
- (void) addStarWithAlpha:(float)alpha endWithAlpha:(float)endAlpha
{
    CGPoint point = [self findRandomXY];
    UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x-5, point.y-2, 10, 9)]; // changing explosion position ORIGINAL
    [starView setImage:[UIImage imageNamed:@"star_smallRelease.png"]];
    [starView setAlpha:alpha];
    [self setRandomLocationForView:starView point:point];
    [starView setAlpha:endAlpha];
    [self addSubview:starView];
}

- (void) addCloud
{
    UIImageView *cloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [cloudView setImage:[UIImage imageNamed:@"cloudRelease@2x.png"]];
    [cloudView setAlpha:0.70];
    [self setRandomLocationForView:cloudView point:[self findRandomXY]];
    [self addSubview:cloudView];
}


- (void) findSunPossition:(float) sunPossition endSunPossition:(float)endPossition sunScale:(float)scale
{
    self.sunDegreePossition = sunPossition;
    self.sunDegreeEndPossition = endPossition;
    self.scale = scale;
}


- (void)drawCircleFillAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
    CGContextFillPath(context);
    UIGraphicsPopContext();
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIView *view in [self subviews]){
        if ([view isKindOfClass:[UILabel class]]){
        }else if ([view isKindOfClass:[UIButton class]]){
        }else if ([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }else if ([view isKindOfClass:[UIView class]]){
            [view removeFromSuperview];
        }
    }

    CGPoint sunStartPoint;
    sunStartPoint.x = self.frame.size.width/2 - 25.5;
    sunStartPoint.y = self.frame.size.height;
    CGPoint sunEndPoint;
    sunEndPoint.x = self.frame.size.width /2 - 26;
    sunEndPoint.y = self.frame.size.height/4;

    
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = (self.bounds.size.width - 70) / 2; // 20 corresponds to the marge at the sides
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= 1;
    
    CGGradientRef gradient = NULL;
    CGColorSpaceRef baseSpace = NULL;
    // 0 Day
    // 0.5 almost night
    // 1 Night
    if (self.scale == 0){
        CGFloat components[8] = {
            0.2, 0.6, 0.8, 1.0,// Start color
            0.537, 0.847, 0.858, 1.0
        }; // End color
    
        size_t num_locations = 2;
        CGFloat locations[3] = { 0.0, 0.7};
        
        baseSpace = CGColorSpaceCreateDeviceRGB(); // Just for iOS
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
        [self.sunImage setFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height, self.sunImage.frame.size.width, self.sunImage.frame.size.height)];
        [self.sunImage setImage:[UIImage imageNamed:@"sunhome@2x.png"]];
        [self addSubview:self.sunImage];
        [self prepareAnimation:sunStartPoint sunEndPoint:sunEndPoint addCloud:YES];
        
    }
    else if (self.scale == 0.5){
        CGFloat components[20] = {
            0.090, 0.160, 0.450, 1.0, // 23 41 155
            0.121, 0.294, 0.572, 1.0, // 31, 75, 146
            0.254, 0.631, 0.725, 1.0, // 65, 161, 185
            0.654, 1, 0.8, 1.0 // 165, 255, 204
        };
        size_t num_locations = 4;
        CGFloat locations[4] = { 0.0, 0.25, 0.5, 1.0};
        baseSpace = CGColorSpaceCreateDeviceRGB(); // Just for iOS
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
        [self.sunImage setFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height, self.sunImage.frame.size.width, self.sunImage.frame.size.height)];
        [UIView animateWithDuration:2.f animations:^{
            for (int i = 0; i < 65; i++) {
                [self addStarWithAlpha:0 endWithAlpha:0.10];
            }
        }];
        [self.sunImage setImage:[UIImage imageNamed:@"sunsetsun@2x.png"]];
        [self addSubview:self.sunImage];
        [self prepareAnimation:sunStartPoint sunEndPoint:sunEndPoint addCloud:NO];
    }
    else if (self.scale == 1){
        // BACKGROUND Zone

        CGFloat components[12] = {
            0.168, 0.192, 0.235, 1.0, // 43, 49, 60 #2B313C
            0.2, 0.6, 0.8, 1.0,// Start color // 51, 153, 208 #3399D0
            0.2, 0.6, 0.8, 1.0 //
        }; // End color
        size_t num_locations = 3;
        CGFloat locations[3] = { 0.0, 0.5, 1.0 };
    
        baseSpace = CGColorSpaceCreateDeviceRGB(); // Just for iOS
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);

        [self.sunImage setFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height, 25, 25)];
        [self.sunImage setImage:[UIImage imageNamed:@"moonRelease@2x.png"]];
        [[UIColor whiteColor] setStroke]; // Compass circle
        [self addSubview:self.sunImage];
        [self bringSubviewToFront:self.sunImage];
        [self prepareAnimationMoon:sunStartPoint sunEndPoint:sunEndPoint];
    }
    
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    CGContextSetLineWidth(context, 0.05);
    
#define SUN_RADIUS 0.07
    [UIColorFromRGB(0x3399CC) setFill];
}

- (void) prepareAnimation:(CGPoint)startPoint sunEndPoint:(CGPoint) endPoint addCloud:(BOOL)withCloud
{
    [UIView animateWithDuration:2.0f animations:^{
     self.sunImage.frame = CGRectMake((self.frame.size.width/2)- (160/2), (self.frame.size.height/4) - (160/3), 160, 160);
    }];
    
    if (withCloud) {
        [UIView animateWithDuration:2.5f animations:^{
            for (int i = 0; i < 2.5f; i++) {
                [self addCloud];
            }
        }];
    }
}

- (void) prepareAnimationMoon:(CGPoint)startPoint sunEndPoint:(CGPoint) endPoint
{
    [UIView animateWithDuration:2.f animations:^{
        
        if (self.scale == 1){ // Dark
            for (int i = 0; i < 150; i++) { // Sandys alter (35) + diegos alter (26) + 6 months together + 13 Geburtstag
                [self addStarWithAlpha:0 endWithAlpha:0.75];
            }
        }
    }];
    [UIView animateWithDuration:2.f animations:^{
        //Move the image view to 100, 100 over 10 seconds.
        self.sunImage.frame = CGRectMake((self.frame.size.width/2)- (55/2), (self.frame.size.height/4) - (55/3), 55, 55);
        [self.sunImage setAlpha:1];
        [self bringSubviewToFront:self.sunImage];
        
    }];
}

@end
