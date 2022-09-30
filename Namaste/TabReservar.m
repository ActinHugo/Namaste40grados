//
//  TabReservar.m
//  Namaste
//
//  Created by Alejandro Rodas on 09/07/22.
//

#import "TabReservar.h"
#import "DatosClases.h"
#import "CcClases.h"
#import "MBProgressHUD.h"
#import "DatosSalones.h"
#import "DatosClasesReservar.h"


@interface TabReservar ()

@end

@implementation TabReservar{
    
    NSMutableArray* arrayClasesRes;
    NSMutableArray* arrayDatosSalon;
    NSMutableArray* arregloMenu;
    NSString* salonSel;
    NSString* idSalon;
    bool menuAbierto;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayDatosSalon = [[NSMutableArray alloc] initWithCapacity:5];
    arrayClasesRes = [[NSMutableArray alloc] initWithCapacity:5];
    
    [self.lbNomUsu setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"NOMBRE"]];
    
    //self.tfSalonEdit.rightViewMode = UITextFieldViewModeAlways;
    //self.tfSalonEdit.enabled = NO;
    //self.tfSalonEdit.rightView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"flecha_salon.png"]];

    self.tfSalonEdit.delegate = self;
    
    self.viewSalon.layer.cornerRadius = 30;
    self.viewSalon.layer.masksToBounds = true;

    self.viewFecha.layer.cornerRadius = 30;
    self.viewFecha.layer.masksToBounds = true;
    
    self.viewMenu.layer.cornerRadius = 30;
    self.viewMenu.layer.masksToBounds = true;
    
    arregloMenu = [[NSMutableArray alloc]initWithCapacity:3];
    
    [arregloMenu addObject:@"Conócenos"];
    [arregloMenu addObject:@"Paquetes"];
    [arregloMenu addObject:@"Horarios"];
    [arregloMenu addObject:@"Nuestras clases"];
    [arregloMenu addObject:@"Salones"];
    [arregloMenu addObject:@"Ubícanos"];
    [arregloMenu addObject:@"Log out"];
    
    self.viewMenu.backgroundColor = [UIColor whiteColor];
    self.viewMenu.opaque = NO;
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    
    [self descargaSalones];

}

#pragma mark - Conexiones

-(void)reservarClase:(NSString*)idClase:(NSString*)idSalon :(NSString*)fecha{
    
    MBProgressHUD* progresoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSLog(@"Fecha seleccionado %@",fecha);
    progresoHud.mode = MBProgressHUDModeIndeterminate;
    progresoHud.label.text = @"Registrando";
    
    NSString* url = @"http://actinseguro.com/booking/abkcom007.aspx";
    
    NSDictionary* json = @{ @"CIA": [[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],
                            @"ID_CLASE": idClase,
                            @"ID_SALON_LUGAR" : idSalon,
                            @"ID_USUARIO" : [[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],
                            @"RESERVA_DIA" : fecha,
    };
    
    NSArray* arregloJson = [[NSArray alloc] initWithObjects:json, nil];
    
    NSDictionary* jsonObject = [NSDictionary dictionaryWithObject:arregloJson forKey:@"REGISTRO_CLASE"];
    
    NSError* errorJS;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:kNilOptions error:&errorJS];
    
    NSString* jsonFormado = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonFormado);
    
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* respuestaJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",respuestaJson);
        
        NSError* errorJson;
        
        NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
        
        NSArray* respuestaArreglo = [jsonObject objectForKey:@"RESPONSE"];
        
        jsonObject = [respuestaArreglo objectAtIndex:0];
        
        if ([[jsonObject valueForKey:@"STS"] isEqual:@"0"])  {
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Se ha registrado correctamente a la clase" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    
                    
                }];
                [alertController addAction:aceptar];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
            
            
        }/*else if([[jsonObject valueForKey:@"STS"] isEqual:@"2"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"MSG"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                }];
                [alertController addAction:aceptar];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
            
        }else if([[jsonObject valueForKey:@"STS"] isEqual:@"4"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"MSG"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                }];
                [alertController addAction:aceptar];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
            
        }*/else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"MSG"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    
                    
                }];
                [alertController addAction:aceptar];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        
    }];
    
    
    [dataTask resume];
}

-(void)descargaSalones{
    
    MBProgressHUD* progresoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    progresoHud.mode = MBProgressHUDModeIndeterminate;
    progresoHud.label.text = @"Descargando Salones";
    
    NSString* url = [NSString stringWithFormat:@"http:www.actinseguro.com/booking/abkcom004.aspx?%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"]];
    
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSString* respuesta = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Link  %@",respuesta);
        [self->arrayDatosSalon removeAllObjects];
        if (data != nil) {
            NSError* errorJson;
            
            NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
            
            NSArray* arreglo = [jsonObject objectForKey:@"SALONES_LUGARES"];
            NSDictionary* objSalones;
            DatosSalones* datosSalones;
            
            //NSLog(@"Nombre Salones  %lu",(unsigned long)[arreglo count]);
            
            for (int x = 0; x < arreglo.count; x++) {
                
                objSalones = [arreglo objectAtIndex:x];
                NSLog(@"Nombre  %@",[objSalones valueForKey:@"SALON_LUGAR_NOMBRE"]);
                datosSalones = [DatosSalones alloc];
                datosSalones.idLugar =[objSalones valueForKey:@"SALON_LUGAR_ID"];
                datosSalones.nombLugar =[objSalones valueForKey:@"SALON_LUGAR_NOMBRE"];
                datosSalones.tipoLugar =[objSalones valueForKey:@"SALON_LUGAR_TIPO"];
                datosSalones.dirLugar =[objSalones valueForKey:@"SALON_LUGAR_DIRECCION"];
                datosSalones.contLugar =[objSalones valueForKey:@"SALON_LUGAR_CONTACTO"];
                
                [self->arrayDatosSalon addObject:datosSalones];
                
            }
        }else{
            NSLog(@"No hay datos");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }];
    
    
    [urlSession resume];
    
    
}

-(void)descargarClases{
    
    MBProgressHUD* progresoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    progresoHud.mode = MBProgressHUDModeIndeterminate;
    progresoHud.label.text = @"Consultando clases";
    
    NSString* url = [NSString stringWithFormat:@"http:www.actinseguro.com/booking/abkcom003.aspx?%@,%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],idSalon,self.lbFecha.text];
    
    NSLog(@"Link  %@",url);
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSString* respuesta = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Link  %@",respuesta);
        
        if (data != nil) {
            NSError* errorJson;
            
            NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
            
            NSArray* arreglo = [jsonObject objectForKey:@"CLASES_POR_SALON_LUGAR"];
            NSDictionary* objSalones;
            DatosClasesReservar* datosReservar;
            [self->arrayClasesRes removeAllObjects];
            
            //NSLog(@"Nombre Salones  %lu",(unsigned long)[arreglo count]);
            
            for (int x = 0; x < arreglo.count; x++) {
                
                objSalones = [arreglo objectAtIndex:x];
                
                if (![[objSalones valueForKey:@"CIA"] isEqualToString:@"No Hay Clases para esa fecha"]) {
                    
                
                    datosReservar = [DatosClasesReservar alloc];
                    datosReservar.idClase =[objSalones valueForKey:@"CLASE_ID_CLASE"];
                    datosReservar.nomClase =[objSalones valueForKey:@"CLASE_NOMBRE"];
                    datosReservar.tipo =[objSalones valueForKey:@"CLASE_TIPO"];
                    datosReservar.horario =[objSalones valueForKey:@"CLASE_HORARIO"];
                    datosReservar.responsable = [objSalones valueForKey:@"CLASE_RESPONSABLE"];
                    datosReservar.status =[objSalones valueForKey:@"CLASE_STATUS"];
                    datosReservar.cupoMax =[objSalones valueForKey:@"CLASE_CUPO_MAX"];
                    datosReservar.ocupado =[objSalones valueForKey:@"CLASE_OCUPADO"];
                
                    [self->arrayClasesRes addObject:datosReservar];
                }
                
            }
        }else{
            NSLog(@"No hay datos");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.cvClasesRes reloadData];
            [self.cvClasesRes reloadInputViews];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }];
    
    
    [urlSession resume];
    
}

-(void)llenarListas{
    
    [arrayDatosSalon addObject:@"Salón"];
    [arrayDatosSalon addObject:@"Tradicional"];
    
    DatosClases* clase = [DatosClases alloc];
    clase.nomMaestro = @"Juan Perez";
    clase.tipoClase = @"Rocket";
    clase.horario = @"17:00";
    clase.nomIcono = @"am";
    
    [arrayClasesRes addObject:clase];
    
    clase = [DatosClases alloc];
    clase.nomMaestro = @"Diana Cazares";
    clase.tipoClase = @"TRX";
    clase.horario = @"14:00";
    clase.nomIcono = @"lau";
    
    [arrayClasesRes addObject:clase];
    
    
    
}

#pragma mark - Acciones

- (IBAction)tfSalon:(UITextField *)sender {
    
    //NSLog(@"Se presiono el campo de texto");
    
   
    
    
}

#pragma mark -Metodos TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return arrayDatosSalon.count;

    }
    return arregloMenu.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        return 45;
    }
    
    return 50;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        
        salonSel = [[arrayDatosSalon objectAtIndex:indexPath.row] nombLugar];
        idSalon = [[arrayDatosSalon objectAtIndex:indexPath.row] idLugar];
        
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Horarios"]) {
            
            [self performSegueWithIdentifier:@"segueHorario" sender:self];
            
        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Ubícanos"]){
            
            [self performSegueWithIdentifier:@"segueUbica" sender:self];

        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Conócenos"]){
            
            [self performSegueWithIdentifier:@"segueConocenos" sender:self];

        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Salones"]){
            
            [self performSegueWithIdentifier:@"segueSalones" sender:self];

        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Nuestras clases"]){
            
            [self performSegueWithIdentifier:@"segueClases" sender:self];
            

        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Paquetes"]){
            
            [self performSegueWithIdentifier:@"seguePaquete" sender:self];
            

        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Log out"]){
            
            //exit(0);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Log out"] message:[NSString stringWithFormat:@"¿Cerrar sesión en este dispositivo?"] preferredStyle:UIAlertControllerStyleAlert];
            //[alertController setValue:controller forKey:@"contentViewController"];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

            }];
            [alertController addAction:cancelAction];
            UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                [self.presentingViewController  dismissViewControllerAnimated:NO completion:nil];
                
            }];
            [alertController addAction:aceptar];
            
            [self presentViewController:alertController animated:true completion:nil];
            
        }
        
        [self escondeAccion];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (tableView.tag == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellReser" forIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellReser"];
        }

        
        DatosSalones* datos = [arrayDatosSalon objectAtIndex:indexPath.row];
        
        NSLog(@"Salones  %@",datos.nombLugar);
        
            cell.textLabel.text = datos.nombLugar;
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemMenu" forIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"itemMenu"];
        }


        cell.textLabel.text = [arregloMenu objectAtIndex:indexPath.row];
        
        if ([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Conócenos"]) {
            
            cell.imageView.image = [UIImage imageNamed:@"conocenos"];
            
        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Paquetes"]){
            
            cell.imageView.image = [UIImage imageNamed:@"paquetes"];
            
        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Horarios"]){
            
            cell.imageView.image = [UIImage imageNamed:@"horarios"];
            
        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Nuestras clases"]){
            
            cell.imageView.image = [UIImage imageNamed:@"nuestra_clase"];
            
        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Salones"]){
            
            cell.imageView.image = [UIImage imageNamed:@"salones"];
            
        }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Ubícanos"]){
            
            cell.imageView.image = [UIImage imageNamed:@"ubicanos"];
            
        }else{
            
            cell.imageView.image = [UIImage imageNamed:@"logout"];
        }
        
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - ActionSheet

-(void)mostrarSalones{
    UIViewController *controller = [[UIViewController alloc]init];
    
    CGRect rect;

    rect = CGRectMake(0, 0, 272, 400);
    [controller setPreferredContentSize:rect.size];

    

    self.tableView  = [[UITableView alloc]initWithFrame:rect];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setTag:1];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellReser"];
    [controller.view addSubview:self.tableView];
    [controller.view bringSubviewToFront:self.tableView];
    [controller.view setUserInteractionEnabled:YES];
    [self.tableView setUserInteractionEnabled:YES];
    [self.tableView setAllowsSelection:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Escoge un Salón" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

    }];
    [alertController addAction:cancelAction];
    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        self.lbSalon.text = self->salonSel;
        
        if (![self.lbFecha.text isEqualToString:@""]) {
            
            [self descargarClases];
        }
        
    }];
    [alertController addAction:aceptar];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)mostrarCalendario{
    
   
    
    /*self.dpFecha = [[UIDatePicker alloc] init];
    self.dpFecha.backgroundColor = [UIColor whiteColor];
        [self.dpFecha setValue:[UIColor blackColor] forKey:@"textColor"];
        
    self.dpFecha.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.dpFecha.datePickerMode = UIDatePickerModeDate;
    self.dpFecha.preferredDatePickerStyle = UIDatePickerStyleInline;
        
        [self.dpFecha addTarget:self action:@selector(vtFecha:) forControlEvents:UIControlEventValueChanged];
    self.dpFecha.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 500, [UIScreen mainScreen].bounds.size.width, 300);
        [self.view addSubview:self.dpFecha];*/
        
        
    
    
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    rect = CGRectMake(0, 0, 320, 400);
    
    //[controller setPreferredContentSize:rect.size];
    [controller setPreferredContentSize:rect.size];
    self.dpFecha = [[UIDatePicker alloc]init];
    self.dpFecha.datePickerMode = UIDatePickerModeDate;
    self.dpFecha.preferredDatePickerStyle = UIDatePickerStyleInline;
    self.dpFecha.translatesAutoresizingMaskIntoConstraints = false;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:7];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setDay:0];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];

    [self.dpFecha setMinimumDate:minDate];
    [self.dpFecha setMaximumDate:maxDate];
    
    //[self.dpFecha setMinimumDate:[NSDate date]];
    

    
    //[self.dpFecha setMaximumDate:];
    
    self.dpFecha.date = [NSDate date];

        
    //[controller.view addSubview:self.dpFecha];
    //[controller.view bringSubviewToFront:self.dpFecha];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    //[alertController setValue:controller forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

    }];
    [alertController addAction:cancelAction];
    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        self.lbFecha.text = [formatter stringFromDate: self.dpFecha.date];
        
        if (![self->salonSel isEqualToString:@""]) {
            
            [self descargarClases];
        }
        
    }];
    [alertController addAction:aceptar];
    
    [alertController.view addSubview:self.dpFecha];
    [alertController.view.heightAnchor constraintEqualToConstant:500].active = YES;
    
    [self.dpFecha.leadingAnchor constraintEqualToAnchor:alertController.view.leadingAnchor].active = YES;
    [self.dpFecha.trailingAnchor constraintEqualToAnchor:alertController.view.trailingAnchor].active = YES;
    [self.dpFecha.topAnchor constraintEqualToAnchor:alertController.view.topAnchor constant:10].active = YES;
    
    
    [self presentViewController:alertController animated:YES completion:nil];
        
    
    
    NSLog(@"Se presiono Fecha");

    
}


#pragma mark - Metodos de Collection

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return arrayClasesRes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CcClases* celdaClases = [collectionView dequeueReusableCellWithReuseIdentifier:@"celdaClases" forIndexPath:indexPath];
    
    if (!celdaClases) {
        
        celdaClases = [[CcClases alloc] init];
    }
    
    DatosClasesReservar* datos = [arrayClasesRes objectAtIndex:indexPath.row];
    
    //NSLog(@"Se mostraran los datos %@",datos.nomClase);
    celdaClases.lbNomMaestro.text = datos.nomClase;
    celdaClases.lbTipoClase.text = datos.responsable;
    celdaClases.lbHorario.text = datos.horario;
    
    if ([datos.responsable isEqual:@"OLGA BELICHKO"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"olga_belichko.png"];
    }else if ([datos.responsable isEqual:@"YURI CIENFUEGOS"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"yuri_cien.png"];
    }else if ([datos.responsable isEqual:@"LAURA"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"laura.png"];
    }else if ([datos.responsable isEqual:@"ADRIANA GARIBAY"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"adri_gari_vaz.png"];
    }else if ([datos.responsable isEqual:@"JUAN CALDERON"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"juan_cald.png"];
    }else if ([datos.responsable isEqual:@"SYLVIA MONSALVE"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"sylvia_mons.png"];
    }else if ([datos.responsable isEqual:@"BRIGGITE SCHEPERS"]) {
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@"brig_sche.png"];
    }else{
        
        celdaClases.ivFondoCell.image = [UIImage imageNamed:@""];
    }
    
    return celdaClases;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return CGSizeMake(350,150);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DatosClasesReservar* clases = [arrayClasesRes objectAtIndex:indexPath.row];
        
    NSUInteger lugaresDisp = [clases.cupoMax integerValue] - [clases.ocupado integerValue];
    
    if (lugaresDisp > 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"¿Reservar clase?"] message:[NSString stringWithFormat:@"¿Reservar la clase de %@ con el profesor %@ el día %@?, Quedan %lu lugar(es)",clases.nomClase,clases.responsable,self.lbFecha.text,(unsigned long)lugaresDisp] preferredStyle:UIAlertControllerStyleAlert];
        //[alertController setValue:controller forKey:@"contentViewController"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        }];
        [alertController addAction:cancelAction];
        UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            //NSLog(@"%@", [NSString stringWithFormat:@"%@ Salon %@",clases.idClase,self->idSalon]);
            
            [self reservarClase:[NSString stringWithFormat:@"%@",clases.idClase] :[NSString stringWithFormat:@"%@",self->idSalon]:[NSString stringWithFormat:@"%@",self.lbFecha.text]];
            
        }];
        [alertController addAction:aceptar];
        
        [self presentViewController:alertController animated:true completion:nil];
        
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Clase llena"] message:@"Esta clase ya no tiene lugares disponibles" preferredStyle:UIAlertControllerStyleAlert];
        //[alertController setValue:controller forKey:@"contentViewController"];
        
    
        UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

           
            
        }];
        [alertController addAction:aceptar];
        
        [self presentViewController:alertController animated:true completion:nil];
        
        
    }
    
    
}

#pragma mark - Menu

- (IBAction)btnMenu:(id)sender {
    
    [self menuCustom];
}

- (IBAction)esconderMenu:(id)sender{
    
    [self escondeAccion];
}

-(void)menuCustom{
    
    [UIView transitionWithView:self.viewFondo duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
            [self.viewFondo setHidden:NO];
        self.viewFondo.alpha = 1.0;
    } completion:nil];
    
    [UIView transitionWithView:self.viewMenu duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
            [self.viewMenu setHidden:NO];
        self.viewMenu.alpha = 1.0;
    } completion:nil];
    
    menuAbierto = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDarkContent;
}



#pragma mark - Metodos textField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}


- (IBAction)vtSalon:(id)sender {
    
    
    [self mostrarSalones];
    
}
- (IBAction)vtFecha:(id)sender {
    [self mostrarCalendario];
}

#pragma mark - Metodos de vista

-(void)viewWillAppear:(BOOL)animated{
    
    if (!self.viewMenu.isHidden) {
        
        [self.viewFondo setHidden:YES];
        [self.viewMenu setHidden:YES];
    }
    
    menuAbierto = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSString* reservar =[[NSUserDefaults standardUserDefaults] objectForKey:@"reservar"];
    
    if (![reservar isEqualToString:@""]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"reservar"];
        
        //NSLog(@"RESERVAR %lu",arrayDatosSalon.count);
            
            for (DatosSalones* datos in arrayDatosSalon) {
                
                //NSLog(@"RESERVAR %@ --- %@",reservar,datos.nombLugar);
                
                if ([datos.nombLugar isEqualToString:reservar]) {
                    
                    salonSel = datos.nombLugar;
                    idSalon = datos.idLugar;
                    
                    self.lbSalon.text = self->salonSel;
                    
                    
                }
            }
    }
    
}

-(void)escondeAccion{
    
    [UIView transitionWithView:self.viewFondo duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
            //[self.viewFondo setHidden:YES];
            self.viewFondo.alpha = 0;
    } completion:nil];
    
    [UIView transitionWithView:self.viewMenu duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
            //[self.viewMenu setHidden:YES];
            self.viewMenu.alpha = 0;
    } completion:nil];
    
    menuAbierto = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
}


@end
