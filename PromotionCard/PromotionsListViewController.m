//
//  ViewController.m
//  PromotionCard
//
//  Created by Home on 2/4/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import "PromotionsListViewController.h"
#import "PromotionCardDetailViewController.h"
#import "Promotion.h"

static CGFloat cellHeight = 80;

@interface PromotionsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *promotionsTableView;

@property (nonatomic, strong) NSMutableArray *promotionDetails;

@end

@implementation PromotionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.promotionsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.promotionDetails = [NSMutableArray new];
    self.title = NSLocalizedString(@"Title text promotions screen", nil);
    
    [self.navigationController.navigationBar setBarTintColor:kAppThemeColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self createRequestToFetchPromotionDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(UIImage *)image toCell:(UITableViewCell *)cell {
    CGFloat thumbernailSide = cellHeight - 20;
    cell.imageView.image = [Utilities resizeImage:image toSize:CGSizeMake(thumbernailSide, thumbernailSide)];
    
    CALayer *cellImageLayer = cell.imageView.layer;
    [cellImageLayer setCornerRadius:thumbernailSide/2];
    [cellImageLayer setMasksToBounds:YES];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _promotionDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionListCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PromotionListCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Promotion *promotion = [_promotionDetails objectAtIndex:indexPath.row];
    cell.textLabel.text = promotion.title;

    [self setImage:kImageNotAvailable toCell:cell];
    
    [Utilities downloadImageFromURL:promotion.image
                withCompletionBlock:^(NSData *imageData) {
                    
                    if (!imageData) {
                        return;
                    }
                    
                    UIImage *imageThumbernail = [UIImage imageWithData:imageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setImage:imageThumbernail toCell:cell];
                    });
                }];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueIdentifierPromotionsToDetailView sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

#pragma mark - Network Calls

- (void)displayNoDataView {
    UIView *errorView = [[UIView alloc] initWithFrame:_promotionsTableView.frame];
    CGRect frame = errorView.frame;
    frame.origin.x = frame.size.width * 0.1;
    frame.size.width = frame.size.width * 0.8;
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.font = [UIFont italicSystemFontOfSize:14];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        label.text = NSLocalizedString(@"Failed to retrieve promotions", nil);
        [errorView addSubview:label];
        _promotionsTableView.tableHeaderView = errorView;
    });
}

- (void)createRequestToFetchPromotionDetails {
    [DataManager GETDataFromURL:[NSURL URLWithString:kURLStringForPromotionsData]
              completionHandler:^(NSData *data) {
                  if (!data) {
                      [self displayNoDataView];
                      return;
                  }
                  
                  [self onPromotionDetailsReceived:[Utilities dictionaryFromNSData:data]];
              }];
}

- (void)onPromotionDetailsReceived:(NSDictionary *)promotionDetails {
    NSArray *promotionDetailsArray = [promotionDetails objectForKey:@"promotions"];
    if (!promotionDetailsArray || promotionDetailsArray.count == 0) {
        return;
    }
    
    for (NSDictionary *promotionDetailJson in promotionDetailsArray) {
        Promotion *promotion = [[Promotion alloc] initWithPromotionDetails:promotionDetailJson];
        if (!promotion) {
            continue; // Invalid promotion details
        }
        
        [self.promotionDetails addObject:promotion];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_promotionsTableView reloadData];
    });
}

#pragma mark - Other Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueIdentifierPromotionsToDetailView]) {
        PromotionCardDetailViewController *detailVC = (PromotionCardDetailViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = _promotionsTableView.indexPathForSelectedRow;
        detailVC.promotion = _promotionDetails[selectedIndexPath.row];
        return;
    }
    
    // All Others
}

@end
