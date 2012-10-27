//
//  WaitForPayment.h
//  Qshopping
//
//  Created by Josep Oncins on 27/10/12.
//  LGPL Dona'm l'oc. 
//

#import <UIKit/UIKit.h>
#import "CFinData.h"

@protocol WaitForPaymentDelegate;

@interface WaitForPayment : UIViewController
{
    id<WaitForPaymentDelegate> delegate;
    CFinData *finData;
    NSTimer *queryTimer;
}

@property (nonatomic, assign) id<WaitForPaymentDelegate> delegate;
@property (nonatomic, retain) CFinData *finData;

// Comença l'espera
-(void)start;

@end

@protocol WaitForPaymentDelegate

-(void)BuyExecuted:(id)sender;

@end
