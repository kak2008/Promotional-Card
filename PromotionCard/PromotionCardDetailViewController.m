//
//  PromotionCardViewController2.m
//  PromotionCard
//
//  Created by Home on 2/5/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import "PromotionCardDetailViewController.h"
#import "PCWebViewController.h"
#import "Promotion.h"

typedef NS_ENUM(NSUInteger, PromotionDetail) {
    PromotionDetailTitle    = 0,
    PromotionDetailDesc     = 1,
    PromotionDetailButton   = 2
};

@interface PromotionCardDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableview;
@property (nonatomic, strong) UIActivityIndicatorView *imageActivityIndicator;

@property (nonatomic, strong) NSURL *selectedURL;

@end

@implementation PromotionCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _promotion.title;
    
    self.detailTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableview.backgroundColor = [UIColor clearColor];

    [self setupHeader];
    [self setupFooter];
}

- (void)setupHeader {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:kImageNotAvailable];
    self.detailTableview.tableHeaderView = imageview;
    
    [Utilities downloadImageFromURL:_promotion.image
                withCompletionBlock:^(NSData *imageData) {
                    if (!imageData) {
                        return;
                    }
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageview.image = image;
                    });
                }];
}

- (void)setupFooter {
    if (![Utilities isValidString:self.promotion.footer]) {
        return;
    }
    
    CGRect frame = self.detailTableview.frame;
    frame.size.height = 60;
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:frame];
    webview.delegate = self;
    [webview loadHTMLString:self.promotion.footer baseURL:nil];
    [webview setContentMode:UIViewContentModeCenter];
    
    self.detailTableview.tableFooterView = webview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section != PromotionDetailDesc) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        
        if (indexPath.section == PromotionDetailButton) {
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.75];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    cell.textLabel.text = [self cellTextForIndex:indexPath];
    return cell;
}

#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != PromotionDetailButton) {
        return;
    }
    
    NSString *urlStr = [self.promotion.button objectForKey:@"target"];
    [self goToWebViewWithURL:[NSURL URLWithString:urlStr]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIWebview Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self goToWebViewWithURL:request.URL];
        return NO;
    }
    
    return YES;
}

#pragma mark - Other Methods

- (NSString *)cellTextForIndex:(NSIndexPath *)indexPath {
    if (indexPath.section == PromotionDetailTitle) {
        return _promotion.title;
    }
    else if (indexPath.section == PromotionDetailDesc) {
        return _promotion.promotionDescription;
    }
    else if (indexPath.section == PromotionDetailButton) {
        return [[_promotion.button objectForKey:@"title"] uppercaseString];
    }
    
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == PromotionDetailDesc)? @"Description": @"";
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.detailTableview reloadData];
}

- (void)goToWebViewWithURL:(NSURL *)url {
    self.selectedURL = url;
    [self performSegueWithIdentifier:kSegueIdentifierPromotionDetailToWebView sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PCWebViewController *webViewController = (PCWebViewController *)[segue destinationViewController];
    webViewController.url = self.selectedURL;
}

@end
