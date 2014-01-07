//
//  QuotidianViewController.m
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "NewHabitViewController.h"

@interface NewHabitViewController ()
@property (nonatomic, weak) id delegate;
@property(nonatomic, retain) IBOutlet UITextField *goalField;
@end

@implementation NewHabitViewController

@synthesize delegate = _delegate;
@synthesize goalField = _goalField;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}


- (IBAction)didFinishEnteringGoal:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(didDismissNewHabitModal:)]) {
        [self.delegate didDismissNewHabitModal: self.goalField.text];
    }
}

- (IBAction)pressCancel {
    if ([self.delegate respondsToSelector:@selector(didDismissNewHabitModal:)]) {
        [self.delegate didDismissNewHabitModal: nil];
    }
}

@end
