//
//  CardInfoViewController.h
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPCard.h"

@protocol EPCardInfoViewControllerDelegate <NSObject>

- (void)cardInfoViewController:(UIViewController *)controller didEnterInfoForCard:(EPCard *)card;

@end

@interface EPCardInfoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <EPCardInfoViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *cvc;
@property (weak, nonatomic) IBOutlet UITextField *expiration;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
