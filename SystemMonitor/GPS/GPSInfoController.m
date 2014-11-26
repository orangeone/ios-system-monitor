//
//  GPSInfoController.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import "HardcodedDeviceData.h"
#import "GPSInfoController.h"

@interface GPSInfoController()
@property (nonatomic, strong) GPSInfo   *gpsInfo;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDate  *start;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation GPSInfoController
@synthesize delegate;

@synthesize gpsInfo;
@synthesize placemark;
@synthesize locationManager;
@synthesize start;
@synthesize timer;

#pragma mark - private
- (void)updateDuration
{
    NSTimeInterval tid = [[NSDate date] timeIntervalSinceDate:start];
    self.gpsInfo.duration = [NSString stringWithFormat:@"%02li:%02li:%02li",
                             lround(floor(tid / 3600.)) % 100,
                             lround(floor(tid / 60.)) % 60,
                             lround(floor(tid)) % 60];
    
    if (self.delegate) {
        [self.delegate gpsStatusUpdated];
    }
}

#pragma mark - public

- (GPSInfo*)getGPSInfo
{
    self.gpsInfo = [[GPSInfo alloc] init];
    
    return self.gpsInfo;
}

- (void)startGPSMonitoring
{
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.geocoder = [[CLGeocoder alloc] init];

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.start = [NSDate date];
    }
    [self.locationManager startUpdatingLocation];

    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(updateDuration) userInfo:nil repeats:YES];
    }
}

- (void)stopGPSMonitoring
{
    if (self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    if (newLocation == nil) {
        return;
    }

    self.gpsInfo.location = newLocation;

    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.gpsInfo.address = [NSString stringWithFormat:@" %@\n 〒%@\n %@ %@ %@ %@ %@",
                                    self.placemark.country,
                                    self.placemark.postalCode,
                                    self.placemark.administrativeArea,
                                    self.placemark.subAdministrativeArea ? self.placemark.subAdministrativeArea : @"",
                                    self.placemark.locality,
                                    self.placemark.thoroughfare,
                                    self.placemark.subThoroughfare
                                    ];
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];

    if (self.delegate) {
        [self.delegate gpsStatusUpdated];
    }
}

@end
