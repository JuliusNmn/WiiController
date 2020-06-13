//
//  WiimoteDeviceReport+Private.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport.h"

@interface WiimoteDeviceReport (Private)

- (id)initWithDevice:(WiimoteDevice*)device;

- (BOOL)updateFromReportData:(const uint8_t*)data length:(NSUInteger)length;

@property(nonatomic) Wiimote *wiimote;
@property(nonatomic) WiimoteDevice *device;

@end
