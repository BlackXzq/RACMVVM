//
//  LoginViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/21.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation LoginViewController

-(void)dealloc {
    NSLog(@"[dealloc]%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setUpRACTextSigal];
}

- (void)setUpRACTextSigal {
    RACSignal *nameSignal = [self.nameText.rac_textSignal map:^id(NSString *nameTextValue) {
        NSInteger length = nameTextValue.length;
        if (length > 2) {
            return @(YES);
        } else {
            return @(NO);
        }
    }];
    
    RACSignal *passwordSignal = [self.passwordText.rac_textSignal map:^id(NSString *passwordTextValue) {
        NSInteger length = passwordTextValue.length;
        if (length > 5) {
            return @(YES);
        } else {
            return @(NO);
        }
    }];
    
    RACSignal *confirmSignal = [RACSignal combineLatest:@[self.passwordText.rac_textSignal, self.confirmText.rac_textSignal] reduce:^id(NSString *passwordValue, NSString *confirmValue){
        NSUInteger length = confirmValue.length;
        if (length >= 1 && [confirmValue isEqualToString:passwordValue]) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RAC(self.confirmBtn, enabled) = [RACSignal combineLatest:@[nameSignal, passwordSignal, confirmSignal] reduce:^id(NSNumber *isUserNameCorrect, NSNumber *isPasswordCorrect, NSNumber *isConfirmCorrect){
        return @(isUserNameCorrect.boolValue&&isPasswordCorrect.boolValue&&isConfirmCorrect.boolValue);
    }];
    
    @weakify(self);
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [SVProgressHUD showWithStatus:@"登录中..."];
        [self performSelector:@selector(backToUpViewController) withObject:nil afterDelay:1.5];
    }];
    
}

- (void)backToUpViewController {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
