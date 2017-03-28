//
//  UserDetailViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/28.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *passwordLb;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameLb.text = self.userModel.userName;
    self.passwordLb.text = self.userModel.password;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {
    NSLog(@"[dealloc]%@",[self class]);
}

@end
