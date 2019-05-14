//
//  UITableView+NODataView.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/5.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "UITableView+NODataView.h"
#import "MLNOdataView.h"
#import <objc/runtime.h>
#import "MLRefreshHead.h"
#import <MJRefresh.h>
#import "MLRequestModel.h"
#import "MLRequestHttpModel.h"
@protocol TableViewDelegate <NSObject>
@optional
- (UIView *)noDataView;
- (UIImage *)noDataViewImage;
- (NSString *)noDataViewMessage;
- (UIColor *)noDataViewMessageColor;
- (NSNumber *)noDataViewCenterYOffset;

@end

@implementation UITableView (NODataView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method reloadData = class_getInstanceMethod(self, @selector(reloadData));
        Method replace_reloadData = class_getInstanceMethod(self, @selector(replace_reloadData));
        method_exchangeImplementations(reloadData, replace_reloadData);
        
        Method dealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method replace_dealloc = class_getInstanceMethod(self, @selector(replace_dealloc));
        method_exchangeImplementations(dealloc, replace_dealloc);
    });
}

- (void)replace_reloadData {
    [self replace_reloadData];
    //  忽略第一次加载
//    if (![self isInitFinish]) {
//        [self havingData:YES];
//        [self setIsInitFinish:YES];
//        return ;
//    }
    
    //  刷新完成之后检测数据量
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger numberOfSections = [self numberOfSections];
        BOOL havingData = NO;
        for (NSInteger i = 0; i < numberOfSections; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                havingData = YES;
                break;
            }
        }
        
        [self havingData:havingData];
    });
}

/**
 展示占位图
 */
- (void)havingData:(BOOL)havingData {
    
    //  不需要显示占位图
    if (havingData) {
        [self freeNoDataViewIfNeeded];
        self.backgroundView = nil;
        return ;
    }
    
    //  不需要重复创建
    if (self.backgroundView) {
        return ;
    }
    
    //  自定义了占位图
    if ([self.delegate respondsToSelector:@selector(noDataView)]) {
        self.backgroundView = [self.delegate performSelector:@selector(noDataView)];
        return ;
    }
    
    //  使用自带的
    UIImage  * img   = nil;
    NSString * msg   = @"暂无数据";
    UIColor  * color = [UIColor lightGrayColor];
    CGFloat  offset  = 0;
    
    //  获取图片
    if ([self.delegate    respondsToSelector:@selector(noDataViewImage)]) {
        img = [self.delegate performSelector:@selector(noDataViewImage)];
    }
    //  获取文字
    if ([self.delegate    respondsToSelector:@selector(noDataViewMessage)]) {
        msg = [self.delegate performSelector:@selector(noDataViewMessage)];
    }
    //  获取颜色
    if ([self.delegate      respondsToSelector:@selector(noDataViewMessageColor)]) {
        color = [self.delegate performSelector:@selector(noDataViewMessageColor)];
    }
    //  获取偏移量
    if ([self.delegate        respondsToSelector:@selector(noDataViewCenterYOffset)]) {
        offset = [[self.delegate performSelector:@selector(noDataViewCenterYOffset)] floatValue];
    }
    
    //  创建占位图
    self.backgroundView = [self defaultNoDataViewWithImage  :img message:msg color:color offsetY:offset];
}

/**
 默认的占位图
 */
- (UIView *)defaultNoDataViewWithImage:(UIImage *)image message:(NSString *)message color:(UIColor *)color offsetY:(CGFloat)offset {
    
    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.bounds.size.width;
    CGFloat cX = sW / 2;
    CGFloat cY = self.bounds.size.height * (1 - 0.618) + offset;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //  图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);
    imgView.image        = image;
    
    //  文字
    UILabel *label       = [[UILabel alloc] init];
    label.font           = [UIFont systemFontOfSize:17];
    label.textColor      = color;
    label.text           = message;
    label.textAlignment  = NSTextAlignmentCenter;
    label.frame          = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 24, sW, label.font.lineHeight);
    
    //  视图
    MLNOdataView *view   = [[MLNOdataView alloc] init];
    [view addSubview:imgView];
    [view addSubview:label];
    
    //  实现跟随 TableView 滚动
    [view addObserver:self forKeyPath:kNoDataViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
    return view;
}


/**
 监听
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kNoDataViewObserveKeyPath]) {
        
        /**
         在 TableView 滚动 ContentOffset 改变时, 会同步改变 backgroundView 的 frame.origin.y
         可以实现, backgroundView 位置相对于 TableView 不动, 但是我们希望
         backgroundView 跟随 TableView 的滚动而滚动, 只能强制设置 frame.origin.y 永远为 0
         兼容 MJRefresh
         */
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        if (frame.origin.y != 0) {
            frame.origin.y  = 0;
            self.backgroundView.frame = frame;
        }
    }
}



#pragma mark - 属性

// 加载完数据的标记属性名
static NSString * const kTableViewPropertyInitFinish = @"kTableViewPropertyInitFinish";

/**
 设置已经加载完成数据了
 */
- (void)setIsInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, &kTableViewPropertyInitFinish, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

/**
 是否已经加载完成数据
 */
- (BOOL)isInitFinish {
    id obj = objc_getAssociatedObject(self, &kTableViewPropertyInitFinish);
    return [obj boolValue];
}



/**
 分页的页数
 */
static NSString * const MLPageNumberIndex = @"MLPageNumberIndex";

- (void)setIndexNumber:(NSInteger)index {
    objc_setAssociatedObject(self, &MLPageNumberIndex, @(index), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)indexNumber {
    id obj = objc_getAssociatedObject(self, &MLPageNumberIndex);
    return [obj integerValue];
}


static NSString * const MLHaveNoMorePage = @"MLHaveNoMorePage";
/**
 判断是否还有分页
 */
- (void)setNoMorePage:(BOOL)isNoMore {
    objc_setAssociatedObject(self, &MLHaveNoMorePage, @(isNoMore), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)noMorePage {
    id obj = objc_getAssociatedObject(self, &MLHaveNoMorePage);
    return [obj boolValue];
}

static NSString * const MLReloadBlock = @"reloadBlock";
- (void)setReloadBlock:(void(^)(void))reloadBlock{
    objc_setAssociatedObject(self, &MLReloadBlock, reloadBlock, OBJC_ASSOCIATION_ASSIGN);
}

- (void(^)(void))reloadBlock{
    return objc_getAssociatedObject(self, &MLReloadBlock);
}
/**
 移除 KVO 监听
 */
- (void)freeNoDataViewIfNeeded {
    
    if ([self.backgroundView isKindOfClass:[MLNOdataView class]]) {
        [self.backgroundView removeObserver:self forKeyPath:kNoDataViewObserveKeyPath context:nil];
    }
}

- (void)setHeadReload:(void(^)(void))reloadBlock{
    self.mj_header = [MLRefreshHead headerWithRefreshingBlock:reloadBlock];
}

- (void)setFooterReload:(void(^)(void))reloadBlock{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:reloadBlock];
}

- (void)endRefresh{
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void)endNormalRefresh{
    [self.mj_footer endRefreshingWithNoMoreData];
    [self.mj_header endRefreshing];
}

- (void)requestModel:(MLRequestModel *)model success:(void(^)(id response)) success error:(void(^)(id error)) error{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:model.param];
    if (model.pageName.length > 0&&model.pageName) {
//   判断接口是否提供下拉刷新数据
        if (model.isRefresh) {
//            下拉刷新
            if (self.noMorePage) return [self endNormalRefresh];
            }else{
//            上拉刷新
            self.indexNumber = 0;
        }
        self.indexNumber ++;
        [dict setValue:@(self.indexNumber) forKey:model.pageName];
    }
    model.param = dict;
    [MLRequestHttpModel requestHttpModel:model success:^(id  _Nonnull response) {
        NSArray *array = (NSArray *)response;
        success (array);
//        判断分页里面是否包含数据
        if (array.count == 0) {
            self.noMorePage = YES;
            [self endNormalRefresh];
        }else{
            self.noMorePage = NO;
            [self endRefresh];
        }
    } error:^(id  _Nonnull errorResult) {
        self.indexNumber --;
        [self endRefresh];
        error (errorResult);
    }];
}

- (void)replace_dealloc {
    [self freeNoDataViewIfNeeded];
    [self replace_dealloc];
    NSLog(@"TableView 视图正常销毁");
}

@end
