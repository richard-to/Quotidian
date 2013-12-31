//
//  Goal.h
//  Quotidian
//
//  Created by Richard To on 12/30/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CompletedGoal;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * streak;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *completed;
@end

@interface Goal (CoreDataGeneratedAccessors)

- (void)insertObject:(CompletedGoal *)value inCompletedAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCompletedAtIndex:(NSUInteger)idx;
- (void)insertCompleted:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCompletedAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCompletedAtIndex:(NSUInteger)idx withObject:(CompletedGoal *)value;
- (void)replaceCompletedAtIndexes:(NSIndexSet *)indexes withCompleted:(NSArray *)values;
- (void)addCompletedObject:(CompletedGoal *)value;
- (void)removeCompletedObject:(CompletedGoal *)value;
- (void)addCompleted:(NSOrderedSet *)values;
- (void)removeCompleted:(NSOrderedSet *)values;
@end
