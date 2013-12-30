//
//  Util.m
//  Quotidian
//
//  Created by Richard To on 12/30/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Util.h"

@implementation Util

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
@end
