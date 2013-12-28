//
//  QuotidianViewController.m
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "QuotidianViewController.h"

@interface QuotidianViewController ()
@property (nonatomic, strong) id delegate;
@property(nonatomic, retain) IBOutlet UITextField *goalField;
@end

@implementation QuotidianViewController

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

- (IBAction)pressSave:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(didAddNewGoal:)]) {
        [self.delegate didAddNewGoal: self.goalField.text];
    }
}

- (IBAction)pressCancel {
    if ([self.delegate respondsToSelector:@selector(didCancel)]) {
        [self.delegate didCancel];
    }
}

@end
