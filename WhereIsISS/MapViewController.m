//
//  ViewController.m
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/10/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "ISSLocationData.h"
#import "CityAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CityAnnotation *cityAnnotation;
@property (strong, nonatomic) ISSLocationData *locationData;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create the annotation
    _cityAnnotation = [[CityAnnotation alloc] init];
    
    //Create the data model
    _locationData = [[ISSLocationData alloc]init];
    
    //KVO- To observe the location change
    [_locationData addObserver:self forKeyPath:LOCATION_DATA_OBSERVE_KEY options:NSKeyValueObservingOptionOld context:nil];
    [_locationData startGetLocation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:LOCATION_DATA_OBSERVE_KEY]) {
        
        // add the annotation
        [_cityAnnotation setCoordinate:_locationData.location];
        [self.mapView addAnnotation:_cityAnnotation];
        
        //make map move and the the annotation be in center may be better
        [self.mapView setCenterCoordinate:_locationData.location animated:YES];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // create the annotation view
    MKAnnotationView *annotationView = [CityAnnotation createViewAnnotationView:self.mapView annotation:annotation];
    annotationView.image = [UIImage imageNamed:@"icon_iss_img.png"];
    
    return annotationView;
}

@end
