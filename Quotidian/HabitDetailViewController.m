//
//  HabitDetailController.m
//  Quotidian
//
//  Created by Richard To on 1/5/14.
//  Copyright (c) 2014 Richard To. All rights reserved.
//

#import "HabitDetailViewController.h"

@interface HabitDetailViewController ()
@property (nonatomic, weak) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *habitLabel;
@end



@implementation HabitDetailViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    
    self.monthLabel.text = [dateFormatter stringFromDate: self.date];
    [dateFormatter setDateFormat:@"d"];
    
    self.dayLabel.text = [dateFormatter stringFromDate: self.date];
    self.habitLabel.text = self.goal.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (IBAction)didPressBarButton:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(didDismissDetailModal)]) {
        [self.delegate didDismissDetailModal];
    }
}

@end
