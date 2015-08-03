//
//  CalendarView.m
//  日历
//
//  Created by ljx on 15/5/19.
//  Copyright (c) 2015年 MacBook Pro. All rights reserved.
//

#import "JXCalendarView.h"
#import "CalendarCell.h"

#define kSelectColor [UIColor colorWithRed:246/255.0 green:201/255.0 blue:179/255.0 alpha:1]
#define kNowDateColor [UIColor colorWithRed:255/255.0 green:222/255.0 blue:173/255.0 alpha:1]

static NSString * const kCellIdentifier = @"ID";


@interface JXCalendarView(){
    int _rowNumber;
    CGFloat _scrollWidth;
    CGFloat _scrollViewHeight;
    
    CGFloat _frameWidth;
    CGFloat _cellWidth;
    
    //日历数据
    JXMonth *_lastMonth;
    JXMonth *_currentMonth;
    JXMonth *_nextMonth;
    
    CalendarCell *_lastCell;
}

@end

@implementation JXCalendarView

- (void)setCurrentMonth:(JXMonth *)month{
    _currentMonth = month;
    NSInteger lastYear = _currentMonth.year;
    NSInteger lastMonth = _currentMonth.month - 1;
    if (lastMonth < 1) {
        lastMonth = 12;
        lastYear = _currentMonth.year - 1;
    }
    _lastMonth = [[JXMonth alloc] initWithYear:lastYear month:lastMonth day:1];
    
    NSInteger nextYear = _currentMonth.year;
    NSInteger nextMonth = _currentMonth.month + 1;
    if (nextMonth > 12) {
        nextMonth = 1;
        nextYear = _currentMonth.year + 1;
    }
    _nextMonth = [[JXMonth alloc] initWithYear:nextYear month:nextMonth day:1];
    
    [_yearMonthButton setTitle:[NSString stringWithFormat:@"%ld月 %ld",(long)_currentMonth.month,(long)_currentMonth.year] forState:UIControlStateNormal];
    
    [_leftCollectionView reloadData];
    [_currentCollectionView reloadData];
    [_rightCollectionView reloadData];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //init
        _rowNumber = 6;
        
        _frameWidth = frame.size.width;
        _scrollWidth = frame.size.width;
        _cellWidth = (_frameWidth - 10) / 7.0;
        _scrollViewHeight = _rowNumber * (_cellWidth +1) + 1;
        
        CGFloat labelWidth = frame.size.width / 7.0;

        
        CGFloat topViewHeight = labelWidth * 0.8;
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, frame.size.width, topViewHeight);
        [self addSubview:_topView];
        
        _yearMonthButton = [[UIButton alloc] init];
        [_yearMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_yearMonthButton addTarget:self action:@selector(yearMonthButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        _yearMonthButton.frame = CGRectMake((frame.size.width - 100)/2.0, 0, 100, topViewHeight);
        [_yearMonthButton setTitleColor:[UIColor colorWithRed:0/255.0 green:174.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_topView addSubview:_yearMonthButton];
        
        //weekView初始化
        CGFloat weekHeight = labelWidth * 0.5;
        _weekView = [[UIView alloc] init];
        _weekView.frame = CGRectMake(0, topViewHeight, frame.size.width, weekHeight);
        _weekView.backgroundColor = [UIColor colorWithRed:195/255.0 green:220/255.0 blue:158/255.0 alpha:1];
        [self addSubview:_weekView];
        
        [self initWithLabel:_sunLabel text:@"周日" frame:CGRectMake(0, 0, labelWidth, weekHeight)];
        [self initWithLabel:_monLabel text:@"周一" frame:CGRectMake(labelWidth, 0, labelWidth, weekHeight)];
        [self initWithLabel:_tuesLabel text:@"周二" frame:CGRectMake(labelWidth * 2.0, 0, labelWidth, weekHeight)];
        [self initWithLabel:_wedLabel text:@"周三" frame:CGRectMake(labelWidth * 3.0, 0, labelWidth, weekHeight)];
        [self initWithLabel:_thurLabel text:@"周四" frame:CGRectMake(labelWidth * 4.0, 0, labelWidth, weekHeight)];
        [self initWithLabel:_friLabel text:@"周五" frame:CGRectMake(labelWidth * 5.0, 0, labelWidth, weekHeight)];
        [self initWithLabel:_satLabel text:@"周六" frame:CGRectMake(labelWidth * 6.0, 0, labelWidth, weekHeight)];
        
        
        //scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, weekHeight + topViewHeight, frame.size.width, _scrollViewHeight)];
        _scrollView.contentSize = CGSizeMake(frame.size.width * 3, _scrollViewHeight);
        _scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        [self addSubview:_scrollView];
        _scrollView.bounces =NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        
        
        UICollectionViewFlowLayout *leftFlowLayout=[[UICollectionViewFlowLayout alloc ]init];
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _scrollViewHeight) collectionViewLayout:leftFlowLayout];
        _leftCollectionView.tag = 10;
        [_scrollView addSubview:_leftCollectionView];

        UICollectionViewFlowLayout *currentFlowLayout=[[UICollectionViewFlowLayout alloc ]init];
        _currentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, _scrollViewHeight) collectionViewLayout:currentFlowLayout];
        _currentCollectionView.tag = 11;
        [_scrollView addSubview:_currentCollectionView];
        
        UICollectionViewFlowLayout *rightFlowLayout=[[UICollectionViewFlowLayout alloc ]init];
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, _scrollViewHeight) collectionViewLayout:rightFlowLayout];
        _rightCollectionView.tag = 12;
        [_scrollView addSubview:_rightCollectionView];

        
        _leftCollectionView.delegate = self;
        _leftCollectionView.dataSource = self;
        _currentCollectionView.delegate = self;
        _currentCollectionView.dataSource = self;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
        [_leftCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [_currentCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [_rightCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
        
        //数组
        _collectionViews = [[NSMutableArray alloc] init];
        
        [_collectionViews addObject:_leftCollectionView];
        [_collectionViews addObject:_currentCollectionView];
        [_collectionViews addObject:_rightCollectionView];
        
        _leftCollectionView.backgroundColor = [UIColor clearColor];
        _currentCollectionView.backgroundColor = [UIColor clearColor];
        _rightCollectionView.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        //日期选择
        _chooseDateView = [[UIView alloc] init];
        _chooseDateView.frame = CGRectMake(_frameWidth/7.0, _frameWidth/7.0, _frameWidth/7.0*5, _frameWidth/7.0*4.5);
        _chooseDateView.hidden = YES;
        _chooseDateView.backgroundColor = [UIColor whiteColor];
        _chooseDateView.layer.cornerRadius = 3.0;
        [_chooseDateView.layer setMasksToBounds:YES];
        [self addSubview:_chooseDateView];
        
        
        _backTodayButton = [[UIButton alloc] init];
        [_backTodayButton setTitle:@"回到今天" forState:UIControlStateNormal];
        [_backTodayButton addTarget:self action:@selector(backTodayButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_backTodayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backTodayButton.frame = CGRectMake(0, _frameWidth/7.0*3.5, _frameWidth/7*2.5, _frameWidth/7.0*1.0);
        [_backTodayButton setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
        [_chooseDateView addSubview:_backTodayButton];
        
        _confirmDateButton = [[UIButton alloc] init];
        [_confirmDateButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmDateButton addTarget:self action:@selector(confirmDateButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_confirmDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _confirmDateButton.frame = CGRectMake(_frameWidth/7.0*2.5, _frameWidth/7.0*3.5, _frameWidth/7.0*2.5, _frameWidth/7.0*1.0);
        [_confirmDateButton setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
        [_chooseDateView addSubview:_confirmDateButton];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.frame = CGRectMake(_frameWidth/7.0*2.5, _frameWidth/7.0*3.6, 1, _frameWidth/7.0*0.8);
        lb.backgroundColor = [UIColor grayColor];
        [_chooseDateView addSubview:lb];
        
        
        frame.size.height = _scrollViewHeight + _scrollView.frame.origin.y;
        self.frame = frame;
        
        [self setCurrentMonth:[self nowMonth]];
    }
    
    return self;
}

#pragma mark - CollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 10) {
        return _lastMonth.weekNumber * 7;
    }else if (collectionView.tag == 11) {
        return _currentMonth.weekNumber * 7;
    }else {
        return _nextMonth.weekNumber * 7;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat wh = (_frameWidth - 10) / 7.0;
    
    return CGSizeMake(wh, wh);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 2, 1, 2);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.view.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.dayLabel.text = @"";
    cell.dayLabel.textColor = [UIColor blackColor];
    
    if (collectionView.tag == 10) {
        
        NSInteger day = indexPath.item + 1 -(_lastMonth.firstWeekday - 1);
        if (day >= 1 && day <=_lastMonth.numbersOfDay) {
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
            
            NSDateComponents *dateComponent = [self dateComponentsWithYear:_lastMonth.year Month:_lastMonth.month day:day];
            
            if ([_delegate respondsToSelector:@selector(JXCalendarView:cell:WithLastMonthDateComponents:)]) {
                [_delegate JXCalendarView:self cell:cell WithLastMonthDateComponents:dateComponent];
            }
            
            NSString *displayDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)_lastMonth.year,(long)_lastMonth.month,(long)day];
            if ([[self NowDateString] isEqualToString:displayDate]) {
                cell.view.backgroundColor = kNowDateColor;
            }
        }
        
    }else if(collectionView.tag == 11){
        NSInteger day = indexPath.item + 1 -(_currentMonth.firstWeekday - 1);
        if (day >= 1 && day <=_currentMonth.numbersOfDay) {
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
            
            NSDateComponents *dateComponent = [self dateComponentsWithYear:_currentMonth.year Month:_currentMonth.month day:day];
            
            if ([_delegate respondsToSelector:@selector(JXCalendarView:cell:WithCurrentMonthDateComponents:)]) {
                [_delegate JXCalendarView:self cell:cell WithCurrentMonthDateComponents:dateComponent];
            }
            
            NSString *displayDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)_currentMonth.year,(long)_currentMonth.month,(long)day];
            if ([[self NowDateString] isEqualToString:displayDate]) {
                cell.view.backgroundColor = kNowDateColor;
            }
        }
    }else{
        NSInteger day = indexPath.item + 1 -(_nextMonth.firstWeekday - 1);
        if (day >= 1 && day <=_nextMonth.numbersOfDay) {
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
            
            NSDateComponents *dateComponent = [self dateComponentsWithYear:_nextMonth.year Month:_nextMonth.month day:day];
            
            if ([_delegate respondsToSelector:@selector(JXCalendarView:cell:WithNextMonthDateComponents:)]) {
                [_delegate JXCalendarView:self cell:cell WithNextMonthDateComponents:dateComponent];
            }
            
            NSString *displayDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)_nextMonth.year,(long)_nextMonth.month,(long)day];
            if ([[self NowDateString] isEqualToString:displayDate]) {
                cell.view.backgroundColor = kNowDateColor;
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger day = indexPath.item + 1 -(_currentMonth.firstWeekday - 1);
    CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (collectionView.tag == 10) {
        
    }else if(collectionView.tag == 11){
        if (day >= 1 && day <=_currentMonth.numbersOfDay) {
            
            if (_lastCell != nil) {
                _lastCell.view.backgroundColor = [UIColor clearColor];
            }
            _lastCell = cell;
            
            cell.view.backgroundColor = kSelectColor;
            NSDateComponents *dateComponent = [self dateComponentsWithYear:_currentMonth.year Month:_currentMonth.month day:day];
                        
            if ([_delegate respondsToSelector:@selector(JXCalendarView:DidSelectDateComponents:)]) {
                [_delegate JXCalendarView:self DidSelectDateComponents:dateComponent];
            }
        }
        
    }else{
        
        
    }
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    //滑到第三页及后面, 减0.1是为了防止出现，_scrollWidth为460.8x2＝921.6  然后x却为921.5  少了一点点出入
    if (x>=2*_scrollWidth-0.1) {
//        _scrollWidth = x;
        [self setCurrentMonth:_nextMonth];
        
        [_yearMonthButton setTitle:[NSString stringWithFormat:@"%ld月 %ld",(long)_currentMonth.month,(long)_currentMonth.year] forState:UIControlStateNormal];
        
        
        [self refreshScrollView];
    }
    //滑到第一页及前面
    if (x<=0) {
        
        [self setCurrentMonth:_lastMonth];
        
        [_yearMonthButton setTitle:[NSString stringWithFormat:@"%ld月 %ld",(long)_currentMonth.month,(long)_currentMonth.year] forState:UIControlStateNormal];
        
        [self refreshScrollView];
    }
}

-(void)refreshScrollView{
    
    //每次刷新，全部collectionView取消父控件
    NSMutableArray *subViews = (NSMutableArray *)[_scrollView subviews];
    if ([subViews count]>0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //添加三个子控件
    for (int i =0; i<3; i++) {
        
        UICollectionView *collectionView = [_collectionViews objectAtIndex:i];
        
        [_scrollView setContentOffset:CGPointMake(_scrollWidth, 0)];
        [_scrollView addSubview:collectionView];
        
    }
}


#pragma mark - Handler
- (void)yearMonthButtonHandler{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 0, _frameWidth/7.0*5.0, _frameWidth/7.0*3.5);
        _datePicker.datePickerMode=UIDatePickerModeDate;
        _datePicker.locale = [NSLocale systemLocale];
        [_chooseDateView addSubview:_datePicker];
    }
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hourString=[dateFormatter stringFromDate:nowDate];

    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld %@",(long)_currentMonth.year,(long)_currentMonth.month,(long)_currentMonth.day,hourString];
    NSDateFormatter  *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date2 = [dateFormatter2 dateFromString:dateString];
    [_datePicker setDate:date2 animated:NO];
    if (_chooseDateView.hidden) {
        _chooseDateView.hidden = NO;
    }else{
        _chooseDateView.hidden = YES;
    }
}

- (void)backTodayButtonHandler{
    _chooseDateView.hidden = YES;
    
    NSDate *date = [NSDate date];
    [_datePicker setDate:date animated:NO];
    
    [self setCurrentMonth:[self monthFromDate:date]];
}

- (void)confirmDateButtonHandler{
    _chooseDateView.hidden = YES;
    NSDate *date = _datePicker.date;
    
    [self setCurrentMonth:[self monthFromDate:date]];
}

#pragma mark - Private
- (void)initWithLabel:(UILabel *)label text:(NSString *)text frame:(CGRect)frame{
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:label.font.fontName size:14];
    label.text = text;
    label.frame = frame;
    [_weekView addSubview:label];
}

- (JXMonth *)monthFromDate:(NSDate *)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterFullStyle];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString=[dateformatter stringFromDate:date];
    
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSInteger year = [[dateArray firstObject] integerValue];
    NSInteger intMonth = [dateArray[1] integerValue];
    NSInteger day = [[dateArray lastObject] integerValue];
    JXMonth *month = [[JXMonth alloc] initWithYear:year month:intMonth day:day];
    return month;
}

//获取现在日期字符串 yyyy-MM-dd
- (NSString *)NowDateString{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSDateComponents *)dateComponentsWithYear:(NSInteger)year Month:(NSInteger)month day:(NSInteger)day{
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    [dateComponent setDay:day];
    [dateComponent setMonth:month];
    [dateComponent setYear:year];
    return dateComponent;
}

- (JXMonth *)nowMonth {
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *dateComponent = [dateString componentsSeparatedByString:@"-"];
    NSInteger y = [[dateComponent firstObject] integerValue];
    NSInteger m = [dateComponent[1] integerValue];
    NSInteger d = [[dateComponent lastObject] integerValue];
    JXMonth *month = [[JXMonth alloc] initWithYear:y month:m day:d];
    return month;
}

@end
