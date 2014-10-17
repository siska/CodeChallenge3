//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *divvyAnnotation;
@property CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    CLLocationCoordinate2D coord;
    coord.latitude = self.mapStation.latitude;
    coord.longitude = self.mapStation.longitude;

    self.divvyAnnotation = [[MKPointAnnotation alloc] init];
    self.divvyAnnotation.coordinate = coord;
    self.divvyAnnotation.title = self.mapStation.name;
    [self.mapView addAnnotation:self.divvyAnnotation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error //added in step 2
{
    NSLog(@"I failed: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {

            CLLocationCoordinate2D coord;
            coord.latitude = location.coordinate.latitude;
            coord.longitude = location.coordinate.longitude;

            MKPointAnnotation *tempPoint = [[MKPointAnnotation alloc] init];
            tempPoint.coordinate = coord;

            [self.mapView addAnnotation:tempPoint];
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"bikeImage"];


    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CLLocationCoordinate2D center = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = center;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}








@end