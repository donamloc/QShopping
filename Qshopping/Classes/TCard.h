//
//  TCard.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCard : NSObject
{
    NSString *ID;
    NSString *number;
    NSString* mode; // enum[CREDIT|DEBIT]
    NSString* issuer; // enum[VISA_CLASSIC|VISA_GOLD|AMEX]
}

@property(nonatomic,retain) NSString *ID;
@property(nonatomic,retain) NSString *number;
@property(nonatomic,retain) NSString* mode; // enum[CREDIT|DEBIT]
@property(nonatomic,retain) NSString* issuer; // enum[VISA_CLASSIC|VISA_GOLD|AMEX]

@end
