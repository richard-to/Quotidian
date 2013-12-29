//
//  GoalCompleted.h
//  Quotidian
//
//  Created by Richard To on 12/28/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GoalCompleted : NSManagedObject

@property (nonatomic, retain) NSDate * forDate;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * notes;

@end
