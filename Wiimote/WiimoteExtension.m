//
//  WiimoteExtension.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension.h"

#import "Wiimote.h"

@implementation WiimoteExtension

- (Wiimote*)owner
{
	return m_Owner;
}

- (NSString*)name
{
    return @"Unknown";
}

@end
