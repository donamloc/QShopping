//
//  CalendarChooseViewController.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import "CalendarChooseViewController.h"

@implementation CalendarChooseViewController
@synthesize delegate, choosenDate, hourRange;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)showConfirmation
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviament de la comanda" message:@"Rebreu la vostra comanda\rDimarts 21/10/2012\rentre les 16h-18h"
                                              delegate:self 
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Sí",nil];
	alert.tag = 10;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 0)
            [delegate ChoosedCanceled:self];
        else
            [delegate ChoosedOk:self date:choosenDate hourRange:hourRange];
    }
}

-(IBAction)onTapDay:(id)sender
{
    choosenDate = @"2012/10/21";
    
    hourRange.location = 16;
    hourRange.length = 2;
    [self showConfirmation];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
