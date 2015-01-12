//
//  WebViewViewController.m
//  TicTacToe
//
//  Created by Evan Vandenberg on 1/12/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "WebViewViewController.h"
#import "RootViewController.h"
#import "AgainstCPUViewController.h"

@interface WebViewViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadNewWebPage:@"http://boardgames.about.com/od/paperpencil/a/tic_tac_toe.htm"];
}

//Essentially this method is manually turning a textfield into a search bar
- (void)loadNewWebPage:(NSString *)string
{
    NSString *addressString = string;
    NSURL *adddressURL = [NSURL URLWithString:addressString];
    NSURLRequest *addressRequest = [NSURLRequest requestWithURL:adddressURL];
    [self.webView loadRequest:addressRequest];
}



@end
