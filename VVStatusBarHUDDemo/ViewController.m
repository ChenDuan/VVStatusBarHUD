//
//  ViewController.m
//  VVStatusBarHUDDemo
//
//  Created by 卫兵 on 15/10/27.
//  Copyright © 2015年 weibing. All rights reserved.
//

#import "ViewController.h"
#import "VVStatusBarHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarHUDDidClick:) name:VVStatusBarHUDDidClickNotification object:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)showSuccess
{
    [VVStatusBarHUD showSuccess:@"登录成功"];
}

- (IBAction)showError
{
    [VVStatusBarHUD showError:@"登录失败"];
}

- (IBAction)showText
{
    [VVStatusBarHUD showText:@"呵呵呵呵呵呵"];
}

- (IBAction)showLoading
{
    [VVStatusBarHUD showLoading:@"正在登录..."];
}
- (IBAction)hide
{
    [VVStatusBarHUD dismiss];
}


#pragma mark - 监听方法

-(void)statusBarHUDDidClick:(NSNotification *)note
{
    NSLog(@"点击了statusBarHUDDidClick---%@",note.userInfo);
}



@end
