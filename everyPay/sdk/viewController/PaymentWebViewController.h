//
//  PaymentWebViewController.h
//  everyPay
//
//  Created by Olev Abel on 6/28/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PaymentWebViewControllerDelegate
- (void)paymentSucceededWithPayentReference:(NSString *)paymentReference hmac:(NSString *)hmac;
- (void)paymentFailedWithErrorCode:(NSInteger)errorCode;
- (void)paymentCanceled;
@end

@interface PaymentWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, assign) id <PaymentWebViewControllerDelegate> delegate;

- (void)addURLParametersWithPaymentReference:(NSString *)paymentReference secureCodeOne:(NSString *)secureCodeOne hmac:(NSString *)hmac;
@end
