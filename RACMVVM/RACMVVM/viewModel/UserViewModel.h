//
//  UserViewModel.h
//  RACMVVM
//
//  Created by nero on 17/3/28.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface UserViewModel : NSObject
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;
- (id)buttonIsValid;
- (void)login;
@end
