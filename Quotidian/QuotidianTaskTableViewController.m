//
//  QuotidianTaskTableViewController.m
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "QuotidianViewController.h"
#import "QuotidianTaskTableViewController.h"

@interface QuotidianTaskTableViewController ()
@property (nonatomic, strong) NSArray *goalList;
@end

@implementation QuotidianTaskTableViewController

@synthesize goalList = _goalList;

- (void)viewDidAppear:(BOOL)animated
{
    //self.goalList = [[NSUserDefaults standardUserDefaults] objectForKey:@"goalsList"];
    //[self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setGoalList:(NSArray *)goalList
{
    _goalList = goalList;
    [self.tableView reloadData];
}

- (NSArray *)goalList
{
    if (_goalList == nil) {
        _goalList = [[NSUserDefaults standardUserDefaults] objectForKey:@"goalsList"];
    }
    return _goalList;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"New Goal"]) {
        QuotidianViewController *quotidianViewController = [segue destinationViewController];
        quotidianViewController.delegate = self;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didAddNewGoal:(NSString *)goal
{
    if ([goal length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *list = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"goalsList"] copyItems:YES];
        if (!list) {
            list = [[NSMutableArray alloc] init];
        }
        NSMutableDictionary *goalMeta = [[NSMutableDictionary alloc] init];
        [goalMeta setObject:goal forKey:@"title"];
        [list addObject: goalMeta];
        [[NSUserDefaults standardUserDefaults] setObject:[list copy] forKey:@"goalsList"];
        self.goalList = list;
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.goalList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Task Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *goal = [self.goalList objectAtIndex:indexPath.row];
    // Configure the cell...*/
    cell.textLabel.text = goal[@"title"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
