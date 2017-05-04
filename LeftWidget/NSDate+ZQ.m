//
//  NSDate+ZQ.m
//  Left
//
//  Created by 郑志勤 on 2017/4/24.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "NSDate+ZQ.h"

NSDateFormatter *MZSharedDateFormatter(NSString *dateFormat) {
//    static dispatch_once_t onceToken;
//    static NSDateFormatter *formatter = nil;
//    dispatch_once(&onceToken, ^{
//        formatter = [[NSDateFormatter alloc] init];
//    });
//    formatter.dateFormat = dateFormat;
//    return formatter;
    // 为了让formatter变化，暂时不做单例
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
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
    if (timeIntervalLeft / 3600 < 24 && timeIntervalLeft / 3600 >= 0) { // 1天内 24小时内
        if ((NSUInteger)timeIntervalLeft / 3600 == 0) {
            return [NSString stringWithFormat:@"%ld分钟", (NSUInteger)timeIntervalLeft / 60];
        }
        return [NSString stringWithFormat:@"%ld小时%ld分钟", (NSUInteger)timeIntervalLeft / 3600, ((NSUInteger)timeIntervalLeft % 3600) / 60];
    }
    
    if (components.day - currentComponents.day > 1) { // xx天xx小时
        NSInteger days = components.day - currentComponents.day;
        
        NSInteger hours = components.hour - currentComponents.hour;
        if (hours < 0) {
            hours += 24;
            days --;
        }
        return [NSString stringWithFormat:@"%ld天%ld小时", days, hours];
    }
    
    if (components.minute - currentComponents.minute >= 1) {
        return [NSString stringWithFormat:@"%ld分钟", components.minute - currentComponents.minute];
    }
    
    return [NSString stringWithFormat:@"%ld秒", components.second - currentComponents.second];
}


- (NSString *)beautyLocalFormat {
    return [MZSharedDateFormatter(@"yyyy年MM月dd日 hh:mm:ss") stringFromDate:self];
}

- (NSString *)durationUntilEndDate:(NSDate *)endDate finalEndDate:(NSDate *)finalEndDate
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

- (NSString *)durationUntilEndDate:(NSDate *)endDate finalEndDate:(NSDate *)finalEndDate currentTimeZone:(NSTimeZone *)timeZone endTimeZone:(NSTimeZone *)endTimeZone finalEndTimeZone:(NSTimeZone *)finalEndTimeZone
{
    NSDateFormatter *localEndDateFormaterMD = MZSharedDateFormatter(@"MM月dd日");
    localEndDateFormaterMD.timeZone = endTimeZone;
    NSDateFormatter *localEndDateFormaterHM = MZSharedDateFormatter(@"hh:mm");
    localEndDateFormaterHM.timeZone = endTimeZone;
    NSDateFormatter *localFinalEndDateFormaterHM = MZSharedDateFormatter(@"hh:mm");
    localFinalEndDateFormaterHM.timeZone = finalEndTimeZone;
    NSDateFormatter *localFinalEndDateFormaterMD = MZSharedDateFormatter(@"MM月dd日");
    localFinalEndDateFormaterMD.timeZone = finalEndTimeZone;
//    NSString *localEndDateMD = [localEndDateFormaterMD stringFromDate:endDate];
    NSString *localEndDateHM = [localEndDateFormaterHM stringFromDate:endDate];
    NSString *localFinalDateHM = [localFinalEndDateFormaterHM stringFromDate:finalEndDate];
//    NSString *localFinalDateMD = [localFinalEndDateFormaterMD stringFromDate:finalEndDate];
    
    NSString *localEndDateString = endTimeZone ? [NSString stringWithFormat:@"%@", localEndDateHM] : @"";
    NSString *localFinalEndDateString = finalEndTimeZone ? [NSString stringWithFormat:@"%@", localFinalDateHM] : @"";
    
    return [NSString stringWithFormat:@"[%@]%@-[%@]%@", [endTimeZone name], localEndDateString, [finalEndTimeZone name], localFinalEndDateString];
}

@end
