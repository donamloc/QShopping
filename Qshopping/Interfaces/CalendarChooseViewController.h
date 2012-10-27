//
//  CalendarChooseViewController.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import <UIKit/UIKit.h>

@protocol CalendarChooseVC;

@interface CalendarChooseViewController : UIViewController
{
    id<CalendarChooseVC> delegate;
    NSString *choosenDate;
    NSRange hourRange;
}

@property(nonatomic, assign) id<CalendarChooseVC> delegate;
@property(nonatomic, retain) NSString *choosenDate;
@property(nonatomic, assign) NSRange hourRange;

-(IBAction)onTapDay:(id)sender;

@end

@protocol CalendarChooseVC

-(void)ChoosedOk:(id)sender date:(NSString*)a_date hourRange:(NSRange)a_hourRange;
-(void)ChoosedCanceled:(id)sender;

@end