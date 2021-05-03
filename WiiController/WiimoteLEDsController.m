//
//  WiimoteLEDsController.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/Wiimote.h>

#import "WiimoteLEDsController.h"

@interface WiimoteLEDsController (PrivatePart)

+ (void)recountConnectedDevices;

- (id)initInternal;

- (void)onDeviceConnected:(NSNotification *)notification;
- (void)onDeviceDisconnected:(NSNotification *)notification;

@end

@implementation WiimoteLEDsController

+ (void)start
{
    static WiimoteLEDsController *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[WiimoteLEDsController alloc] initInternal];
    });
}

@end

@implementation WiimoteLEDsController (PrivatePart)

+ (void)recountConnectedDevices
{
    NSArray *connectedDevices = [Wiimote connectedDevices];
    NSUInteger countConnected = [connectedDevices count];
    NSUInteger counter = 0;

    for (NSUInteger i = 0; i < countConnected; i++)
    {
        Wiimote *device = [connectedDevices objectAtIndex:i];

        [device setHighlightedLEDMask:(1 << counter)];
        counter++;
    }
}

- (id)initInternal
{
    self = [super init];
    if (self == nil)
        return nil;

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(onDeviceConnected:)
               name:WiimoteConnectedNotification
             object:nil];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(onDeviceDisconnected:)
               name:WiimoteDisconnectedNotification
             object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onDeviceConnected:(NSNotification *)notification
{
    [WiimoteLEDsController recountConnectedDevices];
    [[notification object] playConnectEffect];
}

- (void)onDeviceDisconnected:(NSNotification *)notification
{
    [WiimoteLEDsController recountConnectedDevices];
}

@end
