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
@property (weak, nonatomic) IBOutlet UILabel *disLocation;
@property (strong, nonatomic) CityAnnotation *cityAnnotation;
@property (strong, nonatomic) ISSLocationData *locationData;
@property (nonatomic, assign) BOOL isFirstUpdateMap;
@property (nonatomic, strong) MKPolyline* locTrack;

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
    
    [self.mapView addAnnotation:_cityAnnotation];
    
    _isFirstUpdateMap = true;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:LOCATION_DATA_OBSERVE_KEY]) {
        
        // update the location of the annotation
        [_cityAnnotation setCoordinate:_locationData.location];
        
        if( _isFirstUpdateMap )
        {
            //make map move and the the annotation be in center may be better
            [self.mapView setCenterCoordinate:_locationData.location animated:YES];

            _isFirstUpdateMap = false;
        }
        
        _disLocation.text = [NSString stringWithFormat:@"longitude: %.2f, latitude: %.2f", _locationData.location.longitude, _locationData.location.latitude];
        
        if ( !_isFirstUpdateMap ) {
            CLLocationCoordinate2D *arr = malloc(_locationData.locTrack.count * sizeof(CLLocationCoordinate2D));
            [_locationData.locTrack enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                arr[idx] = *(CLLocationCoordinate2D *)[obj bytes];
            }];
            
            [self.mapView removeOverlay:_locTrack];_locTrack = nil;
            _locTrack = [MKPolyline polylineWithCoordinates:arr count:_locationData.locTrack.count];
            [self.mapView addOverlay:_locTrack];
            free(arr);
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

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
//    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
//    polylineView.strokeColor = [UIColor redColor];
//    polylineView.lineWidth = 1.0;
//    
//    return polylineView;
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineRenderer *r = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    r.strokeColor = [UIColor greenColor];
    
    return r;
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
