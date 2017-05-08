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
#import "NSDate+ZQ.h"
#import "ZQTimeTableViewCell.h"
#import <Masonry/Masonry.h>

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) EKEventStore *store;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<EKEvent *> *events;

@end

@implementation TodayViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef __IPHONE_10_0 //因为是iOS10才有的，还请记得适配
    //如果需要折叠
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [ZQTimeTableViewCell defaultHeight]; // 设置为一个接近“平均”行高的值
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:ZQTimeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(ZQTimeTableViewCell.class)];
    
    
    @weakify(self);
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        @strongify(self);
        if (granted) { //授权是否成功
            //            [[NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self fetchRecentEvent];
            //            }] fire];
        }
    }];
    
    //    // 高度要在mode后设置
    self.preferredContentSize = CGSizeMake(0, 300);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 10);
    } else {
        self.preferredContentSize = CGSizeMake(0, [ZQTimeTableViewCell defaultHeight]);
    }
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZQTimeTableViewCell.class) forIndexPath:indexPath];
    
    cell.event = self.events[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[UIViewController sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
    NSTimeInterval timeInterval = [self.events[indexPath.row].startDate timeIntervalSinceReferenceDate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"calshow:%lf", timeInterval]];
    [self.extensionContext openURL:url completionHandler:nil];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [ZQTimeTableViewCell defaultHeight];
////    return UITableViewAutomaticDimension;
//}

- (void)fetchRecentEvent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *twoDays = [[NSDateComponents alloc] init];
    twoDays.day = 2;
    
    NSDateComponents *oneHundredYear = [[NSDateComponents alloc] init];
    oneHundredYear.year = 100;
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDate *twoHoursAgo = [NSDate dateWithTimeIntervalSince1970:(now - 7200 - 1)];
    
    NSDate *twoDayFromNow = [calendar dateByAddingComponents:twoDays
                                                      toDate:twoHoursAgo
                                                     options:0];
    
    self.events = [self requestForEventUtilDate:twoDayFromNow];
    if (self.events.count == 0) {
        NSDate *oneHundredYearFromNow = [calendar dateByAddingComponents:oneHundredYear toDate:[NSDate date] options:0];
        NSArray *events = [self requestForEventUtilDate:oneHundredYearFromNow];
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSInteger i = 0; i < MIN(2, events.count); ++i) {
            [tmp addObject:events[i]];
        }
        self.events = [tmp copy];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        self.preferredContentSize = self.tableView.contentSize;
    });


//    EKEvent *event = events.firstObject;
//    if (event) {
//        self.dateLabel.text = event.title;
//        self.locationLabel.text = event.location;
//        self.timeLeftLabel.text = [NSString stringWithFormat:@"还有 %@", [event.startDate leftTimeSinceNow]];
//        self.startDateLabel.text = [event.startDate beautyLocalFormat];
//        self.endDateLabel.text = [event.endDate beautyLocalFormat];
//        
//    }
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

    @weakify(self);
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        @strongify(self);
        if (granted) { //授权是否成功
            //            [[NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self fetchRecentEvent];
            //            }] fire];
        }
        
        completionHandler(NCUpdateResultNewData);
    }];
    
    
}



@end
