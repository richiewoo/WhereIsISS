//
//  ISSLocationData.h
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/10/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATION_DATA_OBSERVE_KEY @"location"

@interface ISSLocationData : NSObject

@property(nonatomic, assign) CLLocationCoordinate2D location;//The ISS location

- (void)startGetLocation;
- (void)stopGetLocation;
@end
