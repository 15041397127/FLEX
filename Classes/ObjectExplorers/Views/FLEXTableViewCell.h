//
//  FLEXTableViewCell.h
//  FLEX
//
//  Created by Tanner on 4/17/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLEXTableViewCell : UITableViewCell

/// Use this instead of .textLabel
@property (nonatomic, readonly) UILabel *titleLabel;
/// Use this instead of .detailTextLabel
@property (nonatomic, readonly) UILabel *subtitleLabel;

@end
