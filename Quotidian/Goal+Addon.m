//
//  Goal+GoalAddon.m
//  Quotidian
//
//  Created by Richard To on 12/29/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Goal+Addon.h"

NSString *const CLASS_NAME = @"Goal";
NSString *const CLASS_COMPLETED_NAME = @"GoalCompleted";

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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(NONE goalsCompleted.forDate >= %@ AND NONE goalsCompleted.forDate <= %@) AND (active = %i)", dayRange[0], dayRange[1], YES];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY goalsCompleted.forDate >= %@ AND ANY goalsCompleted.forDate <= %@) AND (active = %i)", dayRange[0], dayRange[1], YES];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CLASS_NAME];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = predicate;
    
    NSError *error;
    NSArray *goals = [context executeFetchRequest:request error:&error];
    
    return goals;
}

// TODO(richard-to): Check to see if completed entity exists to avoid duplicates
+ (void)completedGoal:(Goal *)goal inManagedObjectContext:(NSManagedObjectContext *)context
{
    GoalCompleted *completed = [NSEntityDescription
                                 insertNewObjectForEntityForName:CLASS_COMPLETED_NAME
                                 inManagedObjectContext:context];
    completed.forDate = [NSDate date];
    completed.completed = [NSNumber numberWithBool:YES];
    goal.streak = [NSNumber numberWithInt: [goal.streak intValue] + 1];
    [goal addGoalsCompletedObject:completed];
}
@end
