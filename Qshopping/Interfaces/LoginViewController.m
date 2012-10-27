//
//  LoginViewController.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "CUtils.h"

@implementation LoginViewController

@synthesize username, password, delegate;

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

#pragma mark - Interacció amb els botons

-(IBAction)onOk:(id)sender
{
    // Fem la crida a la API pel login
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@", _BASE_API_URL_, _LOGIN_];
    NSURL *tmpURL = [NSURL URLWithString:stmpURLLogin];
    NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [wsRequest setHTTPMethod:@"GET"];
    [wsRequest setValue:@"application-json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username.text, password.text];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [CUtils encodeBase64WithString:authStr]];
    [wsRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Usuari crida login: %@ B64(%@)", authStr, authValue);
    
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;

    NSLog(@"Abans de la crida al login, URL: %@", tmpURL);

    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:wsRequest returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Crida al login, retorn: %@", theResponseString);
    if (theError != NULL)
        NSLog(@"Error cridant el ws: %@", theError.localizedDescription);
    
    NSError *tmpJSONError = nil;
    NSDictionary *tmpJsonArray = nil;
    
    if (theResponseData != nil)
        tmpJsonArray = [NSJSONSerialization JSONObjectWithData:theResponseData options:NSJSONReadingMutableContainers error:&tmpJSONError];
    
    if (tmpJsonArray)
    {
        NSString *stmpToken = [tmpJsonArray objectForKey:@"token"];
        if (stmpToken == nil)
            [delegate LoginFailed:self msg:[tmpJsonArray objectForKey:@"msg"]];
        else
            [delegate LoginOk:self token:stmpToken];
    }
    else
        [delegate LoginFailed:self msg:@"Error fent login"];
}

-(IBAction)onCancel:(id)sender
{
    [delegate LoginFailed:self msg:@"Login cancel·lat per l'usuari"];
}

@end
