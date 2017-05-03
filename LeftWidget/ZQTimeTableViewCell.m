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
        make.left.offset(15);
//        make.top.offset(10);
        make.centerY.offset(0);
        make.width.equalTo(@3);
        make.bottom.equalTo(self.stackView.mas_bottom);
//        make.bottom.offset(-5);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorView);
        make.left.equalTo(self.colorView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self).offset(-5);
    }];
    
    
//    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.colorView.mas_right).offset(10);
//        make.top.equalTo(self.colorView);
//        make.right.lessThanOrEqualTo(self).offset(-5);
//    }];
//    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftTimeLabel);
//        make.top.equalTo(self.leftTimeLabel.mas_bottom).offset(5);
//        make.right.lessThanOrEqualTo(self).offset(-5);
//    }];
//    
//    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftTimeLabel);
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//        make.right.lessThanOrEqualTo(self).offset(-5);
//    }];
//    
//    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftTimeLabel);
//        make.top.equalTo(self.locationLabel.mas_bottom).offset(5);
//        make.right.lessThanOrEqualTo(self).offset(-5);
//        make.bottom.equalTo(self).offset(-10);
//    }];
}

- (void)setEvent:(EKEvent *)event
{
    [self mockDataForEvent:event];
    
    _event = event;
    
    self.leftTimeLabel.text = [NSString stringWithFormat:@"还有 %@", [event.startDate leftTimeSinceNow]];
    self.titleLabel.text = event.title;
    self.locationLabel.text = event.location;
    self.durationLabel.text = [[NSDate date] durationUntilEndDate:event.startDate finalEndDate:event.endDate currentTimeZone:event.timeZone endTimeZone:event.timeZone finalEndTimeZone:event.timeZone];
}

- (void)mockDataForEvent:(EKEvent *)event
{
    event.title = @"哈哈";
    event.startDate = [NSDate date];
    event.location = @"location";
    event.location = nil;
    event.endDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 25];
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
        
        _leftTimeLabel.textColor = [UIColor whiteColor];
        
        _leftTimeLabel.font = [UIFont defaultFontWithSize:14];
        
//        [self.contentView addSubview:_leftTimeLabel];
  
    }
    return _leftTimeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont defaultFontWithSize:18];
        
//        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor whiteColor];
        
        _locationLabel.font = [UIFont defaultFontWithSize:14];

//        [self.contentView addSubview:_locationLabel];
    }
    return _locationLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont defaultFontWithSize:14];
        
//        [self.contentView addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        
        _stackView.alignment = UIStackViewAlignmentLeading;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = 5;
        
        [self.contentView addSubview:_stackView];
        
        [_stackView addArrangedSubview:self.leftTimeLabel];
        [_stackView addArrangedSubview:self.titleLabel];
        [_stackView addArrangedSubview:self.locationLabel];
        [_stackView addArrangedSubview:self.durationLabel];
        
    }
    return _stackView;
}

@end
