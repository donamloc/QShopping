//
//  CFinData.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import "CFinData.h"
#import "Constants.h"

@implementation CFinData

@synthesize token, cardList,paymentCode,accountID,amount,totalAmount, sendDay, hourRangeSendDay;

-(id)init
{
    if ((self = [super init]))
    {
        cardList = [[NSMutableArray alloc] initWithCapacity:5];
        paymentCode = @"";
    }
    
    return self;
}

-(BOOL)getMainAccount
{
    BOOL btmpOk = NO;
    // Obtenim la llista de targetes
    [cardList removeAllObjects];
    // {status : <OK,ERROR>, msg : <STRING>, data : cards: [id_card,...]}
    // Fem la crida a la API per la llista de targetes
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@/%@", _BASE_API_URL_, token, _GET_ACCOUNTS_LIST_];
    NSURL *tmpURL = [NSURL URLWithString:stmpURLLogin];
    NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [wsRequest setHTTPMethod:@"GET"];
    [wsRequest setValue:@"application-json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    
    NSLog(@"Abans de la crida al get account list, URL: %@", tmpURL);
    
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:wsRequest returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Crida al account list, retorn: %@", theResponseString);
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
            NSArray *tmpIdArray = [tmpJsonArray objectForKey:@"data"];
            if ([tmpIdArray count] > 0)
            {
                self.accountID = (NSString*)[tmpIdArray objectAtIndex:0];
                NSLog(@"Account ID:%@", accountID);
                btmpOk = YES;
            }
            // else error
        }
        // else ERROR
    }
    // ERROR
    
    return btmpOk;
}

-(TCard*)getCardInformation:(NSString *)a_sIDCard
{
    TCard *tmpRes = nil;
    // Obtenim la informació de la targeta
    // {status : <OK,ERROR>, msg : <STRING>, data : cards: [id_card,...]}
    // Fem la crida a la API per la llista de targetes
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@/%@", _BASE_API_URL_, token, [NSString stringWithFormat:_GET_CARD_INFO_, a_sIDCard]];
    
    NSURL *tmpURL = [NSURL URLWithString:stmpURLLogin];
    NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [wsRequest setHTTPMethod:@"GET"];
    [wsRequest setValue:@"application-json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    
    NSLog(@"Abans de la crida al get card info, URL: %@", tmpURL);
    
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:wsRequest returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Crida al card info, retorn: %@", theResponseString);
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
            NSDictionary *tmpTGDataArray = [tmpJsonArray objectForKey:@"data"];
            if (tmpTGDataArray != nil)
            {
                tmpRes = [[TCard alloc] init];
                tmpRes.ID = (NSString*)[tmpTGDataArray objectForKey:@"id"];
                tmpRes.number = (NSString*)[tmpTGDataArray objectForKey:@"number"];
                tmpRes.mode = (NSString *)[tmpTGDataArray objectForKey:@"mode"]; // enum[CREDIT|DEBIT]
                tmpRes.issuer = (NSString*)[tmpTGDataArray objectForKey:@"issuer"]; // enum[VISA_CLASSIC|VISA_GOLD|AMEX]
                NSLog(@"Afegida la tarja ID: %@ de l'issuer %@", tmpRes.ID, tmpRes.issuer);
            }
            // else ERROR
        }
        // else ERROR
    }
    // ERROR
    
    return tmpRes;
}

-(BOOL)getCards
{
    BOOL btmpOk = NO;
    // Obtenim la llista de targetes
    [cardList removeAllObjects];
    // {status : <OK,ERROR>, msg : <STRING>, data : cards: [id_card,...]}
    // Fem la crida a la API per la llista de targetes
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@/%@", _BASE_API_URL_, token, _GET_CARD_LIST_];
    NSURL *tmpURL = [NSURL URLWithString:stmpURLLogin];
    NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [wsRequest setHTTPMethod:@"GET"];
    [wsRequest setValue:@"application-json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    
    NSLog(@"Abans de la crida al get card list, URL: %@", tmpURL);
    
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:wsRequest returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Crida al card list, retorn: %@", theResponseString);
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
            NSArray *tmpIdArray = [tmpJsonArray objectForKey:@"data"];
            NSEnumerator *enumerator = [tmpIdArray objectEnumerator];
            NSString *stmpIDCard;
            while (stmpIDCard = (NSString*)[enumerator nextObject]) 
            {
                TCard *tmpCard = [self getCardInformation:stmpIDCard];
                if (tmpCard != nil)
                {
                    [cardList addObject:tmpCard];
                    btmpOk = YES;
                }
                // else ERROR
            }
        }
        // else ERROR
    }
    // ERROR
    
    return btmpOk;
}

-(NSString *)getIDCardByIndex:(int)a_iIndex
{
    NSString *stmpCardID = @"";
    if (a_iIndex < [cardList count])
    {
        TCard *tmpCard = [cardList objectAtIndex:a_iIndex];
        if (tmpCard != nil)
            stmpCardID = tmpCard.ID;
    }
    
    return stmpCardID;
}

@end
