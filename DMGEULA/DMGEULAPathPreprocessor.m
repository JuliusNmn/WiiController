//
//  DMGEULAPathPreprocessor.m
//  DMGEULA
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "DMGEULAPathPreprocessor.h"

@implementation DMGEULAPathPreprocessor

+ (DMGEULAPathPreprocessor*)sharedInstance
{
    static DMGEULAPathPreprocessor *result = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        result = [[DMGEULAPathPreprocessor alloc] init];
    });
    return result;
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    _variables = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)dealloc
{
    [_variables release];
    [super dealloc];
}

- (NSDictionary*)variables
{
    return [[_variables retain] autorelease];
}

- (void)setVariable:(NSString*)name value:(NSString*)value
{
    [_variables setObject:value forKey:name];
}

- (void)removeVariable:(NSString*)name
{
    [_variables removeObjectForKey:name];
}

- (NSString*)wrapVariableName:(NSString*)name
{
    return [NSString stringWithFormat:@"{%%%@%%}", name];
}

- (NSString*)preprocessString:(NSString*)string
{
    if(string == nil)
        return nil;

    NSEnumerator    *en     = [_variables keyEnumerator];
    NSString        *key    = [en nextObject];
    NSMutableString *result = nil;

    while(key != nil)
    {
        if([string rangeOfString:[self wrapVariableName:key]].length != 0)
        {
            result = [[string mutableCopy] autorelease];
            break;
        }

        key = [en nextObject];
    }

    if(result != nil)
    {
        while(key != nil)
        {
            [result replaceOccurrencesOfString:[self wrapVariableName:key]
                                    withString:[_variables objectForKey:key]
                                       options:0
                                         range:NSMakeRange(0, [result length])];

            key = [en nextObject];
        }

        return result;
    }

    return string;
}

@end
