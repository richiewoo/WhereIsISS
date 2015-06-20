//
//  CityAnnotation.m
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/10/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

#import "CityAnnotation.h"

@interface CityAnnotation ()

@property(nonatomic, strong) CLLocation *clLoc;
@property(nonatomic, strong) CLGeocoder *clRGeo;
@property(nonatomic, strong) NSString * cityName;

- (void)geocodeLocation;

@end

@implementation CityAnnotation

@synthesize theCoordinate;
@synthesize cityName;

#pragma mark - override method of the MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.theCoordinate;
}

/*
 Update the Coordinate
*/
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.theCoordinate = newCoordinate;
    
    [self geocodeLocation];
}

- (NSString *)title
{
    return self.cityName;
}

+ (MKAnnotationView *)createViewAnnotationView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([CityAnnotation class])];
    if (annotationView == nil)
    {
        annotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation
                                     reuseIdentifier:NSStringFromClass([CityAnnotation class])];
        
        annotationView.canShowCallout = YES;
        
        // offset the flag annotation so that the flag pole rests on the map coordinate
        annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2 );
    }
    else
    {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

/*
converting a map coordinate into information about that coordinate, such as the country, city, or street
*/
- (void)geocodeLocation
{
    if (!_clLoc) {
        _clLoc = [[CLLocation alloc]initWithCoordinate:self.theCoordinate altitude:kCLDistanceFilterNone horizontalAccuracy:kCLLocationAccuracyBest verticalAccuracy:kCLLocationAccuracyBest timestamp:[NSDate date]];
    }
    if (!_clRGeo){
        _clRGeo = [[CLGeocoder alloc] init];
    }
    
    [_clRGeo reverseGeocodeLocation:_clLoc completionHandler: ^(NSArray* placemarks, NSError* error){
        if (!error)
        {
            if ([placemarks count] > 0)
            {
                CLPlacemark *pmk = [placemarks objectAtIndex:0];
                if(pmk.locality){
                    self.cityName = pmk.locality;   // city, eg. Cupertino
                }else if(pmk.administrativeArea){
                    self.cityName = pmk.administrativeArea; // state, eg. CA
                }else if(pmk.country){
                    self.cityName = pmk.country;    // eg. United States
                }else if(pmk.ocean){
                    self.cityName = pmk.ocean;  // eg. Pacific Ocean
                }else if(pmk.name){
                    self.cityName = pmk.name;   // eg. Apple Inc.
                }else{
                    self.cityName = @"Maybe I am lost ";
                }
            }
        }
    }];
}

@end
