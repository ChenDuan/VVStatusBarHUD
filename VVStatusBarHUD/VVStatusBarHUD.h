//
//  VVStatusBarHUD.h
//  VVStatusBarHUDDemo
//
//  Created by 卫兵 on 15/10/27.
//  Copyright © 2015年 weibing. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 点击当前的HUD发出的通知 */
UIKIT_EXTERN NSString * const VVStatusBarHUDDidClickNotification;

@interface VVStatusBarHUD : NSObject

/**
 *  显示成功信息
 */
+(void)showSuccess:(NSString *)text;

/**
 *  显示错误信息
 */
+(void)showError:(NSString *)text;

/**
 *  显示文本信息
 */
+(void)showText:(NSString *)text;

/**
 *  显示正在加载的信息
 */
+(void)showLoading:(NSString *)text;

/**
 *  移除HUD
 */
+(void)dismiss;

@end
