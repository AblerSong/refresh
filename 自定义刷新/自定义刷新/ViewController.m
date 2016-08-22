//
//  ViewController.m
//  自定义刷新
//
//  Created by song on 16/8/22.
//  Copyright © 2016年 song. All rights reserved.
//

#import "ViewController.h"
#import "YYRrefreshControl.h"

@interface ViewController ()

// 自定义tableView属性;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYRrefreshControl *refreshControl;

@end

@implementation ViewController

-(void)loadView{
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 相当于接收通知
    [self.refreshControl addTarget:self action:@selector(did) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
}

// 接收通知监听的方法
- (void)did{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - 懒加载 -
/**
 *  懒加载tableView
 *
 *  @return _tableView
 */
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

-(YYRrefreshControl *)refreshControl{
    if (_refreshControl == nil) {
        _refreshControl = [[YYRrefreshControl alloc] init];
    }
    return _refreshControl;
}
@end
