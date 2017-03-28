//
//  PersonViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/27.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PersonViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) PersonViewModel *personViewModel;
@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [[Person alloc] init];
    self.personViewModel = [[PersonViewModel alloc] initWithPersonModel:self.person];
    RAC(self.nameLabel, text) = RACObserve(self.personViewModel, fullName);
    RAC(self.sexLabel, text) = RACObserve(self.personViewModel, sex);
    RAC(self.ageLabel, text) = RACObserve(self.personViewModel, age);
    RAC(self.switchSex, on) = RACObserve(self.personViewModel, isMale);
    
    @weakify(self);
    //修改用户名
    [[self.nameInput.rac_textSignal filter:^BOOL(NSString *inputText) {
        NSInteger length = inputText.length;
        return (length > 2);
    }] subscribeNext:^(NSString *inputText) {
        @strongify(self);
        self.person.name = inputText;
    }];
    
    //修改性别
    RAC(self.person, sex) = [[self.switchSex rac_signalForControlEvents:UIControlEventValueChanged]
                             map:^id(UISwitch *swich) {
                                 return @(swich.isOn);
                             }];
    
//    [[self.switchSex rac_signalForControlEvents:UIControlEventValueChanged]
//     subscribeNext:^(UISwitch *swicth) {
//         @strongify(self);
//         self.person.sex = swicth.isOn;
//    }];
    //修改生日
    self.datePicker.maximumDate = [NSDate date];
    
    [[self.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         self.person.birthDay = [self dateToString:self.datePicker.date];
     }];
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

-(void)dealloc {
    NSLog(@"[dealloc]%@",[self class]);
}


@end
