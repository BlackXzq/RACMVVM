//
//  PersonViewModel.m
//  RACMVVM
//
//  Created by nero on 17/3/27.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "PersonViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PersonViewModel ()
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, assign) BOOL isMale;
@end


@implementation PersonViewModel
-(instancetype)initWithPersonModel:(Person *)person {
    self = [super init];
    if (self) {
        @weakify(self);
        _person = person;
        RAC(self, fullName) = RACObserve(self.person, name);
        RAC(self, sex) = [RACObserve(self.person, sex) map:^id(NSNumber *value) {
            return value.boolValue?@"男":@"女";
        }];
        RAC(self, isMale) = RACObserve(self.person, sex);
        RAC(self, age) = [RACObserve(self.person, birthDay) map:^id(NSString *birthDate) {
            @strongify(self);
            return [self handlerBirthDate:birthDate];
        }];
    }
    return self;
}

- (NSString *)handlerBirthDate:(NSString *)birthDate {
    //计算年龄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birthDate];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    
    int age = ((int)time)/(3600*24*365);
    int day = ((int)time/(3600*24))%365 + 1;
    
    return [NSString stringWithFormat:@"%@ 岁 %@ 天",@(age), @(day)];
}
@end
