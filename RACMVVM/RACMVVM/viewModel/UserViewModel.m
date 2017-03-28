//
//  UserViewModel.m
//  RACMVVM
//
//  Created by nero on 17/3/28.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "UserViewModel.h"

@interface UserViewModel ()
@property(nonatomic,strong)RACSignal*userNameSignal;
@property(nonatomic,strong)RACSignal*passwordSignal;
@property(nonatomic,strong)NSArray*requestData;
@end

@implementation UserViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _userNameSignal = RACObserve(self, userName);
    _passwordSignal = RACObserve(self, password);
    _successObject = [RACSubject subject];
    _failureObject = [RACSubject subject];
    _errorObject = [RACSubject subject];
    
}

-(id)buttonIsValid {
    RACSignal *isValid = [RACSignal combineLatest:@[_userNameSignal, _passwordSignal]
                                           reduce:^id(NSString *userName, NSString *password){
                                               return @(userName.length > 3&&password.length > 3);
                                           }];
    return isValid;
}

- (void)login {
    [self performSelector:@selector(loginBtnClick) withObject:nil afterDelay:1.5];
}

- (void)loginBtnClick {
    NSInteger randX = arc4random()%3;
    switch (randX) {
        case 0:
        {
            _requestData = @[_userName, _password];
            [_successObject sendNext:_requestData];
        }
            break;
        case 1:
        {
            [_failureObject sendNext:@"密码校验失败"];
        }
            break;
        default:
        {
            NSError *error = [[NSError alloc] initWithDomain:@"error" code:1001 userInfo:@{@"message":@"网络异常"}];
            [_errorObject sendError:error];
        }
            break;
    }
}

@end
