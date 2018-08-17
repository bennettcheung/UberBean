//
//  ViewController.m
//  UberBean
//
//  Created by Bennett on 2018-08-16.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
    [self CurrentLocationIdentifier];

}

-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 20;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    //------
    //self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = locations[0];
    
    // Center the map on the users current location
    [self.mapView setRegion:MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.06, 0.06))];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager requestLocation];
    }
    
}


@end
