//
//  Login_ViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/28.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "Login_ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UserViewModel.h"
#import "UserDetailViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/RACReturnSignal.h>

@interface Login_ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) UserViewModel *userViewModel;

@end

@implementation Login_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindModel];
}

- (void)bindModel {
    _userViewModel = [[UserViewModel alloc] init];
    RAC(self.userViewModel, userName) = self.nameTextF.rac_textSignal;
    RAC(self.userViewModel, password) = self.passwordTextF.rac_textSignal;
    RAC(self.loginBtn, enabled) = [_userViewModel buttonIsValid];
    
    @weakify(self);
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        [self loadingAnimation];
        [self.userViewModel login];
    }];
    [self.userViewModel.successObject subscribeNext:^(NSArray *dataArray) {
        @strongify(self);
        [self dismissLoginAnimation];
        UserModel *model = [UserModel new];
        if (dataArray.count > 1) {
            model.userName = dataArray[0];
            model.password = dataArray[1];
        }
        UserDetailViewController *detailVc = [[UserDetailViewController alloc] init];
        detailVc.userModel = model;
        [self.navigationController pushViewController:detailVc animated:YES];
    }];
    
    [self.userViewModel.failureObject subscribeNext:^(NSString *message) {
        @strongify(self);
        [self dismissLoginAnimation];
    }];
    
    [self.userViewModel.errorObject subscribeError:^(NSError *error) {
        @strongify(self);
        [self dismissLoginAnimation];
    }];
}

- (void)loadingAnimation {
    [SVProgressHUD showWithStatus:@"登录中..."];
}

- (void)dismissLoginAnimation {
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dismissLoginAnimation];
}
-(void)dealloc {
    NSLog(@"[dealloc]%@",[self class]);
}

@end
