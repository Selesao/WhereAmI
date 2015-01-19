//
//  XYZLocationLogger.m
//  WhereAmI
//
//  Created by Admin on 18.01.15.
//  Copyright (c) 2015 PlaceHolder. All rights reserved.
//

#import "XYZLocationLogger.h"
#import <CoreLocation/CoreLocation.h>

#define CHECK_TIME_INTERVAL 60.0f


@interface XYZLocationLogger() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL logUpdate;
@property (nonatomic, assign) BOOL logEnabled;



@end

@implementation XYZLocationLogger

+ (instancetype)sharedInstance
{
    //Creating Singleton to prevent ARC from releasing instance of LocationLogger
    static XYZLocationLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self
               selector:@selector(startLogging:)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(stopLogging:)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
        
        [self startLocationManager];
        self.logUpdate = YES;
        self.logEnabled = YES;
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[XYZLocationManager sharedInstance]" userInfo:nil];
    return nil;
}



- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}

- (void)startLogging:(NSNotification *) note
{
    //Starting background task for timer
    if ( self.logEnabled) {
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            //Start location update if app trying to terminate
            [self.locationManager startUpdatingLocation];
            self.logUpdate = NO;
        }];
    //Timer for start updating location every CHECK_TIME_INTERVAL seconds when app is in the background
        self.timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_TIME_INTERVAL
                                                    target:self.locationManager
                                                    selector:@selector(startUpdatingLocation)
                                                    userInfo:nil
                                                    repeats:YES];
    }
}

- (void)stopLogging:(NSNotification *) note
{
    [self.timer invalidate];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.logUpdate) {
        NSLog(@"%@", [locations lastObject]);
    } else {
        self.logUpdate = YES;
    }
    [self.locationManager stopUpdatingLocation];
    
    
}


//KVO method observing for a checkbox state
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSNumber *checkStatus = [change objectForKey:@"new"];
    self.logEnabled = checkStatus.boolValue;
}



@end
