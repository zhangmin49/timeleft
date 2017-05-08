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

//- (NSString *)leftTimeSinceDate:(NSDate *)date
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
//    NSDateComponents *components = [calendar components:units fromDate:self];
//    NSDateComponents *currentComponents = [calendar components:units fromDate:date];
//    
//    NSTimeInterval timeIntervalLeft = [self timeIntervalSinceDate:date];
//    NSInteger days = ((NSInteger)timeIntervalLeft)/(3600*24);
//    NSInteger hours = ((NSInteger)timeIntervalLeft)%(3600*24)/3600;
//    NSInteger minutes = ((NSInteger)timeIntervalLeft)%(3600*24)%3600/60;
//    NSInteger seconds = ((NSInteger)timeIntervalLeft)%(3600*24)%3600%60;
//    
//    if (days >= 1) { // xx天xx小时
//        if (days == 0) {
//            return [NSString stringWithFormat:@"%ld小时", hours];
//        }
//        return [NSString stringWithFormat:@"%ld天%ld小时", days, hours];
//    }
//    
//    if (days < 1 && hours < 24 && hours >= 0) { // 1天内 24小时内
//        if (hours == 0) {
//            return [NSString stringWithFormat:@"%ld分钟", minutes];
//        }
//        return [NSString stringWithFormat:@"%ld小时%ld分钟", hours, minutes];
//    }
//    
//   
//    
//    if (components.minute - currentComponents.minute >= 1) {
//        return [NSString stringWithFormat:@"%ld分钟", components.minute - currentComponents.minute];
//    }
//    
//    if (components.second - currentComponents.second >= 1) {
//        return [NSString stringWithFormat:@"%ld秒", components.second - currentComponents.second];
//    }
//    
//    return @"";
//}

- (NSString *)leftTimeSinceDate:(NSDate *)date
{
    //时间间隔
    NSInteger intevalTime = [self timeIntervalSinceDate:date];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    
    if (intevalTime < 0) {
        return @"";
    }
    
    if (minutes <= 1 && minutes > 0) {
        return  [NSString stringWithFormat: @"%ld秒",(long)intevalTime];;
    } else if (minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟",(long)minutes];
    } else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时%ld分钟",(long)hours, (long)minutes % 60];
    } else {
        return [NSString stringWithFormat: @"%ld天%ld小时",(long)day, (long)hours % 24];
    }
    return @"";
}

- (NSString *)leftTimeSinceNowWithEndDate:(NSDate *)endDate
{
    NSString *leftTime = [self leftTimeSinceDate:[NSDate date]];
    if (leftTime.length == 0) {
        return [NSString stringWithFormat:@"距离结束还有 %@", [endDate leftTimeSinceDate:[NSDate date]]];
    }
    return [NSString stringWithFormat:@"还有%@", leftTime];
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
    if ([timeZone.name isEqualToString:endTimeZone.name] && [timeZone.name isEqualToString:finalEndTimeZone.name]) {
        return @"";
    }
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
    
    return [NSString stringWithFormat:@"[%@]%@-[%@]%@", [endTimeZone name] ?:@"默认时区", localEndDateString, [finalEndTimeZone name]?:@"默认时区", localFinalEndDateString];
}

@end
