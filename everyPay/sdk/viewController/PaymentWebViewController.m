//
//  PaymentWebViewController.m
//  everyPay
//
//  Created by Olev Abel on 6/28/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "PaymentWebViewController.h"
#import "Constants.h"

@interface PaymentWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *paymentReference;
@property (nonatomic) BOOL *isBrowserFlowEndUrlReached;
@property (nonatomic, copy) NSString *secureCodeOne;
@property (nonatomic, copy) NSString *hmac;

@end

@implementation PaymentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"3Ds authentication"];
    NSURL *url = [self buildInitURLForWebViewWithPaymentReference:_paymentReference secureCodeOne:_secureCodeOne hmac:_hmac];
    NSLog(@"webView URL %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView setDelegate:self];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSURL *)buildInitURLForWebViewWithPaymentReference:(NSString *)paymentReference secureCodeOne:(NSString *)secureCodeOne hmac:(NSString *)hmac {
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:@"https"];
    [components setHost:@"gw-staging.every-pay.com"];
    [components setPath:@"/authentication3ds/new"];
    NSURLQueryItem *paymentRef = [NSURLQueryItem queryItemWithName:kKeyPaymentReference value:paymentReference];
    NSURLQueryItem *secureCode = [NSURLQueryItem queryItemWithName:kKeySecureCodeOne value:secureCodeOne];
    NSURLQueryItem *mobile3DsHmac = [NSURLQueryItem queryItemWithName:kParamHmac value:hmac];
    [components setQueryItems:@[paymentRef, secureCode, mobile3DsHmac]];
    return [components URL];
}
- (void)addURLParametersWithPaymentReference:(NSString *)paymentReference secureCodeOne:(NSString *)secureCodeOne hmac:(NSString *)hmac {
    [self setPaymentReference:paymentReference];
    [self setSecureCodeOne:secureCodeOne];
    [self setHmac:hmac];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = request.URL.absoluteString;
    
    NSLog(@"url: %@, scheme: %@, relativePath: %@, relativeString: %@", request.URL.absoluteString, request.URL.scheme, request.URL.relativePath, request.URL.relativeString);
    if([self isBrowserFlowEndUrlWithUrlString:urlString]){
        [self setIsBrowserFlowEndUrlReached:YES];
        if ([self isBrowerFlowSuccessfulWithUrlString:urlString]) {
            NSString *urlWithoutPrefix = [urlString stringByReplacingOccurrencesOfString:kBrowserFlowEndURLPrefix withString:@""];
            NSString *paymentReference = [urlWithoutPrefix componentsSeparatedByString:@"?"][0];
            if (self.delegate) {
                [self.delegate paymentSucceededWithPayentReference:paymentReference hmac:_hmac];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSInteger errorCode = 999;
            if (self.delegate) {
                [self.delegate paymentFailedWithErrorCode:errorCode];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    return YES;
}

- (BOOL)isBrowserFlowEndUrlWithUrlString:(NSString *)urlString {
    return [urlString containsString:kPaymentState];
}

- (BOOL)isBrowerFlowSuccessfulWithUrlString:(NSString *)urlString {
   return [urlString hasPrefix:kBrowserFlowEndURLPrefix] && [urlString containsString:kPaymentStateAuthorised];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if(![parent isEqual:self.parentViewController]) {
        NSLog(@"Back pressed");
        if(!self.isBrowserFlowEndUrlReached) {
            [self.delegate paymentCanceled];
        }
    }
}
@end
