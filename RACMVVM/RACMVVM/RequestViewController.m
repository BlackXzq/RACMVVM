//
//  RequestViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/22.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "RequestViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^requestSucessResponse)(NSDictionary *dict);
typedef void(^requestFailure)(NSInteger status, NSError *error);

@interface RequestViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic, strong) UITableView *useTableView;
@end

@implementation RequestViewController

-(void)dealloc {
    NSLog(@"[dealloc]%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.useTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(refreshData)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestClassList];
}

- (void)refreshData {
    [_dataArray removeAllObjects];
    [self.useTableView reloadData];
    [self requestClassList];
}

- (void)requestClassList {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"数据请求中..." ];
    RACSignal *IAPSignal = [self creatIAPClassListRequestSignal];
    RACSignal *normalSignal = [self creatNormalClassListSignal];
    /*
     // 1.请求先后顺序先IAP，再normal
    [[IAPSignal concat:normalSignal] subscribeNext:^(id x) {
        NSLog(@"[X];%@",x);
    }];
    */
    
    //2.两个请求完成后在 处理
    @weakify(self);
    [[[RACSignal combineLatest:@[IAPSignal, normalSignal] reduce:^id(NSDictionary *IAPDict, NSDictionary *normalDict){
        NSArray *iapClassArray = IAPDict[@"classlist"];
        NSArray *normalClassArray = normalDict[@"classlist"];
        return [iapClassArray arrayByAddingObjectsFromArray:normalClassArray];
    }] deliverOnMainThread] subscribeNext:^(NSArray *classArray) {
        @strongify(self);
        NSLog(@"classArray:%@",classArray);
        self.dataArray = [NSMutableArray arrayWithArray:classArray];
        [self.useTableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
    /*
    //3.两个请求复合的第二种方式
    [[IAPSignal merge:normalSignal] subscribeNext:^(id x) {
        NSLog(@"x:%@",x);
        [SVProgressHUD dismiss];
    }];
    */
    
}
#pragma mark- 模拟请求IAP课程信息
- (RACSignal *)creatIAPClassListRequestSignal {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self IAPClassReqeustSuccess:^(NSDictionary *dict) {
            [subscriber sendNext:dict];
            [subscriber sendCompleted];
        } failure:^(NSInteger status, NSError *error) {
        }];
         return nil;
    }];
}
- (void)IAPClassReqeustSuccess:(requestSucessResponse )success failure:(requestFailure)failure {
    NSInteger random = arc4random()%3;
    NSLog(@"[time]IAPClassReqeust:%@",@(random));
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(random*NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = @{@"classlist":@[@"IAP1", @"IAP2", @"IAP3"]};
        success(dict);
    });
}

#pragma mark- 模拟请求普通课程请求
- (RACSignal *)creatNormalClassListSignal {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self NormalClassReqeustSuccess:^(NSDictionary *dict) {
            [subscriber sendNext:dict];
            [subscriber sendCompleted];
        } failure:^(NSInteger status, NSError *error) {
            
        }];
        return nil;
    }];
}

- (void)NormalClassReqeustSuccess:(requestSucessResponse )success failure:(requestFailure)failure {
    NSInteger random = arc4random()%3;
    NSLog(@"[time]NormalClassReqeust:%@",@(random));
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(random*NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = @{@"classlist":@[@"normal1", @"normal2", @"normal3"]};
        success(dict);
    });
}

- (UITableView *)useTableView {
    if (!_useTableView) {
        _useTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _useTableView.delegate = self;
        _useTableView.dataSource = self;
    }
    return _useTableView;
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellKey = @"reusableCellKey";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellKey];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellKey];
    }
    if (_dataArray.count > indexPath.row) {
        NSString *title = _dataArray[indexPath.row];
        cell.textLabel.text = title;
    }
    return cell;
}



@end
