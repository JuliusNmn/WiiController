//
//  WiimoteBluetooth.m
//  Wiimote
//
//  Created by Ian Gregory on 2 May ’21.
//

#import "WiimoteBluetooth.h"

#import <IOBluetooth/IOBluetooth.h>

//extern Boolean IOBluetoothLocalDeviceAvailable(void);
//extern IOReturn IOBluetoothLocalDeviceGetPowerState(BluetoothHCIPowerState *state);

BOOL wiimoteIsBluetoothEnabled(void)
{
    if ([IOBluetoothHostController defaultController])
    {
        return [[IOBluetoothHostController defaultController] powerState]
             == kBluetoothHCIPowerStateON;
    }
    return NO;
}
