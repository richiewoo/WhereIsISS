//
//  ISSLocationData.m
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/10/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

#import "ISSLocationData.h"
#import "ASIHTTPRequest.h"

#define ISSLOCATION_URL @"http://api.open-notify.org/iss-now.json"
/*****
 Discription:
 
 URL:
 http://api.open-notify.org/iss-now.json
 
 Output(JSON):
 {
 "message": "success",
 "timestamp": UNIX_TIME_STAMP,
 "iss_position": {
 "latitude": CURRENT_LATITUDE,
 "longitude": CURRENT_LONGITUDE
 }
 }
 The data payload has a timestamp and an iss_position object with the latitude and longitude.
 
****/

#define KEY_LOCDATA_MESSAGE @"message"
#define KEY_LOCDATA_ISS_POSITION @"iss_position"
#define KEY_LOCDATA_POSITION_LATITUDE @"latitude"
#define KEY_LOCDATA_POSITION_LANGITUDE @"longitude"

@interface ISSLocationData()

@property(nonatomic, strong) ASIHTTPRequest* locationDataReq;
@property(nonatomic, assign) BOOL fetchFlag;

- (void) startLocationReq;

@end

@implementation ISSLocationData
@synthesize location;

- (instancetype)init{
    self = [super init];
    if (self) {
        _fetchFlag = false;
        self.location = CLLocationCoordinate2DMake(37.786996, -122.440100);//Yes, I am in San Frnacisco,
        [self startLocationReq];//where are you?
    }
    
    return self;
}

- (void) startLocationReq
{
    if (nil == _locationDataReq) {
        //Create HTTP request with URL
        _locationDataReq = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:ISSLOCATION_URL]];
        __weak ISSLocationData* selfWeak = self;
        [_locationDataReq setDataReceivedBlock:^(NSData *data){
            //the ISS work here
            NSError *error = nil;
            NSDictionary *loc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (nil == error) {
                if (nil != loc) {
                    if ([loc[KEY_LOCDATA_MESSAGE] isEqualToString:@"success"])
                    {
                        NSDictionary *iss_position = loc[KEY_LOCDATA_ISS_POSITION];
                        selfWeak.location = CLLocationCoordinate2DMake([iss_position[KEY_LOCDATA_POSITION_LATITUDE] doubleValue], [iss_position[KEY_LOCDATA_POSITION_LANGITUDE] doubleValue]);
                        
                    }
                }
            }
        }];
        //asynchronous networking,
        [_locationDataReq startAsynchronous];
        _locationDataReq = nil;
    }
}

- (void)startGetLocation
{
    _fetchFlag = true;
    __weak ISSLocationData* selfWeak = self;
    //Using the GCD with timer dispatch source to keep location update every second
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            if (_fetchFlag) {
                [selfWeak startLocationReq];
                
            }else{
                dispatch_source_cancel(timer);
            }
            
        });
        dispatch_resume(timer);
    }
}

- (void)stopGetLocation
{
    _fetchFlag = false;
}

@end
