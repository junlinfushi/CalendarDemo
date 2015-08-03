//
//  CalendarViewController.m
//  JXCalenderDemo
//
//  Created by ljx on 15/8/3.
//  Copyright (c) 2015年 MacBook Pro. All rights reserved.
//

#import "CalendarViewController.h"
#import "JXCalendarView.h"

@interface CalendarViewController () <JXCalendarViewDelegate> {
    JXCalendarView *_calendarView;
}

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _calendarView = [[JXCalendarView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100)];
    _calendarView.delegate = self;
    
    [self.view addSubview:_calendarView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CalendarViewDelegate
- (void)JXCalendarView:(JXCalendarView *)calendarView DidSelectDateComponents:(NSDateComponents *)dateComponent {
        NSLog(@"选中日期 %ld-%ld-%ld",(long)dateComponent.year,(long)dateComponent.month,(long)dateComponent.day);
    
}

- (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithLastMonthDateComponents:(NSDateComponents *)dateComponent {
        NSLog(@"Last日期 %ld-%ld-%ld",(long)dateComponent.year,(long)dateComponent.month,(long)dateComponent.day);
    
}

- (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithCurrentMonthDateComponents:(NSDateComponents *)dateComponent {
        NSLog(@"Current日期 %ld-%ld-%ld",(long)dateComponent.year,(long)dateComponent.month,(long)dateComponent.day);
    
}

- (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithNextMonthDateComponents:(NSDateComponents *)dateComponent {
        NSLog(@"Next日期 %ld-%ld-%ld",(long)dateComponent.year,(long)dateComponent.month,(long)dateComponent.day);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
