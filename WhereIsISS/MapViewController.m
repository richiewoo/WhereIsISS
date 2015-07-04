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
@property (nonatomic, assign) BOOL isFirstUpdateMap;

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
    
    //[self.mapView addAnnotation:_cityAnnotation];
    
    _isFirstUpdateMap = true;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:LOCATION_DATA_OBSERVE_KEY]) {
        
        // add the annotation
        [_cityAnnotation setCoordinate:_locationData.location];
        [self.mapView addAnnotation:_cityAnnotation];
        
        if( _isFirstUpdateMap )
        {
            //make map move and the the annotation be in center may be better
            [self.mapView setCenterCoordinate:_locationData.location animated:YES];
            _isFirstUpdateMap = false;
        }
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

#pragma mark - button action

- (IBAction)location {
    [self.mapView setCenterCoordinate:_locationData.location animated:YES];
}

- (IBAction)mapStutas:(UIButton *)sender {
    
    if (sender.tag == 0) {
        sender.tag = 1;
        self.mapView.mapType = MKMapTypeSatellite;
        [sender setImage:[UIImage imageNamed:@"map_setting_view_btn_normal"] forState:UIControlStateNormal];
    }
    else
    {
        sender.tag = 0;
        self.mapView.mapType = MKMapTypeStandard;
        [sender setImage:[UIImage imageNamed:@"map_setting_view_btn_satellite"] forState:UIControlStateNormal];
    }
}

@end
