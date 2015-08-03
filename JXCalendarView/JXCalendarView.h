//
//  CalendarView.h
//  日历
//
//  Created by ljx on 15/5/19.
//  Copyright (c) 2015年 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarCell.h"
#import "JXMonth.h"

@protocol JXCalendarViewDelegate;

@interface JXCalendarView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *currentCollectionView;
@property (strong, nonatomic) UICollectionView *leftCollectionView;
@property (strong, nonatomic) UICollectionView *rightCollectionView;

@property (strong, nonatomic) NSMutableArray *collectionViews;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *weekView;
@property UILabel *sunLabel;
@property UILabel *monLabel;
@property UILabel *tuesLabel;
@property UILabel *wedLabel;
@property UILabel *thurLabel;
@property UILabel *friLabel;
@property UILabel *satLabel;

@property (strong, nonatomic) UIView *topView;
@property UIButton *yearMonthButton;

@property UIView *chooseDateView;
@property UIDatePicker *datePicker;
@property UIButton *confirmDateButton;
@property UIButton *backTodayButton;


- (id)initWithFrame:(CGRect)frame;
- (void)setCurrentMonth:(JXMonth *)month;


@property (nonatomic) id<JXCalendarViewDelegate> delegate;

@end


@protocol JXCalendarViewDelegate <NSObject>
@optional

- (void)JXCalendarView:(JXCalendarView *)calendarView DidSelectDateComponents:(NSDateComponents *)dateComponent;

- (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithCurrentMonthDateComponents:(NSDateComponents *)dateComponent;

- (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithLastMonthDateComponents:(NSDateComponents *)dateComponent;

- (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithNextMonthDateComponents:(NSDateComponents *)dateComponent;


@end

