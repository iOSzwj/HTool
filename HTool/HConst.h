//
//  HRHeader.h
//  与乐笔记
//
//  Created by hare27 on 16/2/1.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 自定义log*/
#ifdef DEBUG
#define HLog(...) NSLog(@"%s %s %d \n %@\n\n",__FILE__,__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define HLog(...)
#endif

/** rgb颜色*/
#define HColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/** 随机色*/
#define HRandColor HColor(arc4random()%256, arc4random()%256, arc4random()%256)

/** 屏幕宽*/
#define HScreenW [UIScreen mainScreen].bounds.size.width

/** 屏幕高*/
#define HScreenH [UIScreen mainScreen].bounds.size.height