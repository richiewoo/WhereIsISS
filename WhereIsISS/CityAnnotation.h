//
//  CityAnnotation.h
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/10/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CityAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D theCoordinate;

+ (MKAnnotationView *)createViewAnnotationView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end
