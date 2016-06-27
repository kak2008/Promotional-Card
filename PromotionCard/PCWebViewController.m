//
//  PCWebViewController.m
//  PromotionCard
//
//  Created by Home on 2/5/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import "PCWebViewController.h"

@interface PCWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation PCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.hidden = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20];
    [self.webview loadRequest:request];
    [self.activityIndicator setColor:kAppThemeColor];
    [self.infoLabel setTextColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoLabel.hidden = NO;
        self.infoLabel.text = NSLocalizedString(@"Failed to retrieve promotions", nil);
    });
}

@end
