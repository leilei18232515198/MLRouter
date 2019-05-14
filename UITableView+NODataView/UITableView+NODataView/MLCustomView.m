//
//  MLCustomView.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/14.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLCustomView.h"

@implementation MLCustomView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 100, 100);
        button.center = self.center;
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"加载数据" forState:UIControlStateNormal];
        [self addSubview:button];
        self.button = button;
    }
    return self;
}
@end
