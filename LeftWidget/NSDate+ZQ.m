//
//  NSDate+ZQ.m
//  Left
//
//  Created by 郑志勤 on 2017/4/24.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "NSDate+ZQ.h"

NSDateFormatter *MZSharedDateFormatter(NSString *dateFormat) {
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter = nil;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    formatter.dateFormat = dateFormat;
    return formatter;
}

@implementation NSDate (ZQ)

- (NSString *)leftTimeSinceNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:units fromDate:self];
    NSDateComponents *currentComponents = [calendar components:units fromDate:[NSDate date]];

    NSTimeInterval timeIntervalLeft = [self timeIntervalSinceDate:[NSDate date]];
    if (timeIntervalLeft / 3600 < 24 && timeIntervalLeft / 3600 >= 0) { // 1天内
        return [NSString stringWithFormat:@"%ld小时%ld分钟", (NSUInteger)timeIntervalLeft / 3600, components.minute - currentComponents.minute];
    }
    
    if (components.day - currentComponents.day > 1) { // xx天xx小时
        return [NSString stringWithFormat:@"%ld天%ld小时", components.day - currentComponents.day, components.hour - currentComponents.hour];
    }
    
    if (components.minute - currentComponents.minute >= 1) {
        return [NSString stringWithFormat:@"%ld分钟", components.minute - currentComponents.minute];
    }
    
    return [NSString stringWithFormat:@"%ld秒", components.second - currentComponents.second];
}


- (NSString *)beautyLocalFormat {
    return [MZSharedDateFormatter(@"yyyy年MM月dd日 hh:mm:ss") stringFromDate:self];
}

- (NSString *)durationUntilEndDate:(NSDate *)endDate finalEndDate:(NSDate *)finalEndDate currentTimeZone:(NSTimeZone *)timeZone endTimeZone:(NSTimeZone *)endTimeZone finalEndTimeZone:(NSTimeZone *)finalEndTimeZone
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday;
    NSDateComponents *currentComponents = [calendar components:units fromDate:self];
    NSDateComponents *endComponents = [calendar components:units fromDate:endDate];
    
    NSString *desc = @"";
    if (endComponents.year == currentComponents.year && endComponents.month == currentComponents.month && endComponents.day - currentComponents.day <= 2) {
        NSInteger days = endComponents.day - currentComponents.day;
        if (days == 1) {
            desc = @"明天";
        } else if (days == 2) {
            desc = @"后天";
        } else if (days == 0) {
            desc = @"今天";
        }
    } else {
        NSString *weekDay = @"";
        switch (endComponents.weekday) {
            case 1:
                weekDay = @"天";
                break;
            case 2:
                weekDay = @"一";
                break;
            case 3:
                weekDay = @"二";
                break;
            case 4:
                weekDay = @"三";
                break;
            case 5:
                weekDay = @"四";
                break;
            case 6:
                weekDay = @"五";
                break;
            case 7:
                weekDay = @"六";
                break;
            default:
                break;
        }
        desc = [NSString stringWithFormat:@"星期%@", weekDay];
    }
    NSDateComponents *finalEndDateComponents = [calendar components:units fromDate:finalEndDate];

    NSInteger days = finalEndDateComponents.day - endComponents.day;
    
    NSString *plusDay = @"";
    
    if (finalEndDateComponents.month > endComponents.month || finalEndDateComponents.year > endComponents.year) {
        plusDay = [MZSharedDateFormatter(@"(MM月dd日)") stringFromDate:finalEndDate];
    } else {
        if (days > 0) { // 如果超过一个月这里不准,有bug
            plusDay = [NSString stringWithFormat:@"(+%ld)", days];
        }
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@-%@%@", [MZSharedDateFormatter(@"MM月dd日") stringFromDate:endDate], desc, [MZSharedDateFormatter(@"hh:mm") stringFromDate:endDate], [MZSharedDateFormatter(@"hh:mm") stringFromDate:finalEndDate], plusDay];
}

@end
