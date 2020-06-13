//
//  WiimoteButtonPart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"
#import "WiimoteDelegate.h"

@interface WiimoteButtonPart : WiimotePart
{
    @private
        BOOL _buttonState[WiimoteButtonCount];
}

- (BOOL)isButtonPressed:(WiimoteButtonType)button;

@end
