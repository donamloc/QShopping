//
//  CFinData.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCard.h"

@interface CFinData : NSObject
{
    NSString *token;
    NSMutableArray *cardList;
    NSString *paymentCode;
    NSString *accountID;
    double amount;
    double totalAmount;
    NSString *sendDay;
    NSRange hourRangeSendDay;
}

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSMutableArray *cardList;
@property (nonatomic, retain) NSString *paymentCode;
@property (nonatomic, retain) NSString *accountID;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, retain) NSString *sendDay;
@property (nonatomic, assign) NSRange hourRangeSendDay;

// Carrega les targetes a la classe
-(BOOL)getCards;
// Obté la informació d'una certa targeta
-(TCard*)getCardInformation:(NSString *)a_sIDCard;
// Obté el compte principal de l'usuari
-(BOOL)getMainAccount;
// Obté l'ID de la targeta de la posició passada per paràmetre
-(NSString *)getIDCardByIndex:(int)a_iIndex;
@end
