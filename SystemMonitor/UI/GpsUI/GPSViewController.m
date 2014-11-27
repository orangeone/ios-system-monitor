//
//  GPSViewController.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import "AppDelegate.h"
#import "GLTube.h"
#import "GPSViewController.h"
#import "AMCommonUI.h"

enum {
    SECTION_BATTERY_TUBE=1
};

@interface GPSViewController() <GPSInfoControllerDelegate>
//@property (nonatomic, strong) GLTube    *glBatteryTube;
@property (nonatomic, strong) GLKView   *glView;

@property (nonatomic, weak) IBOutlet UILabel *gpsLatitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *gpsLongitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *gpsAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *gpsDurationLabel;


- (void)updateGpsLabels;
@end

@implementation GPSViewController

#pragma mark - override

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setBackgroundView:[AMCommonUI sectionBackgroundView]];
    
    DeviceSpecificUI *ui = [AppDelegate sharedDelegate].deviceSpecificUI;
    self.glView = [[GLKView alloc] initWithFrame:ui.GLtubeGLKViewFrame];
    self.glView.opaque = NO;
    self.glView.backgroundColor = [UIColor clearColor];
    //self.glBatteryTube = [[GLTube alloc] initWithGLKView:self.glView fromValue:0.0 toValue:100.0];
    
    AppDelegate *app = [AppDelegate sharedDelegate];
    [app.gpsInfoCtrl startGPSMonitoring];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [AppDelegate sharedDelegate];
    app.gpsInfoCtrl.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *app = [AppDelegate sharedDelegate];
    app.gpsInfoCtrl.delegate = nil;
    [app.gpsInfoCtrl stopGPSMonitoring];
}

#pragma mark - private

- (void)updateGpsLabels
{
    AppDelegate *app = [AppDelegate sharedDelegate];
    
    [self.gpsLatitudeLabel setText:[NSString stringWithFormat:@"%.8f", app.iDevice.gpsInfo.latitude]];
    [self.gpsLongitudeLabel setText:[NSString stringWithFormat:@"%.8f", app.iDevice.gpsInfo.longitude]];
    [self.gpsAddressLabel setText:app.iDevice.gpsInfo.address];
    [self.gpsDurationLabel setText:app.iDevice.gpsInfo.duration];
}

#pragma mark - table delegate

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
/*    if (section == SECTION_BATTERY_TUBE)
    {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TubeBackground"]];
        CGRect frame = backgroundView.frame;
        frame.origin.y = 20;
        backgroundView.frame = frame;
        UIView *view = [[UIView alloc] initWithFrame:self.glView.frame];
        [view addSubview:backgroundView];
        [view sendSubviewToBack:backgroundView];
        [view addSubview:self.glView];
        return view;
    }
*/
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
/*    if (section == SECTION_BATTERY_TUBE)
    {
        DeviceSpecificUI *ui = [AppDelegate sharedDelegate].deviceSpecificUI;
        return ui.GLtubeGLKViewFrame.size.height + 20;
    }
*/
    return 0.0;
}

#pragma mark - GPSInfoController delegate

- (void)gpsStatusUpdated
{
    [self updateGpsLabels];
}

@end
