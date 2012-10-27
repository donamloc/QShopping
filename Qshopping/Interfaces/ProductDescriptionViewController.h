//
//  ProductDescriptionViewController.h
//  Qshopping
//
//  Created by Josep Oncins on 27/10/12.
//  LGPL Dona'm l'oc. 
//

#import <UIKit/UIKit.h>
@protocol ProdDescVCDelegate;

@interface ProductDescriptionViewController : UIViewController
{
    id<ProdDescVCDelegate> delegate;
    UIImage *theImage;
    IBOutlet UIButton* theButton;
}

@property (nonatomic, assign) id<ProdDescVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIButton* theButton;
@property (nonatomic, retain) UIImage *theImage;

-(IBAction)onTap:(id)sender;

@end

@protocol ProdDescVCDelegate

-(void)ExitProdDesc:(id)sender;

@end


