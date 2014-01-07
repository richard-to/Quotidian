//
//  HabitDetailController.h
//  Quotidian
//
//  Created by Richard To on 1/5/14.
//  Copyright (c) 2014 Richard To. All rights reserved.
//

#import "Goal.h"
#import <UIKit/UIKit.h>

@protocol HabitDetailViewControllerDelegate <NSObject>
- (void)didDismissDetailModal;
@end

@interface HabitDetailViewController : UIViewController

@property (nonatomic, weak) Goal *goal;
@property (nonatomic, weak) NSDate *date;

- (id)delegate;
- (void)setDelegate:(id)newDelegate;
@end
