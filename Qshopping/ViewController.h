//
//  ViewController.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 clappthehands. All rights reserved.
//
// Aquesta es la ViewController principal.
// La primera que s'obre i a on es poden trobar les principals funcionalitats de l'aplicatiu
// En aquesta s'ha inclòs la vista per a capturar el QRCode

#import <UIKit/UIKit.h>
#import "EditListCell.h"
#import "ListCell.h"
#import "HeaderListCell.h"
#import "FooterListCell.h"
#import "CProduct.h"
#import "CShop.h"
#import "LoginViewController.h"
#import "CFinData.h"
#import "WaitForPayment.h"
#import "ConfigurationViewController.h"
#import "ProductDescriptionViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define _TAG_LOGIN_ 105

@interface ViewController : UIViewController
    < ZBarReaderViewDelegate, 
        UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, 
        LoginDelegate, UIActionSheetDelegate,WaitForPaymentDelegate, ConfigVCDelegate, ProdDescVCDelegate>
{
    // Vista de captura del QRCode
    ZBarReaderView *readerView;
    // Taula i cel·les asociades
    IBOutlet UITableView *itemsListTable;
    IBOutlet EditListCell *editListCell;
    IBOutlet ListCell *listCell;
    IBOutlet HeaderListCell *headerListCell;
    IBOutlet FooterListCell *footerListCell;
    IBOutlet UIImageView *ticketImage;
    IBOutlet UIImageView *separatorImage;
    
    // Botons
    IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *payBtn;
    IBOutlet UIButton *saveBtn;
    IBOutlet UIButton *historyBtn;
    IBOutlet UIButton *configBtn;
    
    // Lista de productes comprats
    NSMutableArray *products;
    NSString *shopDescription;
    NSInteger m_IndexSwipe;
    
    // Botiga actual
    CShop *theShop;
    
    // Dades financeres
    CFinData *finData;
    
    // Valdrà cert mentre estiguem escanejant
    BOOL isScanning;
    
    // So d'escaneig
    SystemSoundID beepSound;

}

@property (nonatomic, retain) IBOutlet UITableView *itemsListTable;
@property (nonatomic, retain) IBOutlet EditListCell *editListCell;
@property (nonatomic, retain) IBOutlet ListCell *listCell;
@property (nonatomic, retain) IBOutlet HeaderListCell *headerListCell;
@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) CShop* theShop;

@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;
@property (nonatomic, retain) IBOutlet UIButton *payBtn;
@property (nonatomic, retain) IBOutlet UIButton *saveBtn;
@property (nonatomic, retain) IBOutlet UIButton *historyBtn;
@property (nonatomic, retain) IBOutlet UIButton *configBtn;
@property (nonatomic, retain) IBOutlet UIImageView *ticketImage;
@property (nonatomic, retain) IBOutlet UIImageView *separatorImage;

// Accions en general
-(void)AddScannedShop:(NSString*)a_sQRCode;
-(void)AddScannedProduct:(NSString*)a_sQRCode;

// Accions sobre la vista
-(IBAction)onCancel:(id)sender;
-(IBAction)onBuy:(id)sender;
-(IBAction)onSave:(id)sender;
-(IBAction)onHistory:(id)sender;
-(IBAction)onConfig:(id)sender;

// Accions sobre la taula
-(IBAction)onDeleteCell:(id)sender;
- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender;

// Accions de la interfície i control d'errors
-(void)ShowAlert:(NSString *)a_sMessage;

// Accions generals de compra
-(void)buy;
-(BOOL)executeBuy:(NSString *)a_sCardID;

@end
