//
//  ZQTimeTableViewCell.h
//  Left
//
//  Created by 郑志勤 on 2017/4/24.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <EventKit/EventKit.h>

@interface ZQTimeTableViewCell : UITableViewCell

@property (nonatomic, strong) EKEvent *event;
+ (CGFloat)defaultHeight; // 可能用不到

@end
