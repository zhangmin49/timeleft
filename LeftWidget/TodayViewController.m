//
//  TodayViewController.m
//  LeftWidget
//
//  Created by 郑志勤 on 2017/4/24.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import <EventKit/EventKit.h>
#import "Macro.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) EKEventStore *store;

@end

@implementation TodayViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchRecentEvent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    @weakify(self);
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        @strongify(self);
        if (granted) { //授权是否成功
            [[NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self fetchRecentEvent];
            }] fire];
        }
    }];
}

- (void)fetchRecentEvent
{
    NSArray<EKEvent *> *events = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *twoDays = [[NSDateComponents alloc] init];
    twoDays.day = 2;
    
    NSDateComponents *oneHundredYear = [[NSDateComponents alloc] init];
    oneHundredYear.year = 100;
    
    NSDate *twoDayFromNow = [calendar dateByAddingComponents:twoDays
                                                      toDate:[NSDate date]
                                                     options:0];
    
    events = [self requestForEventUtilDate:twoDayFromNow];
    if (events.count == 0) {
        NSDate *oneHundredYearFromNow = [calendar dateByAddingComponents:oneHundredYear toDate:[NSDate date] options:0];
        events = [self requestForEventUtilDate:oneHundredYearFromNow];
    }
    
    EKEvent *event = events.firstObject;
    if (event) {
        NSDate *startDate = event.startDate;
        
        self.dateLabel.text = event.title;
        self.locationLabel.text = event.location;
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%ld", [self minutesWithStartDate:[NSDate date] endDate:startDate]];
    }
}

- (NSInteger)minutesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSTimeInterval seconds = [startDate timeIntervalSinceDate:endDate];
    return seconds / 60;
}

- (NSArray<EKEvent *> *)requestForEventUtilDate:(NSDate *)date
{
    
    NSPredicate *predicate = [self.store predicateForEventsWithStartDate:[NSDate date]
                                                                 endDate:date
                                                               calendars:nil];
    
    NSArray<EKEvent *> *events = [self.store eventsMatchingPredicate:predicate];
    return events;
}

- (EKEventStore *)store
{
    if (!_store) {
        _store = [[EKEventStore alloc] init];
    }
    return _store;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}



@end
