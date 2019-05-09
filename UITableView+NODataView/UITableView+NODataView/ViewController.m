//
//  ViewController.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/5.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+NODataView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
//    [tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    return cell;
}

- (UIImage *)noDataViewImage{
    
    return [UIImage imageNamed:@"assessment"];
}

- (NSString *)noDataViewMessage{
    return @"暂无数据";
}

@end
