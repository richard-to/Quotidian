//
//  Goal+GoalAddon.m
//  Quotidian
//
//  Created by Richard To on 12/29/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Goal+Addon.h"

NSString *const CLASS_NAME = @"Goal";
NSString *const CLASS_COMPLETED_NAME = @"CompletedGoal";

NSString *const FETCH_DAILY_TODO_PRED =
    @"(SUBQUERY(completed, $a, $a.forDate > %@).@count == 0 OR ANY completed == nil) AND (active = %i)";
NSString *const FETCH_DAILY_COMPLETED_PRED =
    @"(ANY completed.forDate >= %@ AND ANY completed.forDate <= %@) AND (active = %i)";

@implementation Goal (Addon)

+ (NSString *)entityName
{
    return CLASS_NAME;
}

+ (Goal *)goalWithDefaults:(NSString *)title
   inManagedObjectContext:(NSManagedObjectContext *)context
{
    Goal *goal = [NSEntityDescription insertNewObjectForEntityForName:CLASS_NAME
                                               inManagedObjectContext:context];
    goal.title = title;
    goal.streak = [NSNumber numberWithInt: 0];
    goal.createdAt = [NSDate date];
    goal.active = [NSNumber numberWithBool:YES];
    
    return goal;
}

+ (NSArray *)fetchDailyTodoInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *dayRange = [Util dayRange];
    
    NSSortDescriptor *sortDescriptor =
        [NSSortDescriptor sortDescriptorWithKey:@"streak" ascending:YES];
    
    NSPredicate *predicate =
        [NSPredicate predicateWithFormat:FETCH_DAILY_TODO_PRED, dayRange[0], YES];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CLASS_NAME];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = predicate;
    
    NSError *error;
    NSArray *goals = [context executeFetchRequest:request error:&error];
    
    return goals;
}

+ (NSArray *)fetchDailyCompletedInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *dayRange = [Util dayRange];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"streak"
                                                                     ascending:YES];
    
    NSPredicate *predicate =
        [NSPredicate predicateWithFormat:FETCH_DAILY_COMPLETED_PRED, dayRange[0], dayRange[1], YES];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CLASS_NAME];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = predicate;

    NSError *error;
    NSArray *goals = [context executeFetchRequest:request error:&error];
    
    return goals;
}

+ (void)completedGoal:(Goal *)goal inManagedObjectContext:(NSManagedObjectContext *)context
{
    CompletedGoal *completed = [NSEntityDescription
                             insertNewObjectForEntityForName:CLASS_COMPLETED_NAME
                             inManagedObjectContext:context];
    completed.forDate = [NSDate date];
    completed.completed = [NSNumber numberWithBool:YES];
    if ([goal.streak intValue] < 0) {
        goal.streak = [NSNumber numberWithInt: 1];
    } else {
        goal.streak = [NSNumber numberWithInt: [goal.streak intValue] + 1];
    }
    [goal addCompletedObject:completed];
}

+ (void)undoCompletedGoal:(Goal *)goal inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *dayRange = [Util dayRange];
    for (CompletedGoal *completed in goal.completed) {
        if ([completed.forDate compare:dayRange[0]] == NSOrderedDescending
            && [completed.forDate compare:dayRange[1]] == NSOrderedAscending) {
            [goal removeCompletedObject:completed];
        }
    }
    
    if ([goal.streak intValue] > 1) {
        goal.streak = [NSNumber numberWithInt: [goal.streak intValue] - 1];
    } else {
        [self calcStreak:goal comprehensively:NO];
    }
}

// TODO(richard-to): Maybe move to util?
+ (void)calcStreak:(Goal *)goal comprehensively:(BOOL)comphrensive;
{
    BOOL hasHistory = NO;
    NSDate *lastCompletedDate = goal.createdAt;
    CompletedGoal *lastCompleted = [goal.completed lastObject];
    if (lastCompleted != nil) {
        lastCompletedDate = lastCompleted.forDate;
        hasHistory = YES;
    }
    int days = [Util dayDiffFromDate:lastCompletedDate to:[NSDate date]];
    
    if (hasHistory) {
        if (days == -1 && comphrensive) {
            int streak = 0;
            NSDate *endDate = [NSDate date];
            NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"forDate" ascending:NO];
            for (CompletedGoal *completed in [goal.completed sortedArrayUsingDescriptors: [NSArray arrayWithObject:dateSort]]) {
                int dayDiff = [Util dayDiffFromDate:completed.forDate to:endDate];
                if (dayDiff == -1) {
                    streak += 1;
                    endDate = completed.forDate;
                } else {
                    break;
                }
            }
            goal.streak = [NSNumber numberWithInt: streak];
        } else if (days < -1) {
            goal.streak = [NSNumber numberWithInt: days + 1];
        }
    } else {
        goal.streak = [NSNumber numberWithInt:days];
    }
}
@end
