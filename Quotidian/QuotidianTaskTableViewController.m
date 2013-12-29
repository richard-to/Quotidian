//
//  QuotidianTaskTableViewController.m
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Goal.h"
#import "QuotidianViewController.h"
#import "QuotidianTaskTableViewController.h"
#import <CoreData/CoreData.h>

@interface QuotidianTaskTableViewController ()
@property (nonatomic, strong) NSArray *goalList;
@property (nonatomic, strong) UIManagedDocument *document;
@end

@implementation QuotidianTaskTableViewController

@synthesize goalList = _goalList;
@synthesize document = _document;


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
        _goalList = [[NSArray alloc] init];
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

-(void)documentIsReady {
    if (self.document.documentState == UIDocumentStateNormal) {
        NSManagedObjectContext *context = self.document.managedObjectContext;
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"streak"
                                                                            ascending:YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active = %i", YES];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Goal"];
        request.sortDescriptors = @[sortDescriptor];
        request.predicate = predicate;
        NSError *error;
        NSArray *goals = [context executeFetchRequest:request error:&error];
        [self setGoalList: goals];
    }
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create UIManagedDocument instance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self documentIsReady];
            } else {
                NSLog(@"Couldn't open document at %@", url);
            }
        }];
    } else {
        [self.document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              if (success) {
                  [self documentIsReady];
              } else {
                  NSLog(@"Couldn't create document at %@", url);
              }
          }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didAddNewGoal:(NSString *)goalTitle
{
    if ([goalTitle length] > 0) {
        if (self.document.documentState == UIDocumentStateNormal) {
            NSManagedObjectContext *context = self.document.managedObjectContext;
            Goal *goal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal"
                                                       inManagedObjectContext:context];
            goal.title = goalTitle;
            goal.streak = [NSNumber numberWithInt: 0];
            goal.createdAt = [NSDate date];
            goal.active = [NSNumber numberWithBool:YES];
            NSMutableArray *mutableGoalList = [NSMutableArray arrayWithArray:self.goalList];
            [mutableGoalList addObject:goal];
            self.goalList = [NSArray arrayWithArray: mutableGoalList];
        }
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
    static NSString *CellIdentifier = @"Task Incomplete Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Goal *goal = [self.goalList objectAtIndex:indexPath.row];
    // Configure the cell...*/
    cell.textLabel.text = goal.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Days", goal.streak];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d", indexPath.row);
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
