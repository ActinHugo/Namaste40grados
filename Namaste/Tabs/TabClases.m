//
//  TabClases.m
//  Namaste
//
//  Created by Alejandro Rodas on 02/07/22.
//

#import "TabClases.h"
#import "CcClases.h"
#import "DatosClases.h"
#import "MBProgressHUD.h"



@interface TabClases (){
    
    NSMutableArray* maFiltroClases;
    NSMutableArray* maListaClases;
    NSMutableArray* arregloMenu;
    bool menuAbierto;
    NSDate *maxDate;
    NSDate *minDate;
    NSMutableArray* arregloEventos;
}

@end

@implementation TabClases

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat = @"dd/MM/yy";
    
    arregloEventos = [[NSMutableArray alloc] initWithCapacity:5];
    
    maListaClases = [[NSMutableArray alloc]initWithCapacity:5];
    [self.lbNomUsu setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"NOMBRE"]];
    
    self.viewMenu.layer.cornerRadius = 30;
    self.viewMenu.layer.masksToBounds = true;
    
    arregloMenu = [[NSMutableArray alloc]initWithCapacity:3];
    
    [arregloMenu addObject:@"Conócenos"];
    [arregloMenu addObject:@"Paquetes"];
    [arregloMenu addObject:@"Horarios"];
    [arregloMenu addObject:@"Nuestras clases"];
    [arregloMenu addObject:@"Salones"];
    [arregloMenu addObject:@"Ubícanos"];
    [arregloMenu addObject:@"Galería"];
    [arregloMenu addObject:@"Log out"];
    [arregloMenu addObject:@"Eliminar cuenta"];
    
    self.viewMenu.backgroundColor = [UIColor whiteColor];
    self.viewMenu.opaque = NO;
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    //[self llenarLista];
    //[self descargaDatos];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:7];
    maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setDay:0];
    minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];

}




-(void)llenarLista{
    
    
    
    DatosClases* clase = [DatosClases alloc];
    clase.nomMaestro = @"Juan Perez";
    clase.tipoClase = @"Rocket";
    clase.horario = @"17:00";
    clase.nomIcono = @"am";
    
    [maListaClases addObject:clase];
    
    clase = [DatosClases alloc];
    clase.nomMaestro = @"Diana Cazares";
    clase.tipoClase = @"TRX";
    clase.horario = @"14:00";
    clase.nomIcono = @"lau";
    
    [maListaClases addObject:clase];
    
    NSLog(@"Tamaño Arreglo %lu",maListaClases.count);
    
}

#pragma mark - Conexiones

-(void)cancelarClase:(NSString*)idClaseSel:(NSString*)fechaClase{
    
    MBProgressHUD* progresoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    progresoHud.mode = MBProgressHUDModeIndeterminate;
    progresoHud.label.text = @"Cancelando clase";
    
    NSString* url = [NSString stringWithFormat:@"https://www.actinseguro.com/Booking/abkcom009.aspx?%@,%@,%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],idClaseSel,fechaClase];

    NSLog(@"URL %@",url);
    //NSError* errorJS;
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSString* respuestaJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSLog(@"%@",respuestaJson);
        
        NSError* errorJson;
        
        NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
        
        NSArray* respuestaArreglo = [jsonObject objectForKey:@"CLASE_CANCELADA"];
        
        jsonObject = [respuestaArreglo objectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"CLASE_ACCION"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    
                    
                }];
                [alertController addAction:aceptar];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            });
            
        
    }];
    
    
    [urlSession resume];
}


-(void)descargaDatos{
    
    MBProgressHUD* progreso = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progreso.mode = MBProgressHUDModeIndeterminate;
    progreso.label.text = @"Consultando clases reservadas";
    
    NSString* url = [NSString stringWithFormat:@"https://actinseguro.com/booking/abkcom008.aspx?%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
    
    NSLog(@"URL a descargar %@",url);
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            
            NSString* respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",respuesta);
            
            NSError* errorJson;
            DatosClases* clase;
            
            NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
            
            [self->maListaClases removeAllObjects];
            //NSDictionary* arregloPrincipal = [jsonObject objectForKey:@"DATA"];
            
            bool siHayClases = NO;
            NSArray* arregloClases = [jsonObject objectForKey:@"CLASES_RESERVADAS"];
            
            for (int x = 0; x < arregloClases.count; x++) {
                
                NSDictionary* objClases = [arregloClases objectAtIndex:x];
                
                if ([[objClases valueForKey:@"CIA"] isEqual:@"No Hay Clases registradas"]) {
                    
                    siHayClases = NO;
                    break;
                    
                }else{
                    
                    siHayClases = YES;
                    clase = [DatosClases alloc];
                    clase.nomMaestro = [objClases valueForKey:@"CLASE_RESPONSABLE"];
                    clase.tipoClase = [objClases valueForKey:@"CLASE_NOMBRE"];
                    clase.horario = [objClases valueForKey:@"CLASE_HORARIO"];
                    clase.fecha = [objClases valueForKey:@"CLASE_DIA"];
                    
                    [self->arregloEventos addObject:[objClases valueForKey:@"CLASE_DIA"]];
                    
                    clase.idClase = [objClases valueForKey:@"CLASE_ID_CLASE"];
                    
                    if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"OLGA BELICHKO"]) {
                        clase.nomIcono = @"olga_belichko.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"YURI CIENFUEGOS"]) {
                        clase.nomIcono = @"yuri_cien.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"LAURA"]) {
                        clase.nomIcono = @"laura.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"ADRIANA GARIBAY"]) {
                        clase.nomIcono = @"adri_gari_vaz.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"JUAN CALDERON"]) {
                        clase.nomIcono = @"juan_cald.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"SYLVIA MONSALVE"]) {
                        clase.nomIcono = @"sylvia_mons.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"BRIGGITE SCHEPERS"]) {
                        clase.nomIcono = @"brig_sche.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"LILIANA TORRIJOS"]) {
                        clase.nomIcono = @"liliana_torrijos.png";
                    }else if ([[objClases valueForKey:@"CLASE_RESPONSABLE"] isEqual:@"GIAN FRANCO"]) {
                        clase.nomIcono = @"gian_franco.png";
                    }else{
                        
                        clase.nomIcono = @"";
                    }
                    //clase.nomIcono = @"";
                    
                    [self->maListaClases addObject:clase];
                }
                
                //NSLog(@"Clases %@", [objClases valueForKey:@"CLASE_NOMBRE"]);
            }
            
            self->maFiltroClases = [self->maListaClases mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionClases reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (!siHayClases) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@""] message:[NSString stringWithFormat:@"No tiene clases registradas"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                        
                    }];
                    [alertController addAction:aceptar];
                    
                    [self presentViewController:alertController animated:true completion:nil];
                }
                
                
            });
            
        }
        
    }];
    
    [urlSession resume];
    
}

-(void)eleminarCuenta{
    
    MBProgressHUD* progreso = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progreso.mode = MBProgressHUDModeIndeterminate;
    progreso.label.text = @"Eliminando Cuenta";
    
    NSString* url = [NSString stringWithFormat:@"https://www.actinseguro.com/booking/abkcom014.aspx?%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
    
    NSLog(@"URL a eliminar %@",url);
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            
            NSString* respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",respuesta);
            
            NSError* errorJson;
        
            
            NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
            
            NSString* respElimina = [jsonObject valueForKey:@"MSG"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if ([respElimina isEqual:@"EL USUARIO HA SIDO ELIMINADO"]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@""] message:[NSString stringWithFormat:@"Su cuenta ha sido eliminada"] preferredStyle:UIAlertControllerStyleAlert];
                    
                
                    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                        [self.presentingViewController  dismissViewControllerAnimated:NO completion:nil];
                        
                    }];
                    [alertController addAction:aceptar];
                    
                    [self presentViewController:alertController animated:true completion:nil];
                }else{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@""] message:[NSString stringWithFormat:@"Ocurrio un problema al eliminar su cuenta, consulte con soporte técnico"] preferredStyle:UIAlertControllerStyleAlert];
                    
                
                    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                                            
                    }];
                    [alertController addAction:aceptar];
                    
                    [self presentViewController:alertController animated:true completion:nil];
                }
                
            });
            
        }
        
    }];
    
    [urlSession resume];
    
}

#pragma mark - Metodos de Collection

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return maListaClases.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CcClases* celdaClases = [collectionView dequeueReusableCellWithReuseIdentifier:@"celdaClases" forIndexPath:indexPath];
    
    if (!celdaClases) {
        
        celdaClases = [[CcClases alloc] init];
    }
    
    DatosClases* datos = [maListaClases objectAtIndex:indexPath.row];
    
    //NSLog(@"Se mostraran los datos %@",datos.nomMaestro);
    celdaClases.lbNomMaestro.text = datos.tipoClase;
    celdaClases.lbTipoClase.text = datos.nomMaestro;
    celdaClases.lbFechaClase.text = datos.fecha;
    celdaClases.lbHorario.text = datos.horario;
    celdaClases.ivFondoCell.image = [UIImage imageNamed:datos.nomIcono];
    
    return celdaClases;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return CGSizeMake(350,150);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DatosClases* datos = [maListaClases objectAtIndex:indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"¿Cancelar clase?"] message:[NSString stringWithFormat:@"¿Deseas cancelar la clase de %@ con el profesor(a) %@ el día %@?",datos.tipoClase,datos.nomMaestro,datos.fecha] preferredStyle:UIAlertControllerStyleAlert];
    //[alertController setValue:controller forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

    }];
    [alertController addAction:cancelAction];
    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self cancelarClase:datos.idClase:datos.fecha];
        
        //NSLog(@"%@", [NSString stringWithFormat:@"%@ Salon %@",clases.idClase,self->idSalon]);
        
        //[self reservarClase:[NSString stringWithFormat:@"%@",clases.idClase] :[NSString stringWithFormat:@"%@",self->idSalon]:[NSString stringWithFormat:@"%@",self.lbFecha.text]];
        
    }];
    [alertController addAction:aceptar];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}


#pragma mark - Metodos TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arregloMenu.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        

    }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Galería"]){
        
        [self performSegueWithIdentifier:@"segueGale" sender:self];
        

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
        
    }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Eliminar cuenta"]){
        
        //exit(0);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Eliminar cuenta"] message:[NSString stringWithFormat:@"Una vez que acepte se eliminaran sus datos junto con sus clases reservadas ¿Desea continuar con la eliminación de su cuenta?"] preferredStyle:UIAlertControllerStyleAlert];
        //[alertController setValue:controller forKey:@"contentViewController"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        }];
        [alertController addAction:cancelAction];
        UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            [self eleminarCuenta];
            
        }];
        [alertController addAction:aceptar];
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }
    
    [self escondeAccion];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemMenu" forIndexPath:indexPath];
    
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
        
    }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Galería"]){
        
        cell.imageView.image = [UIImage imageNamed:@"galeria.png"];
        
    }else if([[arregloMenu objectAtIndex:indexPath.row] isEqual:@"Eliminar cuenta"]){
        
        cell.imageView.image = [UIImage imageNamed:@"eliminar_cuenta.png"];
        
    }else{
        
        cell.imageView.image = [UIImage imageNamed:@"logout"];
    }
    
    
    
    return cell;
}

#pragma mark - Calendario

- (IBAction)btnCalen:(id)sender {
    
    [self mostrarCalendario];
}

-(void)mostrarCalendario{
    
    
    //UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    rect = CGRectMake(0, 0, 420, 500);
    //[controller setPreferredContentSize:rect.size];
    
    self.calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    //FSCalendar *calendar = [[FSCalendar alloc]init];
    
    
    //[self.view addSubview:calendar];
    //self.calendar = calendar;
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
   
    self.calendar.translatesAutoresizingMaskIntoConstraints = false;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    //[alertController setValue:controller forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    }];
    [alertController addAction:cancelAction];

    
    [alertController.view addSubview:self.calendar];
    
    [alertController.view.heightAnchor constraintEqualToConstant:500].active = YES;
    
    [self.calendar.centerYAnchor constraintEqualToAnchor: alertController.view.centerYAnchor].active = YES;
    
    [self.calendar.centerXAnchor constraintEqualToAnchor: alertController.view.centerXAnchor].active = YES;
    
    [self.calendar.heightAnchor constraintEqualToConstant:400].active = YES;
    [self.calendar.widthAnchor constraintEqualToConstant:alertController.view.frame.size.width].active = YES;
    
    /*[self.calendar.leadingAnchor constraintEqualToAnchor:alertController.view.leadingAnchor].active = YES;
    [self.calendar.trailingAnchor constraintEqualToAnchor:alertController.view.trailingAnchor].active = YES;
    [self.calendar.topAnchor constraintEqualToAnchor:alertController.view.topAnchor constant:10].active = YES;*/
    
    
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    self.calendar.today = nil;
    self.calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    
    [self presentViewController:alertController animated:YES completion:nil];
        
    
    
    //NSLog(@"Se presiono Fecha");

    
}


/*- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate*)date
{
    //NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];

    //NSDate *currentDate = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString* dateString = [formatter stringFromDate:date];
    
    NSLog(@"Fecha %@",dateString);
    //[arregloEventos addObject:@"2022-11-02"];
    
    if ([arregloEventos containsObject:dateString]){
        return 1;
    }
    else{
        NSLog(@"........Events List........");
    }
    return 0;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    cell.eventIndicator.transform = CGAffineTransformScale(cell.eventIndicator.transform, 5, 5);
    
}*/

-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    
    NSString* dateString = [self.dateFormatter stringFromDate:date];
    
    if ([arregloEventos containsObject:dateString]){
        return UIColor.redColor;
    }
    
    return nil;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return minDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return maxDate;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    //NSLog(@"should select date %@",[self.dateFormatter stringFromDate:date]);
    [self filtro:[self.dateFormatter stringFromDate:date]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

-(void)filtro:(NSString*) fechaFiltro{
    
    if (fechaFiltro.length == 0) {
        
        maListaClases = [maFiltroClases mutableCopy];
    
    }else{
        
        [maListaClases removeAllObjects];
        
        for (DatosClases* datos in maFiltroClases) {
            
            if ([datos.fecha isEqualToString:fechaFiltro]) {
                
                [maListaClases addObject:datos];
            }
        }
        
    }
    
    [self.collectionClases reloadData];
    
}


#pragma mark - Menu

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


- (IBAction)btnMenu:(id)sender {
    
    [self menuCustom];
    
}


#pragma mark - Metodos de vista

-(void)viewWillAppear:(BOOL)animated{
    
    if (!self.viewMenu.isHidden) {
        
        [self.viewFondo setHidden:YES];
        [self.viewMenu setHidden:YES];
    }
    
    menuAbierto = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self descargaDatos];
    //NSLog(@"Se ha cargad la vista");
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
