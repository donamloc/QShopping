//
//  ConfigurationViewController.h
//  Qshopping
//
//  Created by Josep Oncins on 27/10/12.
//  LGPL Dona'm l'oc. 
//

#import <UIKit/UIKit.h>

@protocol ConfigVCDelegate;

@interface ConfigurationViewController : UIViewController
{
    id<ConfigVCDelegate> delegate;
}

-(IBAction)onTap:(id)sender;

@property (nonatomic, assign) id<ConfigVCDelegate> delegate;
@end

@protocol ConfigVCDelegate

-(void)ExitConfig:(id)sender;

@end

