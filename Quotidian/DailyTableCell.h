//
//  QuotidianTableCell.h
//  Quotidian
//
//  Created by Richard To on 12/29/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
- (void)colorFromStreak:(NSNumber *)streak;
@end
