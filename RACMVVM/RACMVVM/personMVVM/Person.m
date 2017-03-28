//
//  Person.m
//  RACMVVM
//
//  Created by nero on 17/3/27.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "Person.h"

@implementation Person
- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"LiNing";
        _sex = false;
        _birthDay = @"1975-09-09";
    }
    return self;
}
@end
