//
//  HDateTool.h
//  HToolDemo
//
//  Created by hare27 on 16/8/6.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HDateFormatTypeYMDHms1,// yyyy-MM-dd HH:mm:ss
    HDateFormatTypeYMDHms2,// yyyy年MM月dd日 HH时mm分ss秒
    HDateFormatTypeYMD1,// yyyy-MM-dd
    HDateFormatTypeYMD2,// yyyy年MM月dd日
    HDateFormatTypeMD1,// MM-dd
    HDateFormatTypeMD2,// MM月dd日
    HDateFormatTypeHms1,// HH:mm:ss
    HDateFormatTypeHms2,// HH时mm分ss秒
} HDateFormatType;

@interface HDateTool : NSObject


@property(nonatomic,assign)HDateFormatType dateFormatType;


/** 判断一个日期是否今年*/
-(BOOL)dateIsThisYearForDate:(NSDate *)date;

/** 判断一个日期是否本月*/
-(BOOL)dateIsThisMonthForDate:(NSDate *)date;

/** 判断一个日期是否今天*/
-(BOOL)dateIsThisDayForDate:(NSDate *)date;


/** 根据你一个HDateFormatType给NSDateFormatter设置dateFormat属性*/
-(void)setDateFormatr:(NSDateFormatter *)fmt andType:(HDateFormatType)type;
/** 根据时间样式，获取dateformatter对象*/
-(NSDateFormatter *)dateFormatWithType:(HDateFormatType)fmtType;


/** 根据时间样式，获取date对应的字符串*/
-(NSString *)getStringWithType:(HDateFormatType)fmtType FromeDate:(NSDate *)date;
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
-(NSString *)detailStringSinceNowForDate:(NSDate *)date;


@end
