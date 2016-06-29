//
//  ViewController.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "ViewController.h"
#import "EPApi.h"
#import "Constants.h"

#import "NSDate+Additions.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *apiVersion;
@property (nonatomic, copy) NSDictionary *merchantInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setApiVersion:@"2"];
}


- (void)getMerchantInfoWithCard:(EPCard *)card {
    [self appendProgressLog:@"Get API credentials from merchant..."];
    [EPMerchantApi getMerchantDataWithSuccess:^(NSDictionary *dictionary) {
        [self appendProgressLog:@"Done"];
        [self setMerchantInfo:dictionary];
        [self sendCardCredentialsToEPWithMerchantInfo:dictionary andCard:card];
    } andError:^(NSError *error) {
        [self showAlertWithError:error];
    } apiVersion:self.apiVersion];
}

- (void)sendCardCredentialsToEPWithMerchantInfo:(NSDictionary *)merchantInfo andCard:(EPCard *)card {
    [self appendProgressLog:@"Save card details with EvertPay API..."];
    [EPApi sendCard:card withMerchantInfo:merchantInfo withSuccess:^(NSDictionary *responseDictionary) {
        NSString *paymentState = [responseDictionary objectForKey:kPaymentState];
        if([paymentState isEqualToString:kPaymentStateAuthorised]){
            NSString *token = [responseDictionary objectForKey:kKeyEncryptedToken];
            [self appendProgressLog:@"Done"];
            [self payWithToken:token andMerchantInfo:merchantInfo];
        } else if ([paymentState isEqualToString:kPaymentStateWaiting3DsResponse]) {
            [self appendProgressLog:@"Done"];
            NSString *paymentReference = [responseDictionary objectForKey:kKeyPaymentReference];
            NSString *secureCodeOne = [responseDictionary objectForKey:kKeySecureCodeOne];
            NSString *hmac = [merchantInfo objectForKey:kKeyHmac];
            [self appendProgressLog:@"Starting 3DS authentication..."];
            [self startWebViewWithPaymentReference:paymentReference secureCodeOne:secureCodeOne hmac:hmac];
        }
    } andError:^(NSArray *errors) {
        [self showAlertWithError:[errors firstObject]];
    }];
}

- (void)payWithToken:(NSString *)token andMerchantInfo:(NSDictionary *)merchantInfo {
    [self appendProgressLog:@"Send card token to merchant server..."];

    [EPMerchantApi sendPaymentWithToken:token andMerchantInfo:merchantInfo withSuccess:^(NSDictionary *dictionary) {
        [self appendProgressLog:@"All done"];
    } andError:^(NSError *error) {
        [self showAlertWithError:error];
    }];
}

- (void)startWebViewWithPaymentReference:(NSString *)paymentReference secureCodeOne:(NSString *)secureCodeOne hmac:(NSString *)hmac {
    PaymentWebViewController *paymentWebView = [[PaymentWebViewController alloc] initWithNibName:NSStringFromClass([PaymentWebViewController class]) bundle:nil];
    [paymentWebView setDelegate:self];
    [paymentWebView addURLParametersWithPaymentReference:paymentReference secureCodeOne:secureCodeOne hmac:hmac];
    [self.navigationController pushViewController:paymentWebView animated:YES];
}
- (void)showAlertWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
    [self appendProgressLog:@"Failed"];
}

- (void)appendProgressLog:(NSString *)log {
    NSString *stringToAppend = [NSString stringWithFormat:@"\n%@", log];
    [self.textView setText:[self.textView.text stringByAppendingString:stringToAppend]];
}

#pragma mark - CardInfoViewControllerDelegate
- (void)cardInfoViewController:(UIViewController *)controller didEnterInfoForCard:(EPCard *)card {
    [self.navigationController popViewControllerAnimated:YES];
    [self getMerchantInfoWithCard:card];
}

- (IBAction)restartTapped:(id)sender {
    [self.textView setText:@""];
    EPCardInfoViewController *cardInfoViewController = [[EPCardInfoViewController alloc] initWithNibName:NSStringFromClass([EPCardInfoViewController class]) bundle:nil];
    [cardInfoViewController setDelegate:self];
    [self.navigationController pushViewController:cardInfoViewController animated:YES];
    cardInfoViewController.edgesForExtendedLayout = UIRectEdgeNone;
    [self appendProgressLog:@"\n"];
}

- (void)paymentCanceled {
    [self showAlertWithError:[NSError errorWithDomain:@"3Ds authentication canceled" code:1000 userInfo:nil]];
}
- (void)paymentFailedWithErrorCode:(NSInteger)errorCode {
    NSLog(@"payment Failed with code %ld", (long)errorCode);
    [self showAlertWithError:[NSError errorWithDomain:@"3Ds authentication failed" code:errorCode userInfo:nil]];
}

- (void)paymentSucceededWithPayentReference:(NSString *)paymentReference hmac:(NSString *)hmac {
    NSLog(@"payment succeeded with reference %@", paymentReference);
    [self appendProgressLog:@"Done"];
    [self appendProgressLog:@"Confirming 3DS with Everypay server ...."];
    [EPApi encryptedPaymentInstrumentsConfirmedWithPaymentReference:paymentReference hmac:hmac apiVersion:_apiVersion withSuccess:^(NSDictionary *dictionary) {
        NSString *token = [dictionary objectForKey:kKeyEncryptedToken];
        [self appendProgressLog:@"Done"];
        [self payWithToken:token andMerchantInfo:_merchantInfo];
    } andError:^(NSArray *array) {
        
    }];
}

@end
