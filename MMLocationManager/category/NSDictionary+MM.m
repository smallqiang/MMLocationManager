//
//  NSDictionary+MM.m
//  MMLocationManager
//
//  Created by ChenYaoqiang on 14-9-18.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//

#import "NSDictionary+MM.h"

@implementation NSDictionary (MM)

- (NSString *)stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return @"";
}

@end
