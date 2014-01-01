//
//  Util.h
//  Quotidian
//
//  Created by Richard To on 12/30/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+(NSArray *)dayRange;
+(int)dayDiffFromDate:(NSDate *)fromDate to:(NSDate *)toDate;
@end
