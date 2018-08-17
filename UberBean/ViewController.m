//
//  ViewController.m
//  UberBean
//
//  Created by Bennett on 2018-08-16.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Cafe.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) NSMutableArray <Cafe*> *cafeArray;
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
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:@"cafeAnnotation"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = locations[0];
    
    // Center the map on the users current location
    [self.mapView setRegion:MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.06, 0.06))];
    
    [self getData:loc.coordinate];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[Cafe class]]) {
        MKMarkerAnnotationView *marker = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cafeAnnotation" forAnnotation:annotation];
        
        marker.markerTintColor = [UIColor redColor];
        marker.glyphText = annotation.title;
        marker.titleVisibility = MKFeatureVisibilityVisible;
        marker.animatesWhenAdded = YES;
        
        return marker;
    }
    
    return nil;
    
}

// Mark: Setup connection to the Yelp API
-(void)getData:(CLLocationCoordinate2D)coordinate{
    
    self.cafeArray = [@[] mutableCopy];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=cafe&latitude=%f&longitude=%f", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString]; // 1
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url]; // 2
    [urlRequest addValue:@"Bearer Y9fb-mmFxou76gWwiYUmEIqOxDqUkKLKXtIVqy6PAslvEYdsOaqgx_RL9JTAPCNZ4MAwp-UeNvQq8YgYVavIMOCkFarg5c6Iea5ULgjYUvqaobuGns4owrUzHTZ3W3Yx" forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *yelpDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        NSArray* businesses = yelpDictionary[@"businesses"];
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        for (NSDictionary *business in businesses) { // 4
            NSDictionary* coordinates = business[@"coordinates"];
            CLLocationCoordinate2D newCoordinates = CLLocationCoordinate2DMake([coordinates[@"latitude"] doubleValue], [coordinates[@"longitude"] doubleValue] );
            
            Cafe *newCafe = [[Cafe alloc]initWithTitle:business[@"name"] coordinate:newCoordinates rating:business[@"rating"] imageURL:business[@"image_url"]];
            
            NSLog(@"cafe: %@ \n rating: %@ \n imageurl: %@\n coordinates: %f %F\n", newCafe.title, newCafe.rating, newCafe.imageURL, newCafe.coordinate.longitude, newCafe.coordinate.latitude);
            
            [self.cafeArray addObject:newCafe];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            for (int i=0; i< [self.cafeArray count]; i++)
            {
                [self.mapView addAnnotation:self.cafeArray[i]];
            }
        }];
        
    }]; // 5
    
    [dataTask resume]; // 6
}


@end
