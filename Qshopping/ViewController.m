//
//  ViewController.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
//

#import "ViewController.h"
#import "TCard.h"
#import "Constants.h"

@implementation ViewController

@synthesize itemsListTable, editListCell, listCell, headerListCell, readerView, products, theShop;
@synthesize cancelBtn, payBtn, saveBtn, historyBtn, configBtn, ticketImage, separatorImage;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *stmpSoundName = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"caf"];
    CFURLRef soundURL = (CFURLRef) [NSURL fileURLWithPath:stmpSoundName];
    AudioServicesCreateSystemSoundID(soundURL, &beepSound);
    
    readerView.readerDelegate = self;
    products = [[NSMutableArray arrayWithCapacity:5] retain];
    // El primer article és fals degut a que serà la descripció de la botiga (HeaderListCell)
    [products addObject:[@"NOP" retain]];
    isScanning = YES;
    paymentDone = NO;
    finData = [[[CFinData alloc] init] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [finData release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [readerView stop];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [readerView willRotateToInterfaceOrientation: orient
                                        duration: duration];
}

#pragma mark - Funcions de tractament general
-(void)AddScannedShop:(NSString*)a_sQRCode
{
    if (a_sQRCode != nil)
    {
        if (theShop != nil)
            [theShop release];
        theShop = [[CShop alloc] init];
        if (![theShop readFromQR:a_sQRCode])
        {
            [theShop release];
            theShop = nil;
            NSLog(@"Eror llegint la botiga");
            // ERROR
        }
    }
}

-(void)AddScannedProduct:(NSString*)a_sQRCode
{
    if (a_sQRCode != nil)
    {
        CProduct *tmpProduct = [[CProduct alloc] init];
        if ([tmpProduct readFromQR:a_sQRCode])
        {
            [products addObject:tmpProduct];
        }
        // ERROR
        
    }
}

#pragma mark - ZBarReaderViewDelegate

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) 
    {
        NSLog(@"Llegit QR: %@", sym.data);
        // Si és el primer producte, també llegim la botiga
        if ([products count] == 1)
            [self AddScannedShop:sym.data];
        [self AddScannedProduct:sym.data];
        break;
    }
    AudioServicesPlaySystemSound(beepSound);
    [itemsListTable reloadData];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
}

// the table's selection has changed, show the alert or action sheet
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fem alguna cosa amb l'article amb index [indexPath row]];
    if (([indexPath row] > 0)&&([indexPath row] <= [products count]))
    {
        // Obtenim un png de la web
        CProduct *tmpProduct = (CProduct*)[products objectAtIndex:[indexPath row]];

        NSString *tmpURLImage = [NSString stringWithFormat:@"%@/Ad_0%@.png", _URL_AZURE_, tmpProduct.ID];
        NSData *tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tmpURLImage]];
        UIImage *tmpImage = [UIImage imageWithData:tmpData];
        
        // Mostrem la VC
        ProductDescriptionViewController *tmpPDVC = [[ProductDescriptionViewController alloc] init];
        tmpPDVC.delegate = self;
        tmpPDVC.theImage = tmpImage;
        [self.view addSubview:tmpPDVC.view];
    }
}

-(void)ExitProdDesc:(id)sender
{    
    ProductDescriptionViewController *tmpPDVC = (ProductDescriptionViewController*)sender;
    [tmpPDVC.view removeFromSuperview];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tmpHeight = 44;
    if ([indexPath row] == 0)
        tmpHeight = 71;
    else if ([indexPath row] < [products count])
        tmpHeight = 70;
    
    return tmpHeight;
}

#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Si no estem escanejant, hem de mostrar el total
    NSInteger itmpTotal = [products count];
    if (!isScanning)
        itmpTotal++;
    return itmpTotal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    // Mirem si és la primera fila
    if ([indexPath row] == 0)
    {
        HeaderListCell *headerCell = nil;
        headerCell = (HeaderListCell*)[tableView dequeueReusableCellWithIdentifier:@"tblHeaderListCell"];
        if(headerCell == nil) 
        {
            [[NSBundle mainBundle] loadNibNamed:@"HeaderListCell" owner:self options:nil];
            headerCell = headerListCell;
        }
        
        if (headerCell != nil)
        {
            if (theShop != nil)
                [headerCell setLogo:theShop.logoImage];
            else
                [headerCell setLogo:[UIImage imageNamed:@"1bit.png"]];
        }
        cell = headerCell;
    }
    // Mirem si la fila que mostrem està marcada per edició
    // En cas contrari mostre la cel·la normal
    else if ([indexPath row] < [products count])
    {    
        ListCell *tmpListCell = (ListCell*)[tableView dequeueReusableCellWithIdentifier:@"tblListCell"];
        if(tmpListCell == nil) 
        {
            [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
            tmpListCell = listCell;
        }
        
        if (tmpListCell != nil)
        {
            CProduct *tmpProduct = (CProduct*)[products objectAtIndex:[indexPath row]];
            [tmpListCell setQuantity:tmpProduct.quantity];
            [tmpListCell setDescription:tmpProduct.description];
            [tmpListCell setTotal:tmpProduct.price quantity:tmpProduct.quantity];

            tmpListCell.deleteButton.tag = [indexPath row];
            tmpListCell.deleteButton.hidden = !isScanning;
        }
        cell = tmpListCell;
    }
    // En aquest cas estem mostrant el total
    else
    {
        // Segur que isScanning == NO
        FooterListCell *tmpFooterListCell = (FooterListCell*)[tableView dequeueReusableCellWithIdentifier:@"tblFooterListCell"];
        if(tmpFooterListCell == nil) 
        {
            [[NSBundle mainBundle] loadNibNamed:@"FooterListCell" owner:self options:nil];
            tmpFooterListCell = footerListCell;
        }
        
        if (tmpFooterListCell != nil)
        {
            NSEnumerator *enumerator = [products objectEnumerator];
            // Ens Saltem l'OP
            [enumerator nextObject];
            
            CProduct *tmpProduct;
            finData.amount = 0;

            while (tmpProduct = (CProduct*)[enumerator nextObject])
            {
                finData.amount += tmpProduct.price;
            }
            
            finData.totalAmount = finData.amount * 1.4;
            NSString *stmpStringTotal = [NSString stringWithFormat:@"%2.f€ + %2.f€  %2.f€", finData.amount, finData.amount * 0.4, finData.totalAmount];
            [tmpFooterListCell setTotal:stmpStringTotal];
        }
        cell = tmpFooterListCell;
    }
    
    return cell;
}

#pragma mark - Interacció amb les cel·les de la taula
-(IBAction)onDeleteCell:(id)sender
{
    UIButton *tmpDelButton = (UIButton*)sender;
    NSLog(@"Deleting product id: %d", tmpDelButton.tag );
    [products removeObjectAtIndex:tmpDelButton.tag];
    [itemsListTable reloadData];
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender
{
    /*
    NSLog(@"Swipe");
    ListCell* tmpCell = (ListCell*)sender.view;
    NSIndexPath* tmpIndexPath = [itemsListTable indexPathForCell:tmpCell];
    if (tmpIndexPath != nil)
        m_IndexSwipe = [tmpIndexPath row];
    else
        m_IndexSwipe = -1;
    [itemsListTable reloadData];
    */
}

// En funció si estem escanejant o no mostrem l'escanejador, i tots els butons
-(void)organizeView
{
    if (isScanning)
    {
        // Mostrem l'escanner
        readerView.hidden = NO;
        [readerView start];
        // Ajustem la mida de la llista
        // (0,125)-(320,305)
        itemsListTable.frame = CGRectMake(0, 125, 320, 305);
        // Activem tots els botons
        historyBtn.enabled = YES;
        saveBtn.enabled = YES;
        configBtn.enabled = YES;
        // El segon és validar compra
        [payBtn setImage:[UIImage imageNamed:@"Boto_Compra_OFF.jpg"] forState:UIControlStateNormal];
        [payBtn setImage:[UIImage imageNamed:@"Boto_Compra_ON.jpg"] forState:UIControlStateHighlighted];
        // Mostrem el fons i el separador
        ticketImage.hidden = NO;
        separatorImage.hidden = NO;
    }
    else
    {
        // Amaguem l'escanner
        readerView.hidden = YES;
        [readerView stop];
        // Ajustem la mida de la llista
        // (0,0)-(320,430)
        itemsListTable.frame = CGRectMake(0, 0, 320, 430);
        // Deixem només activats els dos primers botons
        historyBtn.enabled = NO;
        saveBtn.enabled = NO;
        configBtn.enabled = NO;
        // El segon botó és comprar
        [payBtn setImage:[UIImage imageNamed:@"Boto_Pagar_OFF.jpg"] forState:UIControlStateNormal];
        [payBtn setImage:[UIImage imageNamed:@"Boto_Pagar_ON.jpg"] forState:UIControlStateHighlighted];
        // Amaguem el fons i el separador
        ticketImage.hidden = YES;
        separatorImage.hidden = YES;
    }
    if (paymentDone)
    {
        payBtn.enabled = NO;
    }
    else
    {
        payBtn.enabled = YES;
    }
    [itemsListTable reloadData];
}

#pragma mark - Interacció amb la botonera

-(void)showConfirmation
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenció" message:@"Això esborrarà tots els productes.\nVol continuar?"
												   delegate:self 
										  cancelButtonTitle:@"No"
										  otherButtonTitles:@"Sí",nil];
	alert.tag = 10;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 10)&&buttonIndex==1)
    {
        // Esborrem tots els productes
        [products removeAllObjects];
        [products addObject:@"NOP"];
        [theShop release];
        theShop = nil;
        [readerView stop];
        [self organizeView];        
    }
}

-(IBAction)onCancel:(id)sender
{
    if (isScanning)
    {
        // Preguntem si volem esborrar tots els productes
        [self showConfirmation];
    }
    else
    {
        if (paymentDone)
        {
            [products removeAllObjects];
            [products addObject:@"NOP"];
            [theShop release];
            theShop = nil;
            [readerView stop];
            paymentDone = NO;
            isScanning = YES;
            [self organizeView];
        }
        else
        {
            isScanning = YES;
            [self organizeView];
        }
    }
}

-(IBAction)onBuy:(id)sender
{
    if (isScanning)
    {
        if ([products count] > 1)
        {
            // Validem compra
            isScanning = NO;
            [self organizeView];
        }
    }
    else
    {
        // Preguntem el dia a de transport
        CalendarChooseViewController *tmpCCVC = [[CalendarChooseViewController alloc] init];
        tmpCCVC.delegate = self;
        [self.view addSubview:tmpCCVC.view];
    }
}


-(IBAction)onSave:(id)sender
{
}

-(IBAction)onHistory:(id)sender
{
}

#pragma mark - Iteraccions amb la pantalla d'escollir dia
-(void)ChoosedCanceled:(id)sender
{
    CalendarChooseViewController *tmpCCVC = (CalendarChooseViewController*)sender;
    [tmpCCVC.view removeFromSuperview];
}

-(void)ChoosedOk:(id)sender date:(NSString *)a_date hourRange:(NSRange)a_hourRange
{
    CalendarChooseViewController *tmpCCVC = (CalendarChooseViewController*)sender;
    finData.sendDay = a_date;
    finData.hourRangeSendDay = a_hourRange;
    [tmpCCVC.view removeFromSuperview];
    // Mostrem la data d'enviament al ticket
    
    // Comprem
    [self buy];
}

#pragma mark - Iteraccions amb la pantalla de configuració
-(IBAction)onConfig:(id)sender
{
    ConfigurationViewController *tmpCfgVC = [[ConfigurationViewController alloc] init];
    tmpCfgVC.delegate = self;
    [self.view addSubview:tmpCfgVC.view];
}

-(void)ExitConfig:(id)sender
{
    ConfigurationViewController *tmpCfgVC = (ConfigurationViewController*)sender;
    [tmpCfgVC.view removeFromSuperview];
}

#pragma mark - Interaccions de pagament
-(void)buy
{
    // Primer demanem l'usuari i el password i fem login i obtenim tota la informació de l'usuari
    LoginViewController *tmpLoginView = [[LoginViewController alloc] init];
    tmpLoginView.view.tag = _TAG_LOGIN_;
    tmpLoginView.delegate = self;
    [tmpLoginView setTotalAmount:finData.totalAmount];
    [self.view addSubview:tmpLoginView.view];
}

-(BOOL)executeBuy:(NSString *)a_sCardID
{
    //EXECUTEM LA COMPRA
    BOOL btmpOk = NO;
    // Fem la crida a la API 
    NSString *stmpURLLogin = [NSString stringWithFormat:@"%@/%@/%@", _BASE_API_URL_, finData.token, 
                             [NSString stringWithFormat:_EXECUTE_PAYMENT_, a_sCardID, finData.amount]];
    
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
                finData.paymentCode = [tmpIdArray objectForKey:@"code"];
                NSLog(@"Codi de pagament: %@", finData.paymentCode);
                btmpOk = YES;
            }
            // else ERROR
        }
        else
        {
            NSString *stmpError = [NSString stringWithFormat:@"Error executant la compra: %@", [tmpJsonArray objectForKey:@"msg"]];
            [self ShowAlert:stmpError];
        }
    }
    // ERROR
    
    return btmpOk;
}

#pragma mark    - As a WaitForPaymentDelegate
-(void)BuyExecuted:(id)sender
{
    WaitForPayment *tmpWFP = (WaitForPayment*)sender;
    [tmpWFP.view removeFromSuperview];
    [tmpWFP release];
    // Ja hem comprat!
    NSLog(@"Ja hem comprat");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gràcies" message:@"Compra realitzada. Gràcies per usar QShopping"
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil,nil];
	alert.tag = 0;
	[alert show];
	[alert release];

    paymentDone = YES;
    // Guardem la compra
    // Inicialitzem la taula
    paymentDone = YES;
    [self organizeView];
}


#pragma mark    - As a LoginDelegate
-(void)LoginOk:(id)sender token:(NSString *)a_stoken
{
    LoginViewController *tmpLogin = (LoginViewController*)sender;
    [tmpLogin.view removeFromSuperview];
    [tmpLogin release];
    
    // Obtenim el token el guardem i continuem amb la compra
    NSLog(@"Login d'usuari amb token: %@", a_stoken);
    finData.token = a_stoken;
    // Obtenim un compte
    if ([finData getMainAccount])
    {
        // Mostrem la llista de targetes per a que n'esculli una
        if ([finData getCards])
        {
            
            UIActionSheet* action = [[UIActionSheet alloc] 
                                     initWithTitle:@"Escull la targeta" 
                                     delegate:self 
                                     cancelButtonTitle:@"Cancelar"
                                     destructiveButtonTitle:nil 
                                     otherButtonTitles: nil ];
            
            NSEnumerator *enumerator = [finData.cardList objectEnumerator];
            TCard *tmpCard;
            while (tmpCard = (TCard*)[enumerator nextObject]) 
            {
                [action addButtonWithTitle:tmpCard.issuer];
            }            
            
            [action showInView:self.view];
            [action release];
        }
        else
            [self ShowAlert:@"Error obtenint les targetes associades"];
    }
    else
        [self ShowAlert:@"Error obtenint el compte principal"];
}

-(void)waitForPaymentToFinish
{
    // Mostrem la pantalla de wait
    WaitForPayment *tmpWFP = [[WaitForPayment alloc] init];
    tmpWFP.delegate = self;
    tmpWFP.finData = finData;
    [self.view addSubview:tmpWFP.view];
    // Programem un timer per anar preguntant si ja ha acabat
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex > 0) 
    {
        // Fem la compra amb la targeta especificada
        if ([self executeBuy:[finData getIDCardByIndex:(buttonIndex -1)]])
        {
            // Esperem que acabi la transacció
            [self waitForPaymentToFinish];
        }
    }
}

-(void)ShowAlert:(NSString *)a_sMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenció" message:a_sMessage
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil,nil];
	alert.tag = 0;
	[alert show];
	[alert release];
}

-(void)LoginFailed:(id)sender msg:(NSString*)a_sMessage
{
    NSLog(@"Error fent el login d'usuari amb msg: %@", a_sMessage);
    NSString *stmpMsg = [NSString stringWithFormat:@"No s'ha pogut fer el login.\r%@", a_sMessage];
    [self ShowAlert:stmpMsg];
    
    LoginViewController *tmpLogin = (LoginViewController*)sender;
    [tmpLogin.view removeFromSuperview];
    [tmpLogin release];
}



@end
