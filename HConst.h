//
//  HRHeader.h
//  与乐笔记
//
//  Created by hare27 on 16/2/1.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define HLog(...) NSLog(__VA_ARGS__)
#else
#define HLog(...)
#endif

#define HColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define HRandColor HColor(arc4random()%256, arc4random()%256, arc4random()%256)

#define HScreenW [UIScreen mainScreen].bounds.size.width

#define HScreenH [UIScreen mainScreen].bounds.size.height