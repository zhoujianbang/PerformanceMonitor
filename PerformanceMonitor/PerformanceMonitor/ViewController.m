//
//  ViewController.m
//  PerformanceMonitor
//
//  Created by XuChengcheng on 2017/5/5.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import "ViewController.h"

#define kTableViewCellID @"kTableViewCellID"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellID];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID];

    if (indexPath.row % 10 == 0) {
        usleep(200 * 1000);
        cell.textLabel.text = @"包含耗时操作";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"cell %ld", indexPath.row];
    }
    
    return cell;
}

@end
