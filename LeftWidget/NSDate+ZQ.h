//
//  NSDate+ZQ.h
//  Left
//
//  Created by 郑志勤 on 2017/4/24.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZQ)
- (NSString *)leftTimeSinceNow;
- (NSString *)beautyLocalFormat;
- (NSString *)durationUntilEndDate:(NSDate *)endDate finalEndDate:(NSDate *)finalEndDate currentTimeZone:(NSTimeZone *)timeZone endTimeZone:(NSTimeZone *)endTimeZone finalEndTimeZone:(NSTimeZone *)finalEndTimeZone;
@end
