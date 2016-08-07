//
//  HDateTool.h
//  HToolDemo
//
//  Created by hare27 on 16/8/6.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDateTool : NSObject

/** 判断一个日期是否今年*/
-(BOOL)dateIsThisYearForDate:(NSDate *)date;

/** 判断一个日期是否本月*/
-(BOOL)dateIsThisMonthForDate:(NSDate *)date;

/** 判断一个日期是否今天*/
-(BOOL)dateIsThisDayForDate:(NSDate *)date;


/** 根据样式，获取字符串对应的date*/
-(NSDate *)getDateWithFormat:(NSString *)format Frome:(NSString *)str;


/** 根据样式，获取date对应的字符串*/
-(NSString *)getStringWithFormat:(NSString *)format FromeDate:(NSDate *)date;

/**
 *  获取一个时间距离现在的时间描述
 *  例如：刚刚/5分钟前/5小时前/昨天/多少天前/11月12/2014年11月
 *  昨天23：59分显示为昨天
 */
-(NSString *)getStringSinceNowForDate:(NSDate *)date;

/**
 *  获取一个时间距离现在的时间具体描述
 *  例如：刚刚/5分钟前/5小时前/昨天/多少天前/11月12/2014年11月
 *  昨天23：59分显示为多少小时前或多少分钟前
 */
-(NSString *)getDetailStringSinceNowForDate:(NSDate *)date;


@end
