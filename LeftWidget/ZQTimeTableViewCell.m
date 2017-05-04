//
//  ZQTimeTableViewCell.m
//  Left
//
//  Created by 郑志勤 on 2017/4/24.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "ZQTimeTableViewCell.h"
#import <Masonry/Masonry.h>
#import "NSDate+ZQ.h"
#import "UIFont+ZQ.h"

@interface ZQTimeTableViewCell ()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *leftTimeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *timeZoneDurationLabel;

//@property (nonatomic, strong) UIView *timezoneDurationView;

@property (nonatomic, strong) UIView *timezoneView;

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation ZQTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self colorView];
        [self stackView];
        
        [self layoutUI];
    }
    return self;
}

+ (CGFloat)defaultHeight
{
    return 108;
//    return 98;
}

- (void)layoutUI
{
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
//        make.top.offset(10);
        make.centerY.offset(0);
        make.width.equalTo(@3);
        make.bottom.equalTo(self.stackView.mas_bottom);
//        make.bottom.offset(-5);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorView);
        make.left.equalTo(self.colorView.mas_right).offset(20);
        make.right.lessThanOrEqualTo(self).offset(-5);
    }];
}

- (void)setEvent:(EKEvent *)event
{
    [self mockDataForEvent:event];
    
    _event = event;
    
    self.leftTimeLabel.text = [NSString stringWithFormat:@"还有 %@", [event.startDate leftTimeSinceNow]];
    self.titleLabel.text = event.title;
    self.locationLabel.text = event.location;
    self.durationLabel.text = [[NSDate date] durationUntilEndDate:event.startDate finalEndDate:event.endDate];
    self.timeZoneDurationLabel.text = [[NSDate date] durationUntilEndDate:event.startDate finalEndDate:event.endDate currentTimeZone:event.timeZone endTimeZone:event.timeZone finalEndTimeZone:event.timeZone];
}

- (void)mockDataForEvent:(EKEvent *)event
{
//    event.title = @"哈哈";
//    event.startDate = [NSDate date];
//    event.location = @"location";
//    event.location = nil;
//    event.endDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 25];
}

- (UIView *)colorView
{
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_colorView];
    }
    return _colorView;
}

- (UILabel *)leftTimeLabel
{
    if (!_leftTimeLabel) {
        _leftTimeLabel = [[UILabel alloc] init];
        
        _leftTimeLabel.textColor = [UIColor blackColor];
        
        _leftTimeLabel.font = [UIFont defaultFontWithSize:12];
        
//        [self.contentView addSubview:_leftTimeLabel];
  
    }
    return _leftTimeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont defaultFontWithSize:13];
        
//        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor blackColor];
        
        _locationLabel.font = [UIFont defaultFontWithSize:10];

//        [self.contentView addSubview:_locationLabel];
    }
    return _locationLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        
        _durationLabel.textColor = [UIColor blackColor];
        _durationLabel.font = [UIFont defaultFontWithSize:10];
        
//        [self.contentView addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (UILabel *)timeZoneDurationLabel
{
    if (!_timeZoneDurationLabel) {
        _timeZoneDurationLabel = [[UILabel alloc] init];
        
        _timeZoneDurationLabel.textColor = [UIColor blackColor];
        _timeZoneDurationLabel.font = [UIFont defaultFontWithSize:10];
        _timeZoneDurationLabel.numberOfLines = 0;
        
        [self.timezoneView addSubview:_timeZoneDurationLabel];
        
        [_timeZoneDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.lessThanOrEqualTo(self.timezoneView.mas_right).offset(-5);
            make.centerY.offset(0);
        }];
    }
    return _timeZoneDurationLabel;
}

- (UIView *)timezoneView
{
    if (!_timezoneView) {
        _timezoneView = [[UIView alloc] init];
        
        _timezoneView.backgroundColor = [UIColor clearColor];
    }
    return _timezoneView;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        
        _stackView.alignment = UIStackViewAlignmentLeading;
        _stackView.axis = UILayoutConstraintAxisVertical;
//        _stackView.spacing = 2;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        
        [self.contentView addSubview:_stackView];
        
        [_stackView addArrangedSubview:self.leftTimeLabel];
        [_stackView addArrangedSubview:self.titleLabel];
        [_stackView addArrangedSubview:self.locationLabel];
        [_stackView addArrangedSubview:self.durationLabel];
        [_stackView addArrangedSubview:self.timezoneView];
//        [_stackView addArrangedSubview:self.timeZoneDurationLabel];
        
    }
    return _stackView;
}

@end
