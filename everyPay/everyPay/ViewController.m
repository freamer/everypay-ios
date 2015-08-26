//
//  ViewController.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "ViewController.h"
#import "EPApi.h"

#import "NSDate+Additions.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)getMerchantInfoWithCard:(EPCard *)card {
    [self appendProgressLog:@"Get API credentials from merchant..."];
    [EPMerchantApi getMerchantDataWithSuccess:^(NSDictionary *dictionary) {
        [self appendProgressLog:@"Done"];
        [self sendCardCredentialsToEPWithMerchantInfo:dictionary andCard:card];
    } andError:^(NSError *error) {
        [self showAlertWithError:error];
    }];
}

- (void)sendCardCredentialsToEPWithMerchantInfo:(NSDictionary *)merchantInfo andCard:(EPCard *)card {
    [self appendProgressLog:@"Save card details with EvertPay API..."];
    [EPApi sendCard:card withMerchantInfo:merchantInfo withSuccess:^(NSString *token) {
        [self appendProgressLog:@"Done"];
        [self payWithToken:token andMerchantInfo:merchantInfo];
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

- (void)showAlertWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

- (void)appendProgressLog:(NSString *)log {
    NSString *stringToAppend = [NSString stringWithFormat:@"\n%@", log];
    [self.textView setText:[self.textView.text stringByAppendingString:stringToAppend]];
}

#pragma mark - CardInfoViewControllerDelegate
- (void)cardInfoViewController:(UIViewController *)controller didEnterInfoForCard:(EPCard *)card {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self getMerchantInfoWithCard:card];
}

- (IBAction)restartTapped:(id)sender {
    EPCardInfoViewController *cardInfoViewController = [[EPCardInfoViewController alloc] initWithNibName:NSStringFromClass([EPCardInfoViewController class]) bundle:nil];
    [cardInfoViewController setDelegate:self];
    [self presentViewController:cardInfoViewController animated:YES completion:nil];
    [self appendProgressLog:@"\n"];
}

@end
