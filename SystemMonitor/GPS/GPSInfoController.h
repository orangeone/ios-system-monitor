//
//  GPSInfoController.h
//  SystemMonitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>

//#define SM_GPS_NOT_LINK
#define SM_GPS_DISABLED

#ifndef SM_GPS_NOT_LINK
#import <CoreLocation/CoreLocation.h>
#endif

#import "GPSInfo.h"

@protocol GPSInfoControllerDelegate
- (void)gpsStatusUpdated;
@end

#ifndef SM_GPS_NOT_LINK
@interface GPSInfoController : NSObject<CLLocationManagerDelegate>
#else
@interface GPSInfoController : NSObject
#endif

@property (nonatomic, weak) id<GPSInfoControllerDelegate> delegate;

- (GPSInfo*)getGPSInfo;
- (void)startGPSMonitoring;
- (void)stopGPSMonitoring;
@end
