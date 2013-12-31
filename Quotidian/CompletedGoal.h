//
//  CompletedGoal.h
//  Quotidian
//
//  Created by Richard To on 12/30/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CompletedGoal : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * forDate;
@property (nonatomic, retain) NSString * notes;

@end
