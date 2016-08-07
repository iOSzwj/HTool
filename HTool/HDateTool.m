//
//  HDateTool.m
//  HToolDemo
//
//  Created by hare27 on 16/8/6.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HDateTool.h"

@interface HDateTool()

@property(nonatomic,strong)NSDateFormatter *dateFormatter;

@property(nonatomic,strong)NSCalendar *calendar;

@end

@implementation HDateTool

/** 判断一个日期是否今年*/
-(BOOL)dateIsThisYearForDate:(NSDate *)date{
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:[NSDate date]];
    return cmps_now.year == cmps_date.year;
}

/** 判断一个日期是否本月*/
-(BOOL)dateIsThisMonthForDate:(NSDate *)date{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:[NSDate date]];
    return cmps_now.year == cmps_date.year
    &&cmps_now.month == cmps_date.month;
}

/** 判断一个日期是否今天*/
-(BOOL)dateIsThisDayForDate:(NSDate *)date{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:[NSDate date]];
    return cmps_now.year == cmps_date.year
    &&cmps_now.month == cmps_date.month
    &&cmps_now.day == cmps_date.day;
}

/** 判断一个日期是否昨天*/
-(BOOL)dateIsYesterDayForDate:(NSDate *)date{
    NSDate *now = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:now];
    
    if (cmps_now.day == 1) {
        // 前一天
        now = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
        cmps_now = [self.calendar components:unit fromDate:now];
        
        return cmps_now.year == cmps_date.year
        && cmps_now.month == cmps_date.month
        && cmps_now.day == cmps_date.day;
        
    }else{
        return cmps_now.year == cmps_date.year
        && cmps_now.month == cmps_date.month
        && cmps_now.day - cmps_date.day == 1;
    }

}

/** 根据样式，获取date对应的字符串*/
-(NSString *)getStringWithFormat:(NSString *)format FromeDate:(NSDate *)date{
    if (date == nil || format == nil || format.length == 0) {
        return nil;
    }else{
        self.dateFormatter.dateFormat = format;
        return [self.dateFormatter stringFromDate:date];
    }
}


/** 根据样式，获取字符串对应的date*/
-(NSDate *)getDateWithFormat:(NSString *)format Frome:(NSString *)str{
    if (format == nil || format.length == 0 || str == nil || str.length == 0) {
        return nil;
    }
    self.dateFormatter.dateFormat = format;
    return [self.dateFormatter dateFromString:str];
}


/**
 *  获取一个时间距离现在的时间描述
 *  例如：刚刚/5分钟前/5小时前/昨天/多少天前/11月12/2014年11月
 *  昨天23：59分显示为昨天
 */
-(NSString *)getStringSinceNowForDate:(NSDate *)date{
    
    NSDate *date_temp = [NSDate date];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:date_temp];
    
    if ([self dateIsYesterDayForDate:date]) {
        return [NSString stringWithFormat:@"昨天%d点%d分",(int)cmps_date.hour,(int)cmps_date.minute];
    }else if (cmps_now.year != cmps_date.year) {
        return [NSString stringWithFormat:@"%d年%d月%d日",(int)cmps_date.year,(int)cmps_date.month,(int)cmps_date.day];
    }else if(cmps_now.month != cmps_date.month) {
        return [NSString stringWithFormat:@"%d月%d日%d点",(int)cmps_date.month,(int)cmps_date.day,(int)cmps_date.hour];
    }else if(cmps_now.day - cmps_date.day > 1) {
        return [NSString stringWithFormat:@"%d月%d日%d点",(int)cmps_date.month,(int)cmps_date.day,(int)cmps_date.hour];
    }else if(cmps_now.day - cmps_date.day < 0) {
        return @"系统时间错误";
    }
    
    return [self getDetailStringSinceNowForDate:date];
    
}

/**
 *  获取一个时间距离现在的时间具体描述
 *  例如：刚刚/5分钟前/5小时前/昨天/多少天前/11月12/2014年11月
 *  昨天23：59分显示为多少小时前或多少分钟前
 */
-(NSString *)getDetailStringSinceNowForDate:(NSDate *)date{
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [self.calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    if (cmps.year) {
        return [NSString stringWithFormat:@"%d年前",(int)cmps.year];
    }else if(cmps.month){
        return [NSString stringWithFormat:@"%d个月前",(int)cmps.month];
    }else if(cmps.day){
        return [NSString stringWithFormat:@"%d天前",(int)cmps.day];
    }else if(cmps.hour){
        return [NSString stringWithFormat:@"%d个小时前",(int)cmps.hour];
    }else if(cmps.minute){
        return [NSString stringWithFormat:@"%d分钟前",(int)cmps.minute];
    }else{
        return @"刚刚";
    }
    
}


- (NSCalendar *)calendar {
	if(_calendar == nil) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        }else{
            _calendar = [NSCalendar currentCalendar];
        }
	}
	return _calendar;
}

- (NSDateFormatter *)dateFormatter {
	if(_dateFormatter == nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
	}
	return _dateFormatter;
}
@end
