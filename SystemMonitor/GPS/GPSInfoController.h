//
//  GPSInfoController.h
//  SystemMonitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GPSInfo.h"

@protocol GPSInfoControllerDelegate
- (void)gpsStatusUpdated;
@end

@interface GPSInfoController : NSObject<CLLocationManagerDelegate>
@property (nonatomic, weak) id<GPSInfoControllerDelegate> delegate;

- (GPSInfo*)getGPSInfo;
- (void)startGPSMonitoring;
- (void)stopGPSMonitoring;
@end
