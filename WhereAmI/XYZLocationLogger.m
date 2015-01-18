//
//  XYZLocationLogger.m
//  WhereAmI
//
//  Created by Admin on 18.01.15.
//  Copyright (c) 2015 PlaceHolder. All rights reserved.
//

#import "XYZLocationLogger.h"
#import <CoreLocation/CoreLocation.h>

#define CHECK_TIME_INTERVAL 3.0f


@interface XYZLocationLogger() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL logUpdate;
@property (nonatomic, assign) BOOL logEnabled;



@end

@implementation XYZLocationLogger

+ (instancetype)sharedInstance
{
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
    if ( self.logEnabled) {
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self updateLocation];
            self.logUpdate = NO;
        }];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_TIME_INTERVAL
                                                    target:self
                                                    selector:@selector(updateLocation)
                                                    userInfo:nil
                                                    repeats:YES];
        
    }
    
    
}

- (void)updateLocation
{
    [self.locationManager startUpdatingLocation];
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


//KVO method observing for a status of checkbox state
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSNumber *checkStatus = [change objectForKey:@"new"];
    self.logEnabled = checkStatus.boolValue;
}



@end
