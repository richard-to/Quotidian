//
//  QuotidianViewController.h
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NewHabitViewControllerDelegate <NSObject>
- (void)didDismissModal:(NSString *)goalTitle;
@end

@interface NewHabitViewController : UIViewController
- (id)delegate;
- (void)setDelegate:(id)newDelegate;
@end
