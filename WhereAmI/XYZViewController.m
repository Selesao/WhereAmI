//
//  XYZViewController.m
//  WhereAmI
//
//  Created by Admin on 17.01.15.
//  Copyright (c) 2015 PlaceHolder. All rights reserved.
//

#import "XYZViewController.h"
#import <MapKit/MapKit.h>
#import "Mapbox.h"

@interface XYZViewController () <CLLocationManagerDelegate, RMMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appLabel;
@property CLLocationManager *mapLocationManager;
@property (weak, nonatomic) IBOutlet RMMapView *mapView;
@property (weak, nonatomic) IBOutlet XYZCustomCheckbox *checkBox;



@end

@implementation XYZViewController

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

    self.mapView.delegate = self;
    self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
    [self.mapView setUserTrackingMode:RMUserTrackingModeFollow];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkStatusChanged:(id)sender
{
    self.loggingOn = self.checkBox.checked;
}


@end
