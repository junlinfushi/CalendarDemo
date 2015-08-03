//
//  Month.m
//  日历
//
//  Created by ljx on 15/5/26.
//  Copyright (c) 2015年 MacBook Pro. All rights reserved.
//

#import "JXMonth.h"

@implementation JXMonth

- (id)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    self = [super init];
    if (self) {
        _year = year;
        _month = month;
        _day = day;
        _firstWeekday = [self weekdayWithYear:year month:month day:1];
        _numbersOfDay = [self numbersOfDaysWithYear:year month:month];
        _weekNumber = [self weekNumberWithYear:year month:month numbersOfDay:_numbersOfDay firstWeekday:_firstWeekday];
    }
    return self;
}

//根据年月，计算该月多少天
- (NSInteger)numbersOfDaysWithYear:(NSInteger)year month:(NSInteger)month{
    int days = 0;
    
    for (int i = 1; i <= 12; i++) {
        if (i == 2) {
            //是闰年
            if((year % 4 == 0 && year % 100!=0) || year % 400 == 0){
                days = 29;
            }else
            {
                days = 28;
            }
            
        }else if (i == 4 || i == 6 || i == 9 || i == 11){
            days = 30;
        }else{
            days = 31;
        }
        if(month == i){
            break;
        }
    }
//    NSLog(@"%d",days);
    return days;
}


//根据年月日，计算该天是星期几
- (NSInteger)weekdayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:day];
    [_comps setMonth:month];
    [_comps setYear:year];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    return _weekday;
}

//知道月份,计算出周数
- (NSInteger)weekNumberWithYear:(NSInteger)year month:(NSInteger)month numbersOfDay:(NSInteger)numbersOfDay firstWeekday:(NSInteger)firstWeekday{
    NSInteger weekNumber = 0;
    
    float a = (numbersOfDay - (7-firstWeekday+1))/7.0;
    weekNumber = 1 + ceilf(a);
    
//    NSLog(@"weekNumber %d",weekNumber);
    
    return weekNumber;
}

@end
