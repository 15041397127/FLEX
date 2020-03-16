//
//  FLEXNetworkSettingsTableViewController.m
//  FLEXInjected
//
//  Created by Ryan Olson on 2/20/15.
//
//

#import "FLEXNetworkSettingsTableViewController.h"
#import "FLEXNetworkObserver.h"
#import "FLEXNetworkRecorder.h"
#import "FLEXUtility.h"

@interface FLEXNetworkSettingsTableViewController () <UIActionSheetDelegate>

@property (nonatomic, copy) NSArray<UITableViewCell *> *cells;

@property (nonatomic) UITableViewCell *cacheLimitCell;

@end

@implementation FLEXNetworkSettingsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray<UITableViewCell *> *mutableCells = [NSMutableArray new];

    UITableViewCell *networkDebuggingCell = [self switchCellWithTitle:@"Network Debugging" toggleAction:@selector(networkDebuggingToggled:) isOn:FLEXNetworkObserver.isEnabled];
    [mutableCells addObject:networkDebuggingCell];

    UITableViewCell *cacheMediaResponsesCell = [self switchCellWithTitle:@"Cache Media Responses" toggleAction:@selector(cacheMediaResponsesToggled:) isOn:NO];
    [mutableCells addObject:cacheMediaResponsesCell];

    NSUInteger currentCacheLimit = [FLEXNetworkRecorder.defaultRecorder responseCacheByteLimit];
    const NSUInteger fiftyMega = 50 * 1024 * 1024;
    NSString *cacheLimitTitle = [self titleForCacheLimitCellWithValue:currentCacheLimit];
    self.cacheLimitCell = [self sliderCellWithTitle:cacheLimitTitle changedAction:@selector(cacheLimitAdjusted:) minimum:0.0 maximum:fiftyMega initialValue:currentCacheLimit];
    [mutableCells addObject:self.cacheLimitCell];

    self.cells = mutableCells;
}


#pragma mark - Settings Actions

- (void)networkDebuggingToggled:(UISwitch *)sender {
    [FLEXNetworkObserver setEnabled:sender.isOn];
}

- (void)cacheMediaResponsesToggled:(UISwitch *)sender {
    [FLEXNetworkRecorder.defaultRecorder setShouldCacheMediaResponses:sender.isOn];
}

- (void)cacheLimitAdjusted:(UISlider *)sender {
    [FLEXNetworkRecorder.defaultRecorder setResponseCacheByteLimit:sender.value];
    self.cacheLimitCell.textLabel.text = [self titleForCacheLimitCellWithValue:sender.value];
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return self.cells[indexPath.row];
}


#pragma mark - Helpers

- (UITableViewCell *)switchCellWithTitle:(NSString *)title toggleAction:(SEL)toggleAction isOn:(BOOL)isOn {
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = title;
    cell.textLabel.font = [[self class] cellTitleFont];

    UISwitch *theSwitch = [UISwitch new];
    theSwitch.on = isOn;
    [theSwitch addTarget:self action:toggleAction forControlEvents:UIControlEventValueChanged];

    CGFloat switchOriginY = round((cell.contentView.frame.size.height - theSwitch.frame.size.height) / 2.0);
    CGFloat switchOriginX = CGRectGetMaxX(cell.contentView.frame) - theSwitch.frame.size.width - self.tableView.separatorInset.left;
    theSwitch.frame = CGRectMake(switchOriginX, switchOriginY, theSwitch.frame.size.width, theSwitch.frame.size.height);
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [cell.contentView addSubview:theSwitch];

    return cell;
}

- (NSString *)titleForCacheLimitCellWithValue:(long long)cacheLimit {
    NSInteger limitInMB = round(cacheLimit / (1024 * 1024));
    return [NSString stringWithFormat:@"Cache Limit (%ld MB)", (long)limitInMB];
}

- (UITableViewCell *)sliderCellWithTitle:(NSString *)title changedAction:(SEL)changedAction minimum:(CGFloat)minimum maximum:(CGFloat)maximum initialValue:(CGFloat)initialValue {
    UITableViewCell *sliderCell = [UITableViewCell new];
    sliderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    sliderCell.textLabel.text = title;
    sliderCell.textLabel.font = [[self class] cellTitleFont];

    UISlider *slider = [UISlider new];
    slider.minimumValue = minimum;
    slider.maximumValue = maximum;
    slider.value = initialValue;
    [slider addTarget:self action:changedAction forControlEvents:UIControlEventValueChanged];
    [slider sizeToFit];

    CGFloat sliderWidth = round(sliderCell.contentView.frame.size.width * 2.0 / 5.0);
    CGFloat sliderOriginY = round((sliderCell.contentView.frame.size.height - slider.frame.size.height) / 2.0);
    CGFloat sliderOriginX = CGRectGetMaxX(sliderCell.contentView.frame) - sliderWidth - self.tableView.separatorInset.left;
    slider.frame = CGRectMake(sliderOriginX, sliderOriginY, sliderWidth, slider.frame.size.height);
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [sliderCell.contentView addSubview:slider];

    return sliderCell;
}

+ (UIFont *)cellTitleFont {
    return [UIFont systemFontOfSize:14.0];
}

@end
