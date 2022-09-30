//
//  TabQr.m
//  Namaste
//
//  Created by Alejandro Rodas on 02/07/22.
//

#import "TabQr.h"
#import "UIImage+MDQRCode.h"
#import "Salones.h"
#import "MBProgressHUD.h"


@interface TabQr ()

@end

@implementation TabQr{
    
    NSMutableArray* arregloMenu;
    bool menuAbierto;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuAbierto = NO;
    [self.lbNombUsu setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"NOMBRE"]];
    
    self.ivQr.image = [UIImage mdQRCodeForString:[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"] size:self.ivQr.bounds.size.width fillColor:[UIColor darkGrayColor]];
    
    //UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewMenu.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(20.0, 20.0)];
    
    /*CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.viewMenu.layer.mask = maskLayer;*/
    
    //self.viewMenu.translatesAutoresizingMaskIntoConstraints = YES;
    
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
    

    NSString* pdf = [[NSUserDefaults standardUserDefaults] objectForKey:@"ANUNCIO"];
    
    //NSLog(@"%@",pdf);
    
    if(![pdf isEqualToString:@""]){
        
        
        [self performSegueWithIdentifier:@"seguePdf" sender:self];
        
    }
    
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

/*-(void) menu{
    
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    rect = CGRectMake(0, 0, 272, 700);
    [controller setPreferredContentSize:rect.size];
    
    self.tvMenu  = [[UITableView alloc]initWithFrame:rect];
    self.tvMenu.delegate = self;
    self.tvMenu.dataSource = self;
    //self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tvMenu setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tvMenu setTag:1];
    [self.tvMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellReser"];
    [controller.view addSubview:self.tvMenu];
    [controller.view bringSubviewToFront:self.tvMenu];
    [controller.view setUserInteractionEnabled:YES];
    [self.tvMenu setUserInteractionEnabled:YES];
    [self.tvMenu setAllowsSelection:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

    }];
    //[alertController addAction:cancelAction];
    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    
        
    }];
    //[alertController addAction:aceptar];
    [self presentViewController:alertController animated:YES completion:nil];
    
}*/

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (menuAbierto) {
        return UIStatusBarStyleDarkContent;
    }
    
    return UIStatusBarStyleLightContent;
}



#pragma mark - TableView

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
        
    }else{
        
        cell.imageView.image = [UIImage imageNamed:@"logout"];
    }
    
    
    
    return cell;
}


- (IBAction)esconderMenu:(id)sender{
    
    [self escondeAccion];
    
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
    
    [self descargaPaquetes];

    //NSLog(@"Se ha cargad la vista");
}

#pragma mark - Conexiones

-(void)descargaPaquetes{
    
    /*MBProgressHUD* progreso = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progreso.mode = MBProgressHUDModeIndeterminate;
    progreso.label.text = @"Consultando paquete";*/
    
    NSString* url = [NSString stringWithFormat:@"https://www.actinseguro.com/booking/abkcom011.aspx?%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
    
    NSLog(@"URL a descargar %@",url);
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            
            NSString* respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",respuesta);
            
            NSError* errorJson;
        
            
            NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
            
            
            NSArray* arregloClases = [jsonObject objectForKey:@"PAQUETE"];
            
            NSDictionary* objClases = [arregloClases objectAtIndex:0];
            
            NSString* nomPaquete = [objClases valueForKey:@"PAQUETE"];
            NSString* clasesRes = [objClases valueForKey:@"CLASES_RESTANTES"];
         
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (![clasesRes isEqualToString:@""]) {
                    
                    NSInteger numeroClases = [clasesRes integerValue];
                    
                    if (numeroClases > 0) {
                        
                        self.lbClasesRes.text = [NSString stringWithFormat:@"Te quedan %ld clase(s) de tu paquete %@",(long)numeroClases,nomPaquete];
                    }else{
                        
                        self.lbClasesRes.text = @"No tiene paquete contratado";
                    }
                    
                }else{
                    
                    self.lbClasesRes.text = @"No tiene paquete contratado";
                }
                
                
                
                
                
                
            });
            
        }
        
    }];
    
    [urlSession resume];
    
}
@end
