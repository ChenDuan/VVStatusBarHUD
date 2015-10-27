//
//  VVStatusBarHUD.m
//  VVStatusBarHUDDemo
//
//  Created by 卫兵 on 15/10/27.
//  Copyright © 2015年 weibing. All rights reserved.
//

#import "VVStatusBarHUD.h"


/** 弹出的窗口 */
static UIWindow *window_;
/** 定时器 */
static __weak NSTimer *timer_;


/** 显示和隐藏的动画的时间 */
static CGFloat const VVAnimationDuration = 1.25;
/** HUD完全显示后停留的时间 */
static CGFloat const VVStayDuration = 2.0;
/** 图片和文字之间的间距 */
static CGFloat const VVTitleImageMargin = 20;

/** 点击当前的HUD发出的通知 */
NSString * const VVStatusBarHUDDidClickNotification = @"VVStatusBarHUDDidClickNotification";

@implementation VVStatusBarHUD


#pragma mark - 公共方法

/**
 *  显示文本和图片
 */
+(void)showText:(NSString *)text image:(UIImage *)image
{
    // 初始化文字和图片内容
    [self setupText:text image:image];
    
    // 先停止之前的定时器
    [timer_ invalidate];
    
    // 定时器移除添加的HUD
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:VVAnimationDuration + VVStayDuration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    timer_ = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  显示文本和图片
 */
+(void)showText:(NSString *)text imageName:(NSString *)imageName
{
    [self showText:text image:[UIImage imageNamed:imageName]];
}

/**
 *  显示文本信息
 */
+(void)showText:(NSString *)text
{
    [self showText:text image:nil];
}

/**
 *  显示成功信息
 */
+(void)showSuccess:(NSString *)text
{
    [self showText:text imageName:@"VVStatusBarHUD.bundle/success"];
}

/**
 *  显示错误信息
 */
+(void)showError:(NSString *)text
{
    [self showText:text imageName:@"VVStatusBarHUD.bundle/error"];
}


/**
 *  显示正在加载的信息
 */
+(void)showLoading:(NSString *)text;
{
    // 根据文字和图片做一些初始化操作
    [self setupText:text image:nil];
    
    // 获取window_内部添加的按钮
    UIButton *btn = window_.subviews.firstObject;
    
    // 添加指示器
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [active startAnimating];
    [btn.titleLabel sizeToFit];
    // 计算位置
    CGFloat centerX = (window_.frame.size.width - btn.titleLabel.frame.size.width) * 0.5 - VVTitleImageMargin;
    CGFloat centerY = window_.frame.size.height * 0.5;
    active.center = CGPointMake(centerX, centerY);
    [window_ addSubview:active];
    
}

/**
 *  移除HUD
 */
+(void)dismiss
{
    // 移除定时器
    [timer_ invalidate];
    timer_ = nil;
    
    // 移除窗口
    CGRect endFrame = [UIApplication sharedApplication].statusBarFrame;
    endFrame.origin.y = -endFrame.size.height;
    [UIView animateWithDuration:VVAnimationDuration animations:^{
        window_.frame = endFrame;
    } completion:^(BOOL finished) { // 动画完成移除定时器
    
        // 注意增加判断，如果timer_有值，那么说明有新的提示弹出了，那么就不要清除窗口
        if (!timer_) {
            // 移除窗口
            window_ = nil;
        }
    }];
    
}

#pragma mark - 监听方法

/**
 *  顶部按钮的点击事件
 */
+(void)btnClick:(UIButton *)button
{
    // 发出通知
    NSDictionary *userInfo = @{@"title":button.currentTitle};
    [[NSNotificationCenter defaultCenter] postNotificationName:VVStatusBarHUDDidClickNotification object:nil userInfo:userInfo];
}


#pragma mark - 私有方法

/**
 *  初始化文本和图片内容
 */
+(void)setupText:(NSString *)text image:(UIImage *)image
{
    window_ = [[UIWindow alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:1.0];
    window_.hidden = NO;
    
    // 设置初始位置
    CGRect beginFrame = [UIApplication sharedApplication].statusBarFrame;
    beginFrame.origin.y = -beginFrame.size.height;
    window_.frame = beginFrame;
    
    // 添加内部控件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 监听点击
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    if (image)
    {
        [btn setImage:image forState:UIControlStateNormal];
        // 设置边距,左右各一半，不然不对称
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, VVTitleImageMargin * 0.5, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, VVTitleImageMargin * 0.5);
    }
    
    [btn setTitle:text forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, beginFrame.size.width, beginFrame.size.height);
    [window_ addSubview:btn];
    
    // 动画的显示出来
    [UIView animateWithDuration:VVAnimationDuration animations:^{
        CGRect endFrame = [UIApplication sharedApplication].statusBarFrame;
        window_.frame = endFrame;
    }];
}

@end
