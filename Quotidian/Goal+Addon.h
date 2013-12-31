//
//  Goal+GoalAddon.h
//  Quotidian
//
//  Created by Richard To on 12/29/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Util.h"
#import "Goal.h"
#import "CompletedGoal.h"

@interface Goal (Addon)
+ (NSString *)entityName;
+ (Goal *)goalWithDefaults:(NSString *)title
   inManagedObjectContext: (NSManagedObjectContext *)context;
+ (NSArray *)fetchDailyTodoInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetchDailyCompletedInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)completedGoal:(Goal *)goal inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)undoCompletedGoal:(Goal *)goal inManagedObjectContext:(NSManagedObjectContext *)context;
@end
