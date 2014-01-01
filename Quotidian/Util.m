//
//  Util.m
//  Quotidian
//
//  Created by Richard To on 12/30/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Util.h"

@implementation Util

const int SECONDS_IN_MINUTE = 60;
const int MINUTES_IN_HOUR = 60;
const int HOURS_IN_DAY = 24;

+(NSArray *)dayRange
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    return [[NSArray alloc]  initWithObjects:startDate, endDate, nil];
}

+(int)dayDiffFromDate:(NSDate *)fromDate to:(NSDate *)toDate
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *toDateWithoutTime =
        [calendar dateFromComponents:[calendar components:unitFlags fromDate:toDate]];
    
    NSDate *fromDateWithoutTime =
        [calendar dateFromComponents:[calendar components:unitFlags  fromDate: fromDate]];
    
    NSTimeInterval fromInterval = [fromDateWithoutTime timeIntervalSinceNow];
    NSTimeInterval endInterval = [toDateWithoutTime timeIntervalSinceNow];
    NSTimeInterval elapsedInterval = fromInterval - endInterval;
    
    return round(elapsedInterval/SECONDS_IN_MINUTE/MINUTES_IN_HOUR/HOURS_IN_DAY);
}
@end
