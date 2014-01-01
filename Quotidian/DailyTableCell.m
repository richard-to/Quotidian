//
//  QuotidianTableCell.m
//  Quotidian
//
//  Created by Richard To on 12/29/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "DailyTableCell.h"

// TODO(richard-to): Should make this more dynamic at some point.

typedef struct {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
} hsba;

const hsba defaultBg = {
    200/360.0,
    0.42,
    0.8,
    1.0
};

const hsba defaultDetail = {
    200.0/360.0,
    0.42,
    0.37,
    1.0
};

const hsba awesomeBg = {
    125.0/360.0,
    0.42,
    0.8,
    1.0
};

const hsba awesomeDetail = {
    125.0/360.0,
    0.42,
    0.37,
    1.0
};

const hsba greatBg = {
    100.0/360.0,
    0.42,
    0.8,
    1.0
};

const hsba greatDetail = {
    100.0/360.0,
    0.42,
    0.37,
    1.0
};

const hsba goodBg = {
    75.0/360.0,
    0.42,
    0.8,
    1.0
};

const hsba goodDetail = {
    75.0/360.0,
    0.42,
    0.37,
    1.0
};

const hsba cautionBg = {
    50.0/360.0,
    0.42,
    0.8,
    1.0
};

const hsba cautionDetail = {
    50.0/360.0,
    0.42,
    0.37,
    1.0
};

const hsba warningBg = {
    25.0/360.0,
    0.42,
    0.8,
    1.0
};

const hsba warningDetail = {
    25.0/360.0,
    0.42,
    0.37,
    1.0
};

const hsba dangerBg = {
    0.0/360.0,
    0.42,
    0.8,
    1.0
};

const hsba dangerDetail = {
    0.0/360.0,
    0.42,
    0.37,
    1.0
};

@implementation DailyTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

// TODO(richard-to): Remove hardcoded stuff
- (void)colorFromStreak:(NSNumber *)streak
{
    UIColor *bgColor = [self hsbaColor:defaultBg];
    UIColor *titleColor = [self hsbaColor:defaultDetail];
    UIColor *detailColor = [self hsbaColor:defaultDetail];
    
    if ([streak intValue] == 1) {
        bgColor = [self hsbaColor:goodBg];
        titleColor = [self hsbaColor:goodDetail];
        detailColor = [self hsbaColor:goodDetail];
    } else if ([streak intValue] == 2) {
        bgColor = [self hsbaColor:greatBg];
        titleColor = [self hsbaColor:greatDetail];
        detailColor = [self hsbaColor:greatDetail];
    } else if ([streak intValue] >= 3) {
        bgColor = [self hsbaColor:awesomeBg];
        titleColor = [self hsbaColor:awesomeDetail];
        detailColor = [self hsbaColor:awesomeDetail];
    } else if ([streak intValue] == -1) {
        bgColor = [self hsbaColor:cautionBg];
        titleColor = [self hsbaColor:cautionDetail];
        detailColor = [self hsbaColor:cautionDetail];
    } else if ([streak intValue] == -2) {
        bgColor = [self hsbaColor:warningBg];
        titleColor = [self hsbaColor:warningDetail];
        detailColor = [self hsbaColor:warningDetail];
    } else if ([streak intValue] <= -3) {
        bgColor = [self hsbaColor:dangerBg];
        titleColor = [self hsbaColor:dangerDetail];
        detailColor = [self hsbaColor:dangerDetail];
    }
    
    self.contentView.backgroundColor = bgColor;
    self.titleLabel.textColor = titleColor;
    self.detailLabel.textColor = detailColor;
}


#pragma mark - Helper methods

- (UIColor *)hsbaColor:(hsba)color
{
    return [UIColor colorWithHue:color.hue saturation:color.saturation brightness:color.brightness alpha: color.alpha];
}
@end
