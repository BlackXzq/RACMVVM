//
//  PersonViewModel.h
//  RACMVVM
//
//  Created by nero on 17/3/27.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface PersonViewModel : NSObject
- (instancetype)initWithPersonModel:(Person *)person;
@property (nonatomic, strong, readonly) Person *person;
@property (nonatomic, strong, readonly) NSString *fullName;
@property (nonatomic, strong, readonly) NSString *sex;
@property (nonatomic, assign, readonly) BOOL isMale;
@property (nonatomic, strong, readonly) NSString *age;
@end
