//
//  LoginViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/21.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setUpRACTextSigal];
}

- (void)setUpRACTextSigal {
    
}


@end
