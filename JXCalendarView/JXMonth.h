//
//  Month.h
//  日历
//
//  Created by ljx on 15/5/26.
//  Copyright (c) 2015年 MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXMonth : NSObject


@property NSInteger year;  //所属年
@property NSInteger month;  //所属月
@property NSInteger firstWeekday;  //第一天是周几
@property NSInteger numbersOfDay;   //天数
@property NSInteger weekNumber;    //周数
@property NSInteger day;  //天

- (id)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
