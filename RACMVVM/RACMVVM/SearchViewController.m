//
//  SearchViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/22.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "SearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void(^CheckNumberResponse)(BOOL);

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation SearchViewController

-(void)dealloc {
    NSLog(@"[dealloc]%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRACDemo];
    @weakify(self);
    [[self.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setRACDemo {
    
    @weakify(self);
 /*   [[self.inputText.rac_textSignal map:^id(NSString *value) {
        @strongify(self);
        BOOL isValidity = [self checkPhoneNumberValidityWithNumber:value];
       return @(isValidity);
    }] subscribeNext:^(NSNumber *value) {
        @strongify(self);
        if (value.boolValue) {
            self.inputText.backgroundColor = [UIColor whiteColor];
            self.checkBtn.enabled = YES;
            self.tipLabel.text = @"";
        } else {
            self.inputText.backgroundColor = [UIColor yellowColor];
            self.checkBtn.enabled = NO;
            if(self.inputText.text.length > 0){
                self.tipLabel.text = @"输入手机号不合法！";
            }
        }
    }];*/
    
    [[[[[self.inputText.rac_textSignal
     // 先将不合法的搜索词过滤掉（返回的bool值决定了signal是否继续向下传递）
     filter:^BOOL(NSString *searchKeyword) {
         return (searchKeyword.length > 0);
     }]
    // 因为没必要每次一输入便进行网络请求，所以0.5s之后，才进行检测。(throttle是在规定时间后，信号继续向下传递)
    throttle:0.5]
    // 网络请求将会返回signal，所以直接使用flattenMap来映射，而不必用map
    flattenMap:^RACStream *(NSString *value) {
        @strongify(self);
        NSLog(@"value:%@",value);
        return [self checkPhoneNumberSignal:value];
    }]
    deliverOnMainThread]
    subscribeNext:^(NSNumber *isValidity) {
        NSLog(@"isValidity:%@",isValidity);
        @strongify(self);
        if (isValidity.boolValue) {
            self.inputText.backgroundColor = [UIColor whiteColor];
            self.checkBtn.enabled = YES;
            self.tipLabel.text = @"";
        } else {
            self.inputText.backgroundColor = [UIColor yellowColor];
            self.checkBtn.enabled = NO;
            self.tipLabel.text = @"输入手机号不合法！";
        }
    }];
    
}

//模拟网络校验请求
- (void)checkValidityWithPhoneNumber:(NSString *)numberStr Completed:(CheckNumberResponse)response {
    NSLog(@"++++++++++========");
    @weakify(self);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        response([self checkPhoneNumberValidityWithNumber:numberStr]);
        NSLog(@"++++++++++----------");
    });
    NSLog(@"----------=========");
}
- (RACSignal *)checkPhoneNumberSignal:(NSString *)numberStr {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self checkValidityWithPhoneNumber:numberStr Completed:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)checkPhoneNumberValidityWithNumber:(NSString *)numberStr {
    return [self match:@"^(13\\d|14[57]|15[^4,\\D]|17[678]|18\\d)\\d{8}$|^170[059]\\d{7}$" withNumber:numberStr];
}

- (BOOL)match:(NSString *)pattern withNumber:(NSString *)numberStr {
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:numberStr options:0 range:NSMakeRange(0, numberStr.length)];
    return results.count > 0;
}

@end
