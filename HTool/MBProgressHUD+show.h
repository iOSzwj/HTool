//
//  MBProgressHUD+show.h
//  rac
//
//  Created by hare27 on 16/6/1.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (show)

+ (void)showMessage:(NSString *)message;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)hideHUD;

@end
