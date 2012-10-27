//
//  WaitForPayment.m
//  Qshopping
//
//  Created by Josep Oncins on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaitForPayment.h"
#import "Constants.h"

@implementation WaitForPayment
@synthesize delegate, finData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        queryTimer = nil;
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
    [self start];
}

-(void)queryPayment:(NSTimer *)timer
{
    if (queryTimer != nil)
    {
        [queryTimer invalidate];
        queryTimer = nil;
    }
    
    //EXECUTEM LA COMPRA
    BOOL btmpAcabada = NO;
    // Fem la crida a la API 
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@/%@", _BASE_API_URL_, finData.token, 
                              [NSString stringWithFormat:_QUERY_PAYMENT_, finData.paymentCode]];
    
    NSURL *tmpURL = [NSURL URLWithString:stmpURLLogin];
    NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [wsRequest setHTTPMethod:@"GET"];
    [wsRequest setValue:@"application-json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    
    NSLog(@"Abans de la crida al pagament, URL: %@", tmpURL);
    
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:wsRequest returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Crida al pagament, retorn: %@", theResponseString);
    if (theError != NULL)
        NSLog(@"Error cridant el ws: %@", theError.localizedDescription);
    
    NSError *tmpJSONError = nil;
    NSDictionary *tmpJsonArray = nil;
    
    if (theResponseData != nil)
        tmpJsonArray = [NSJSONSerialization JSONObjectWithData:theResponseData options:NSJSONReadingMutableContainers error:&tmpJSONError];
    if (tmpJsonArray)
    {
        NSString *stmpToken = [tmpJsonArray objectForKey:@"status"];
        if ([stmpToken compare:@"OK"] == NSOrderedSame)
        {
            NSDictionary *tmpIdArray = (NSDictionary*)[tmpJsonArray objectForKey:@"data"];
            if (tmpIdArray != nil)
            {
                // Mirem si ha acabat
                NSString *stmpStatus = [tmpIdArray objectForKey:@"status"];
                if ([stmpStatus compare:@"OPEN"] != NSOrderedSame)
                {
                    // Ja podem tancar la finestra
                    btmpAcabada = YES;
                    [delegate BuyExecuted:self];
                }
            }
            // else ERROR
        }
        else
        {
            //NSString *stmpError = [NSString stringWithFormat:@"Error executant la compra: %@", [tmpJsonArray objectForKey:@"msg"]];
        }
    }
    // ERROR
    if (!btmpAcabada)
        queryTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(queryPayment:) userInfo:nil repeats:NO];
}

-(void)executeCommercePayment
{
    //EXECUTEM LA COMPRA
    BOOL btmpOk = NO;
    // Fem la crida a la API 
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@/%@", _BASE_API_URL_, finData.token, 
                              [NSString stringWithFormat:_EXECUTE_COMMERCE_PAYMENT_, finData.paymentCode]];
    
    NSURL *tmpURL = [NSURL URLWithString:stmpURLLogin];
    NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [wsRequest setHTTPMethod:@"POST"];
    [wsRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSString *tmpBody = [NSString stringWithFormat:@"{\"idAccount\":\"%@\"}", finData.accountID];
    NSData *theBodyData = [tmpBody dataUsingEncoding:NSUTF8StringEncoding];
    [wsRequest setHTTPBody:theBodyData];  

    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    
    NSLog(@"Abans de la crida al pagament, URL: %@ Body: %@", tmpURL, tmpBody);
    
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:wsRequest returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Crida al pagament, retorn: %@", theResponseString);
    if (theError != NULL)
        NSLog(@"Error cridant el ws: %@", theError.localizedDescription);
    
    NSError *tmpJSONError = nil;
    NSDictionary *tmpJsonArray = nil;
    
    if (theResponseData != nil)
        tmpJsonArray = [NSJSONSerialization JSONObjectWithData:theResponseData options:NSJSONReadingMutableContainers error:&tmpJSONError];
    if (tmpJsonArray)
    {
        NSString *stmpToken = [tmpJsonArray objectForKey:@"status"];
        if ([stmpToken compare:@"OK"] == NSOrderedSame)
        {
            NSDictionary *tmpIdArray = (NSDictionary*)[tmpJsonArray objectForKey:@"data"];
            if (tmpIdArray != nil)
            {
                // Mirem si ha acabat
                /*
                NSString *stmpStatus = [tmpIdArray objectForKey:@"status"];
                if ([stmpStatus compare:@"OPEN"] != NSOrderedSame)
                {
                    // Ja podem tancar la finestra
                    [delegate BuyExecuted:self];
                }
                else
                    queryTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(queryPayment:) userInfo:nil repeats:NO];
                */
                btmpOk = YES;
            }
            // else ERROR
        }
        else
        {
            //NSString *stmpError = [NSString stringWithFormat:@"Error executant la compra: %@", [tmpJsonArray objectForKey:@"msg"]];
        }
    }
    // ERROR
    if (!btmpOk)
        [delegate BuyExecuted:self];
}

-(void)start
{
    // Fem la query cada 0.5 segons
    queryTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(queryPayment:) userInfo:nil repeats:NO];
    // Executem el pagament del negoci
    [self executeCommercePayment];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (queryTimer != nil)
    {
        [queryTimer invalidate];
        queryTimer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
