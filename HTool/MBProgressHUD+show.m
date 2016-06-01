//
//  MBProgressHUD+show.m
//  rac
//
//  Created by hare27 on 16/6/1.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "MBProgressHUD+show.h"

@implementation MBProgressHUD (show)

+ (void)showMessage:(NSString *)message{
    [self hideHUD];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [self showHUDAddedTo:[self currentView] animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
}
+ (void)showSuccess:(NSString *)success{
    [self show:success icon:@"success.png"];
}
+ (void)showError:(NSString *)error{
    [self show:error icon:@"error.png"];
}

+ (void)show:(NSString *)text icon:(NSString *)icon{
    
    UIView *currentView = [self currentView];
    
    [self hideHUD];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [self showHUDAddedTo:currentView animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Show.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.2];
}

+ (UIView *)currentView{
    
    return [UIApplication sharedApplication].keyWindow;
}

+ (void)hideHUD
{
    [self hideAllHUDsForView:[self currentView] animated:YES];
}


@end
