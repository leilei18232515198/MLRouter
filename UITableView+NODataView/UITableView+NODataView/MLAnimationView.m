//
//  MLAnimationView.m
//  UITableView+NODataView
//
//  Created by 杨磊 on 2019/5/14.
//  Copyright © 2019 杨磊. All rights reserved.
//

#import "MLAnimationView.h"

@implementation MLAnimationView


+ (instancetype)creatAnimationView{
    MLAnimationView *animationView = [[MLAnimationView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:animationView];
    return animationView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configureAnimationView];
    }
    return self;
}

- (void)configureAnimationView{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        =  self.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    [self.layer addSublayer:replicatorLayer];
    
    CALayer *dotLayer        = [CALayer layer];
    dotLayer.bounds          = CGRectMake(0, 0, 15, 15);
    dotLayer.position        = CGPointMake(15, replicatorLayer.frame.size.height/2 );
    dotLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6].CGColor;
    dotLayer.cornerRadius    = 7.5;
    [replicatorLayer addSublayer:dotLayer];
    
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(replicatorLayer.frame.size.width/3, 0, 0);
    
//    CGFloat count                     =  10.0;
//    replicatorLayer.instanceCount     = count;
//    CGFloat angel                     = 2* M_PI/count;
//    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0;
    animation.repeatCount = MAXFLOAT;
    [dotLayer addAnimation:animation forKey:nil];
    replicatorLayer.instanceDelay = 1.0/3;
    dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
}

- (void)removeAnimationView{
//    [self removeFromSuperview];
}
@end
