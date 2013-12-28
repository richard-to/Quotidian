//
//  QuotidianViewController.h
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol QuotidianViewControllerDelegate <NSObject>
- (void)didAddNewGoal:(NSString *)goal;
- (void)didCancel;
@end

@interface QuotidianViewController : UIViewController
- (id)delegate;
- (void)setDelegate:(id)newDelegate;
@end
