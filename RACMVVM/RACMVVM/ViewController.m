//
//  ViewController.m
//  RACMVVM
//
//  Created by nero on 17/3/21.
//  Copyright © 2017年 xuzhanqiang. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "SearchViewController.h"
#import "RequestViewController.h"
#import "PersonViewController.h"
#import "Login_ViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic, strong) UITableView *useTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HOME";
    [self setLocalData];
    [self.useTableView reloadData];
}

- (void)setLocalData {
    _dataArray = [NSMutableArray array];
    NSString *loginTitle = @"登录";
    NSString *registerTitle = @"注册";
    NSString *searchTitle = @"搜索";
    NSString *blockTitle = @"block嵌套";
    NSString *personTitle = @"Person";
    [_dataArray addObjectsFromArray:@[loginTitle, registerTitle, searchTitle, blockTitle, personTitle]];
}

- (UITableView *)useTableView {
    if (!_useTableView) {
        _useTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                     style:UITableViewStylePlain];
        _useTableView.delegate = self;
        _useTableView.dataSource = self;
        [self.view addSubview:_useTableView];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reusableCellKey];
    }
    if (_dataArray.count > indexPath.row) {
        NSString *title = _dataArray[indexPath.row];
        cell.textLabel.text = title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
#pragma mark-UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (_dataArray.count <= indexPath.row) {
        return;
    }
    
    NSString *title = _dataArray[indexPath.row];
    UIViewController *newController = nil;
    if ([title hasPrefix:@"注册"]) {
        newController = [RegisterViewController new];
    } else if ([title hasPrefix:@"搜索"]) {
        newController = [SearchViewController new];
    } else if ([title hasPrefix:@"block"]) {
        newController = [RequestViewController new];
    } else if ([title hasPrefix:@"Person"]) {
        newController = [PersonViewController new];
    } else if ([title hasPrefix:@"登录"]) {
        newController = [Login_ViewController new];
    }
    
    if (newController) {
        newController.title = title;
        [self.navigationController pushViewController:newController animated:true];
    }
}



@end
