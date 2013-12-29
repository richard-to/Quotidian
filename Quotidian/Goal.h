//
//  Goal.h
//  Quotidian
//
//  Created by Richard To on 12/28/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GoalCompleted;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * streak;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSOrderedSet *goalsCompleted;
@end

@interface Goal (CoreDataGeneratedAccessors)

- (void)insertObject:(GoalCompleted *)value inGoalsCompletedAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGoalsCompletedAtIndex:(NSUInteger)idx;
- (void)insertGoalsCompleted:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGoalsCompletedAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGoalsCompletedAtIndex:(NSUInteger)idx withObject:(GoalCompleted *)value;
- (void)replaceGoalsCompletedAtIndexes:(NSIndexSet *)indexes withGoalsCompleted:(NSArray *)values;
- (void)addGoalsCompletedObject:(GoalCompleted *)value;
- (void)removeGoalsCompletedObject:(GoalCompleted *)value;
- (void)addGoalsCompleted:(NSOrderedSet *)values;
- (void)removeGoalsCompleted:(NSOrderedSet *)values;
@end
