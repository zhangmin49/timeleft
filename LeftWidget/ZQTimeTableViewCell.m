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

UIColor *RGB(CGFloat r, CGFloat g, CGFloat b) {
    return RGBA(r, g, b, 1);
}

UIColor *RGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat alpha) {
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        make.top.offset(10);
        make.width.equalTo(@2);
        make.height.equalTo(self.stackView.mas_height);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorView);
        make.left.equalTo(self.colorView.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

- (void)setEvent:(EKEvent *)event
{
//    [self mockDataForEvent:event];
    
    _event = event;
    
    self.colorView.backgroundColor = [UIColor colorWithCGColor:event.calendar.CGColor];
    self.leftTimeLabel.text = [NSString stringWithFormat:@"%@", [event.startDate leftTimeSinceNow]];
    self.titleLabel.text = event.title;
    self.locationLabel.text = event.location;
    self.durationLabel.text = [[NSDate date] durationUntilEndDate:event.startDate finalEndDate:event.endDate];
    if (event.timeZone) {
        self.timeZoneDurationLabel.text = [[NSDate date] durationUntilEndDate:event.startDate finalEndDate:event.endDate currentTimeZone:[NSTimeZone localTimeZone] endTimeZone:event.timeZone finalEndTimeZone:event.timeZone];
    } else {
        self.timeZoneDurationLabel.text = @"";
    }
    
    [self layoutUIIfNeed];
}

- (void)layoutUIIfNeed
{
    self.leftTimeLabel.hidden = self.leftTimeLabel.text.length == 0;
    self.titleLabel.hidden = self.titleLabel.text.length == 0;
    self.locationLabel.hidden = self.locationLabel.text.length == 0;
    self.durationLabel.hidden = self.durationLabel.text.length == 0;
    self.timeZoneDurationLabel.hidden = self.timeZoneDurationLabel.text.length == 0;
    self.timezoneView.hidden = self.timeZoneDurationLabel.hidden;
}

- (void)mockDataForEvent:(EKEvent *)event
{
}

- (UIView *)colorView
{
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_colorView];
    }
    return _colorView;
}

- (UILabel *)leftTimeLabel
{
    if (!_leftTimeLabel) {
        _leftTimeLabel = [[UILabel alloc] init];
        
        _leftTimeLabel.textColor = RGB(54, 58, 56);
        
        _leftTimeLabel.font = [UIFont defaultFontWithSize:10];
        
//        [self.contentView addSubview:_leftTimeLabel];
  
    }
    return _leftTimeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textColor = RGB(0, 0, 0);
        _titleLabel.font = [UIFont defaultFontWithSize:15];
        
//        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = RGB(54, 58, 56);
        
        _locationLabel.font = [UIFont defaultFontWithSize:9];

//        [self.contentView addSubview:_locationLabel];
    }
    return _locationLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        
        _durationLabel.textColor = RGB(43, 45, 54);
        _durationLabel.font = [UIFont defaultFontWithSize:9];
        
//        [self.contentView addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (UILabel *)timeZoneDurationLabel
{
    if (!_timeZoneDurationLabel) {
        _timeZoneDurationLabel = [[UILabel alloc] init];
        
        _timeZoneDurationLabel.textColor = RGB(43, 45, 54);
        _timeZoneDurationLabel.font = [UIFont defaultFontWithSize:9];
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
