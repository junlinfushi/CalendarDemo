
## JXCalendarDemo
> * 日历的展示

![此处输入图片的描述][1]


------

## 如何使用JXCalendar
> * 将JXCalendarView文件夹中的所有文件拽入项目中
> * 导入主头文件：#import "JXCalendarView.h"

## Delegate

    - (void)JXCalendarView:(JXCalendarView *)calendarView DidSelectDateComponents:(NSDateComponents *)dateComponent;

    - (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithCurrentMonthDateComponents:(NSDateComponents *)dateComponent;

    - (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithLastMonthDateComponents:(NSDateComponents *)dateComponent;

    - (void)JXCalendarView:(JXCalendarView *)calendarView cell:(CalendarCell *)cell WithNextMonthDateComponents:(NSDateComponents *)dateComponent;

  [1]: https://github.com/junlinfushi/JXCalendarDemo/blob/master/Calendar.gif?raw=true
