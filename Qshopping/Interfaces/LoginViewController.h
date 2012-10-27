//
//  LoginViewController.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate;

@interface LoginViewController : UIViewController
{
    id<LoginDelegate> delegate;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UILabel *amountLabel;
}

@property(nonatomic, assign) id<LoginDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITextField *username;
@property (nonatomic, assign) IBOutlet UITextField *password;
@property(nonatomic, assign) IBOutlet UILabel *amountLabel;

-(void)setTotalAmount:(double)a_dTotal;

-(IBAction)onOk:(id)sender;
-(IBAction)onCancel:(id)sender;

@end

@protocol LoginDelegate

-(void)LoginOk:(id)sender token:(NSString *)a_stoken;
-(void)LoginFailed:(id)sender msg:(NSString*)a_sMessage;

@end
