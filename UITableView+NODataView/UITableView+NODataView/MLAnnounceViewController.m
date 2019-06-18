//
//  MLAnnounceViewController.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/8.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLAnnounceViewController.h"
#import "UITableView+NODataView.h"
#import "MLRequestModel.h"
#import "MLHttpStringModel.h"
#import "MLCustomView.h"
@interface MLAnnounceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@end

@implementation MLAnnounceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    __weak typeof(self) weakSelf = self;
    [self.tableview setHeadReload:^{
        [weakSelf  tableViewReloadData:NO];
    }];
    
    [self.tableview setFooterReload:^{
        [weakSelf tableViewReloadData:YES];
    }];
    //    [tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (void)tableViewReloadData:(BOOL)isRefresh{
    MLRequestModel *model = [MLRequestModel new];
    model.isRefresh = isRefresh;
    model.url = [MLHttpStringModel appIndexString];
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:@"0" forKey:@"queryCourse.teacherId"];
    [dict setValue:@"0" forKey:@"queryCourse.subjectId"];
    [dict setValue:@"0" forKey:@"queryCourse.order"];
    model.param = dict;
    model.isCache = YES;
    model.pageName = @"page.currentPage";
    model.jsonAppropriate = @"entity/courseList";
    
    [self.tableview requestModel:model success:^(id  _Nonnull response) {
        
    } error:^(id  _Nonnull error) {
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    return cell;
}

//无数据显示
//- (UIImage *)noDataViewImage{
//
//    return [UIImage imageNamed:@"assessment"];
//}
//
//- (NSString *)noDataViewMessage{
//    return @"暂无数据";
//}

//自定义视图
//- (UIView *)noDataView{
//    MLCustomView *view = [[MLCustomView alloc]initWithFrame:self.tableview.bounds];
//    [view.button addTarget:self action:@selector(customActions:) forControlEvents:UIControlEventTouchUpInside];
//    return view;
//}
//
//- (void)customActions:(UIButton *)sender{
//    
////    if (self.tableview.reloadBlock) {
////    self.tableview.reloadBlock();
////    }
//}
@end
