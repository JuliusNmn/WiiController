//
//  WiimoteDevicePair.m
//  Wiimote
//
//  Created by alxn1 on 30.06.13.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevicePair.h"

#import <IOBluetooth/IOBluetooth.h>

#import "WiimoteLog.h"

@interface WiimoteDevicePair (PrivatePart)

- (void)runWithDevice:(IOBluetoothDevice*)device;

@end

@implementation WiimoteDevicePair

+ (void)pairWithDevice:(IOBluetoothDevice*)device
{
	WiimoteDevicePair *pair = [[WiimoteDevicePair alloc] init];

	[pair runWithDevice:device];
}

- (id)init
{
	self = [super init];

	if(self == nil)
		return nil;

	_isFirstAttempt = YES;

	return self;
}

@end

@implementation WiimoteDevicePair (PrivatePart)

- (void)runWithDevice:(IOBluetoothDevice*)device
{
	__auto_type pair = [IOBluetoothDevicePair pairWithDevice:device];
	[pair setDelegate:self];

	if([pair start] != kIOReturnSuccess)
    {
        W_ERROR(@"[IOBluetoothDevicePair start] failed");
    }
}

- (NSData*)makePINCodeForDevice:(IOBluetoothDevice*)device
{
	NSString	*address		= nil;
	NSArray		*components		= nil;
	uint8_t		 bytes[6]		= { 0 };
	unsigned int value			= 0;

	if(_isFirstAttempt)
    {
        address = [[IOBluetoothHostController defaultController] addressAsString];
    }
    else
		address = [device addressString];

	components = [address componentsSeparatedByString:@"-"];
	if([components count] != 6)
		return nil;

	for(int i = 0; i < 6; i++)
	{
		NSScanner *scanner = [[NSScanner alloc] initWithString:[components objectAtIndex:i]];
		[scanner scanHexInt:&value];
		bytes[5 - i] = (uint8_t)value;
	}

	return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (void)devicePairingPINCodeRequest:(IOBluetoothDevicePair *)sender
{
	BluetoothPINCode	 PIN	= { 0 };
	NSData				*data	= [self makePINCodeForDevice:[sender device]];

	[data getBytes:PIN.data length:sizeof PIN];
	[sender replyPINCode:[data length] PINCode:&PIN];
}

- (void)devicePairingFinished:(IOBluetoothDevicePair *)sender error:(IOReturn)error
{
	if(error != kIOReturnSuccess)
	{
		if(_isFirstAttempt)
		{
			_isFirstAttempt = NO;
			[self runWithDevice:[sender device]];
			return;
		}

        W_ERROR_F(@"failed with error: %i", error);
	}

}

@end
