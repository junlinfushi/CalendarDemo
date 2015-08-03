//
//  CalendarCollectionViewCell.m
//  日历
//
//  Created by ljx on 15/5/19.
//  Copyright (c) 2015年 MacBook Pro. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _view = [[UIView alloc] init];
        
        _dayLabel = [[UILabel alloc] init];
        CGFloat width = frame.size.width / 6.0 *5.0;
        CGFloat x = frame.size.width / 12.0;
        _dayLabel.frame = CGRectMake(0, 0, width, width);
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.backgroundColor = [UIColor clearColor];
        
        _view.frame = CGRectMake(x, x, width, width);
        
        [_view addSubview:_dayLabel];
        
//        _view.layer.cornerRadius = width/2.0;
//        [_view.layer setMasksToBounds:YES];
        [self addSubview:_view];
    }
    return self;
}

@end
