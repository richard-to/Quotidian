//
//  QuotidianTaskTableViewController.m
//  Quotidian
//
//  Created by Richard To on 12/25/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "Goal.h"
#import "Goal+Addon.h"
#import "CompletedGoal.h"
#import "DailyTableCell.h"
#import "NewHabitViewController.h"
#import "DailyTableViewController.h"
#import <CoreData/CoreData.h>

int const NUM_SECTIONS = 2;
int const SECTION_TODO = 0;
int const SECTION_COMPLETED = 1;
int const CELL_HEIGHT = 46;
int const HEADER_HEIGHT = 24;

NSString *const DOCUMENT_NAME = @"QuotidianDocument";
NSString *const SHORT_DATE_FORMAT = @"MMM d";
NSString *const TODO_HEADER = @"To Do";
NSString *const COMPLETED_HEADER = @"Completed";
NSString *const TODO_CELL_ID = @"Todo Cell";
NSString *const COMPLETED_CELL_ID = @"Todo Cell";

@interface DailyTableViewController ()
@property (nonatomic, strong) NSArray *todoList;
@property (nonatomic, strong) NSArray *completedList;
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation DailyTableViewController

@synthesize todoList = _todoList;
@synthesize completedList = _completedList;
@synthesize document = _document;
@synthesize context = _context;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitleToTodaysDate];
    [self initDocument];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont systemFontOfSize:13]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Helpers

-(void)setNavigationTitleToTodaysDate
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:SHORT_DATE_FORMAT];
    self.navigationItem.title = [dateFormatter stringFromDate:today];
}

-(void)initDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = DOCUMENT_NAME;
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

-(void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.context = self.document.managedObjectContext;
        [self setTodoList: [Goal fetchDailyTodoInManagedObjectContext:self.context]];
        [self setCompletedList: [Goal fetchDailyCompletedInManagedObjectContext:self.context]];
    }
};

-(void)moveGoalToCompleted:(Goal *)goal
{
    NSMutableArray *mutableTodoList = [NSMutableArray arrayWithArray:self.todoList];
    [mutableTodoList removeObject:goal];
    self.todoList = [NSArray arrayWithArray: mutableTodoList];
    
    NSMutableArray *mutableCompletedList = [NSMutableArray arrayWithArray:self.completedList];
    [mutableCompletedList addObject:goal];
    self.completedList = [NSArray arrayWithArray: mutableCompletedList];
}

-(void)moveGoalToToDo:(Goal *)goal
{
    NSMutableArray *mutableTodoList = [NSMutableArray arrayWithArray:self.completedList];
    [mutableTodoList removeObject:goal];
    self.completedList = [NSArray arrayWithArray: mutableTodoList];
    
    NSMutableArray *mutableCompletedList = [NSMutableArray arrayWithArray:self.todoList];
    [mutableCompletedList addObject:goal];
    self.todoList = [NSArray arrayWithArray: mutableCompletedList];
}

#pragma mark - New Habit View Controller Delegate

- (void)didDismissModal:(NSString *)goalTitle
{
    if ([goalTitle length] > 0 && self.document.documentState == UIDocumentStateNormal) {
        Goal *goal = [Goal goalWithDefaults:goalTitle inManagedObjectContext:self.context];
        NSMutableArray *mutableTodoList = [NSMutableArray arrayWithArray:self.todoList];
        [mutableTodoList addObject:goal];
        self.todoList = [NSArray arrayWithArray: mutableTodoList];
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}


#pragma mark - Mutators/Accessors

- (void)setTodoList:(NSArray *)todoList
{
    _todoList = todoList;
    [self.tableView reloadData];
}

- (NSArray *)todoList
{
    if (_todoList == nil) {
        _todoList = [[NSArray alloc] init];
    }
    return _todoList;
}

- (void)setCompletedList:(NSArray *)completedList
{
    _completedList = completedList;
    [self.tableView reloadData];
}

- (NSArray *)completedList
{
    if (_completedList == nil) {
        _completedList = [[NSArray alloc] init];
    }
    return _completedList;
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_TODO) {
        return TODO_HEADER;
    } else if (section == SECTION_COMPLETED) {
        return COMPLETED_HEADER;
    } else {
        return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_TODO) {
        return self.todoList.count;
    } else if (section == SECTION_COMPLETED) {
        return self.completedList.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goal *goal = nil;
    DailyTableCell *cell = nil;
    if (indexPath.section == SECTION_TODO) {
        cell = [tableView dequeueReusableCellWithIdentifier:TODO_CELL_ID forIndexPath:indexPath];
        goal = [self.todoList objectAtIndex:indexPath.row];
        [Goal calcStreak:goal comprehensively:NO];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:COMPLETED_CELL_ID forIndexPath:indexPath];
        goal = [self.completedList objectAtIndex:indexPath.row];
    }
    cell.titleLabel.text = goal.title;
    if ([goal.streak intValue] == 1) {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@ day", goal.streak];
    } else {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@ days", goal.streak];
    }
    [cell colorFromStreak: goal.streak];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {     
    if (indexPath.section == SECTION_TODO) {
        Goal *goal = [self.todoList objectAtIndex:indexPath.row];
        [Goal completedGoal:goal inManagedObjectContext:self.context];
        [self moveGoalToCompleted:goal];
    } else if (indexPath.section == SECTION_COMPLETED) {
        Goal *goal = [self.completedList objectAtIndex:indexPath.row];
        [Goal undoCompletedGoal:goal inManagedObjectContext:self.context];
        [self moveGoalToToDo:goal];
    }
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


#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"New Goal"]) {
         NewHabitViewController *quotidianViewController = [segue destinationViewController];
         quotidianViewController.delegate = self;
     }

 }


@end
