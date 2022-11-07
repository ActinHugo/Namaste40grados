//
//  Horarios.m
//  Namaste
//
//  Created by Alejandro Rodas on 02/08/22.
//

#import "Horarios.h"
#import "MBProgressHUD.h"
#import "DatosHorarios.h"
#import "DatosDiasHorario.h"

@interface Horarios ()

@end

@implementation Horarios{
    
    NSMutableArray* arregloHorarios;
    UIColor* colorRojo;
    UIColor* colorGris;
    NSDateFormatter* dateForma;
    NSDateFormatter* dateDias;
    NSMutableArray<NSDate*> *semana;
    
    NSMutableArray* arregloLunes;
    NSMutableArray* arregloMartes;
    NSMutableArray* arregloMiercoles;
    NSMutableArray* arregloJueves;
    NSMutableArray* arregloViernes;
    NSMutableArray* arregloSabado;
    NSMutableArray* arregloDomingo;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arregloHorarios = [[NSMutableArray alloc]initWithCapacity:5];
    
    arregloLunes = [[NSMutableArray alloc]initWithCapacity:5];
    arregloMartes = [[NSMutableArray alloc]initWithCapacity:5];
    arregloMiercoles = [[NSMutableArray alloc]initWithCapacity:5];
    arregloJueves = [[NSMutableArray alloc]initWithCapacity:5];
    arregloViernes = [[NSMutableArray alloc]initWithCapacity:5];
    arregloSabado = [[NSMutableArray alloc]initWithCapacity:5];
    arregloDomingo = [[NSMutableArray alloc]initWithCapacity:5];
    
    colorRojo = [UIColor colorWithRed:182/255.0 green:56/255.0 blue:32/255.0 alpha:1.0];
    colorGris = [UIColor colorWithRed:224/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    
    self.btnDom.layer.cornerRadius = 15;
    self.btnDom.layer.masksToBounds = true;
    
    dateForma = [[NSDateFormatter alloc]init];
    dateForma.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    [dateForma setDateFormat:@"dd/MM/yyyy"];
    
    dateDias = [[NSDateFormatter alloc]init];
    dateDias.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    [dateDias setDateFormat:@"EEEE"];
    
    [self calcularFecha];
    [self descargarHorario];
    
}

#pragma mark - Conexiones

-(void)descargarHorario{
    
    MBProgressHUD* progresoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    progresoHud.mode = MBProgressHUDModeIndeterminate;
    progresoHud.label.text = @"Descargando Horario";
    
    NSString* url = [NSString stringWithFormat:@"http:www.actinseguro.com/booking/abkcom005.aspx?%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"]];
    
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSString* respuesta = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Link  %@",respuesta);
        [self->arregloHorarios removeAllObjects];
        
        [self->arregloLunes removeAllObjects];
        [self->arregloMartes removeAllObjects];
        [self->arregloMiercoles removeAllObjects];
        [self->arregloJueves removeAllObjects];
        [self->arregloViernes removeAllObjects];
        [self->arregloSabado removeAllObjects];
        [self->arregloDomingo removeAllObjects];
        
        
        if (data != nil) {
            NSError* errorJson;
            
            NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
            
            NSArray* arreglo = [jsonObject objectForKey:@"CLASES_POR_SALON_LUGAR"];
            NSDictionary* objHor;
            DatosHorarios* datosHorarios;
            
            //NSLog(@"Nombre Salones  %lu",(unsigned long)[arreglo count]);
            
            for (int x = 0; x < arreglo.count; x++) {
                
                objHor = [arreglo objectAtIndex:x];
                NSLog(@"Nombre  %@",[objHor valueForKey:@"CLASE_DIAS"]);
                datosHorarios = [DatosHorarios alloc];
                datosHorarios.idclase =[objHor valueForKey:@"CLASE_ID_CLASE"];
                datosHorarios.nomclase =[objHor valueForKey:@"CLASE_NOMBRE"];
                datosHorarios.dias =[objHor valueForKey:@"CLASE_DIAS"];
                datosHorarios.salon =[objHor valueForKey:@"CLASE_SALON_LUGAR"];
                datosHorarios.horario =[objHor valueForKey:@"CLASE_HORARIO"];
                datosHorarios.cupoMax =[objHor valueForKey:@"CLASE_CUPO_MAX"];
                datosHorarios.responsable =[objHor valueForKey:@"CLASE_RESPONSABLE"];
                datosHorarios.idSalon =[objHor valueForKey:@"CLASE_SALON_ID"];
                
                [self->arregloHorarios addObject:datosHorarios];
                
            }
            
            
            if ([self->arregloHorarios count] > 0) {
                
                for (DatosHorarios* datos in self->arregloHorarios) {
                    
                    NSArray* diasSep = [datos.dias componentsSeparatedByString:@","];
                    
                    for (NSString* dia in diasSep) {
                        
                        NSLog(@"Dia  %@",dia);
                        
                        if ([dia isEqualToString:@"L"]) {
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];

                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            [self->arregloLunes addObject:datosDiasHorarios];
                            
                                if ([horaRep isEqualToString:@"06:00am"]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnLun1 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnLun1.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnLun1.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnLun1.titleLabel.numberOfLines = 0;
                                        self.btnLun1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnLun1.backgroundColor = self->colorRojo;
                                            [self.btnLun1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnLun1.backgroundColor = self->colorGris;
                                            [self.btnLun1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                    });
                                    
                                    
                            
                                    
                                }else if ([horaRep isEqualToString:@"07:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                    
                                        
                                        
                                        [self.btnLun2 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnLun2.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnLun2.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnLun2.titleLabel.numberOfLines = 0;
                                        self.btnLun2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnLun2.backgroundColor = self->colorRojo;
                                            [self.btnLun2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnLun2.backgroundColor = self->colorGris;
                                            [self.btnLun2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"08:00am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnLun3 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnLun3.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnLun3.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnLun3.titleLabel.numberOfLines = 0;
                                        self.btnLun3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnLun3.backgroundColor = self->colorRojo;
                                            [self.btnLun3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnLun3.backgroundColor = self->colorGris;
                                            [self.btnLun3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnLun4 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnLun4.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnLun4.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnLun4.titleLabel.numberOfLines = 0;
                                        self.btnLun4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnLun4.backgroundColor = self->colorRojo;
                                            [self.btnLun4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnLun4.backgroundColor = self->colorGris;
                                            [self.btnLun4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"06:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]) {
                                            
                                            [self.btnLun5 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnLun5.titleLabel.font = [UIFont systemFontOfSize:8];
                                            
                                            self.btnLun5.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnLun5.titleLabel.numberOfLines = 0;
                                            self.btnLun5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnLun5.backgroundColor = self->colorGris;
                                            [self.btnLun5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]){
                                            
                                            [self.btnLun51 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnLun51.titleLabel.font = [UIFont systemFontOfSize:8];
                                            self.btnLun51.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnLun51.titleLabel.numberOfLines = 0;
                                            self.btnLun51.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnLun51.backgroundColor = self->colorRojo;
                                            [self.btnLun51 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:30pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnLun6 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnLun6.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnLun6.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnLun6.titleLabel.numberOfLines = 0;
                                        self.btnLun6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnLun6.backgroundColor = self->colorRojo;
                                            [self.btnLun6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnLun6.backgroundColor = self->colorGris;
                                            [self.btnLun6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }
                            
                            
                            
                        }else if ([dia isEqualToString:@"M"]){
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];
                            
                                
                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            [self->arregloMartes addObject:datosDiasHorarios];
                            
                            
                                if ([horaRep isEqualToString:@"06:00am"]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMar1 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMar1.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnMar1.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMar1.titleLabel.numberOfLines = 0;
                                        self.btnMar1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMar1.backgroundColor = self->colorRojo;
                                            [self.btnMar1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMar1.backgroundColor = self->colorGris;
                                            [self.btnMar1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                    });
                                    
                                    
                            
                                    
                                }else if ([horaRep isEqualToString:@"07:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMar2 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMar2.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnMar2.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMar2.titleLabel.numberOfLines = 0;
                                        self.btnMar2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMar2.backgroundColor = self->colorRojo;
                                            [self.btnMar2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMar2.backgroundColor = self->colorGris;
                                            [self.btnMar2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"08:00am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMar3 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMar3.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnMar3.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMar3.titleLabel.numberOfLines = 0;
                                        self.btnMar3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMar3.backgroundColor = self->colorRojo;
                                            [self.btnMar3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMar3.backgroundColor = self->colorGris;
                                            [self.btnMar3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMar4 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMar4.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnMar4.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMar4.titleLabel.numberOfLines = 0;
                                        self.btnMar4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMar4.backgroundColor = self->colorRojo;
                                            [self.btnMar4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMar4.backgroundColor = self->colorGris;
                                            [self.btnMar4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"06:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]) {
                                            
                                            [self.btnMar5 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnMar5.titleLabel.font = [UIFont systemFontOfSize:8];
                                            
                                            self.btnMar5.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnMar5.titleLabel.numberOfLines = 0;
                                            self.btnMar5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnMar5.backgroundColor = self->colorGris;
                                            [self.btnMar5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]){
                                            
                                            [self.btnMar52 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnMar52.titleLabel.font = [UIFont systemFontOfSize:8];
                                            self.btnMar52.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnMar52.titleLabel.numberOfLines = 0;
                                            self.btnMar52.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnMar52.backgroundColor = self->colorRojo;
                                            [self.btnMar52 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:30pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMar6 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMar6.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnMar6.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMar6.titleLabel.numberOfLines = 0;
                                        self.btnMar6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMar6.backgroundColor = self->colorRojo;
                                            [self.btnMar6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMar6.backgroundColor = self->colorGris;
                                            [self.btnMar6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }
                            
                        }else if ([dia isEqualToString:@"W"]){
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];
                            
                                
                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            [self->arregloMiercoles addObject:datosDiasHorarios];
                            
                                if ([horaRep isEqualToString:@"06:00am"]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMier1 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMier1.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnMier1.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMier1.titleLabel.numberOfLines = 0;
                                        self.btnMier1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMier1.backgroundColor = self->colorRojo;
                                            [self.btnMier1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMier1.backgroundColor = self->colorGris;
                                            [self.btnMier1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                    });
                                    
                                    
                            
                                    
                                }else if ([horaRep isEqualToString:@"07:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMier2 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMier2.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnMier2.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMier2.titleLabel.numberOfLines = 0;
                                        self.btnMier2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMier2.backgroundColor = self->colorRojo;
                                            [self.btnMier2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMier2.backgroundColor = self->colorGris;
                                            [self.btnMier2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"08:00am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMier3 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMier3.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnMier3.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMier3.titleLabel.numberOfLines = 0;
                                        self.btnMier3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMier3.backgroundColor = self->colorRojo;
                                            [self.btnMier3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMier3.backgroundColor = self->colorGris;
                                            [self.btnMier3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMier4 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMier4.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnMier4.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMier4.titleLabel.numberOfLines = 0;
                                        self.btnMier4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMier4.backgroundColor = self->colorRojo;
                                            [self.btnMier4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMier4.backgroundColor = self->colorGris;
                                            [self.btnMier4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"06:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]) {
                                            
                                            [self.btnMier5 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnMier5.titleLabel.font = [UIFont systemFontOfSize:8];
                                            
                                            self.btnMier5.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnMier5.titleLabel.numberOfLines = 0;
                                            self.btnMier5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnMier5.backgroundColor = self->colorGris;
                                            [self.btnMier5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]){
                                            
                                            [self.btnMier52 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnMier52.titleLabel.font = [UIFont systemFontOfSize:8];
                                            self.btnMier52.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnMier52.titleLabel.numberOfLines = 0;
                                            self.btnMier52.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnMier52.backgroundColor = self->colorRojo;
                                            [self.btnMier52 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:30pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnMier6 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnMier6.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnMier6.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnMier6.titleLabel.numberOfLines = 0;
                                        self.btnMier6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnMier6.backgroundColor = self->colorRojo;
                                            [self.btnMier6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnMier6.backgroundColor = self->colorGris;
                                            [self.btnMier6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }
                            
                        }else if ([dia isEqualToString:@"J"]){
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];
                            
                                
                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            [self->arregloJueves addObject:datosDiasHorarios];
                            
                                if ([horaRep isEqualToString:@"06:00am"]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnJue1 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnJue1.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnJue1.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnJue1.titleLabel.numberOfLines = 0;
                                        self.btnJue1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnJue1.backgroundColor = self->colorRojo;
                                            [self.btnJue1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnJue1.backgroundColor = self->colorGris;
                                            [self.btnJue1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                    });
                                    
                                    
                            
                                    
                                }else if ([horaRep isEqualToString:@"07:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnJue2 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnJue2.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnJue2.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnJue2.titleLabel.numberOfLines = 0;
                                        self.btnJue2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnJue2.backgroundColor = self->colorRojo;
                                            [self.btnJue2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnJue2.backgroundColor = self->colorGris;
                                            [self.btnJue2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"08:00am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnJue3 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnJue3.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnJue3.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnJue3.titleLabel.numberOfLines = 0;
                                        self.btnJue3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnJue3.backgroundColor = self->colorRojo;
                                            [self.btnJue3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnJue3.backgroundColor = self->colorGris;
                                            [self.btnJue3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnJue4 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnJue4.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnJue4.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnJue4.titleLabel.numberOfLines = 0;
                                        self.btnJue4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnJue4.backgroundColor = self->colorRojo;
                                            [self.btnJue4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnJue4.backgroundColor = self->colorGris;
                                            [self.btnJue4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"06:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]) {
                                            
                                            [self.btnJue5 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnJue5.titleLabel.font = [UIFont systemFontOfSize:8];
                                            
                                            self.btnJue5.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnJue5.titleLabel.numberOfLines = 0;
                                            self.btnJue5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnJue5.backgroundColor = self->colorGris;
                                            [self.btnJue5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]){
                                            
                                            [self.btnJue52 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnJue52.titleLabel.font = [UIFont systemFontOfSize:8];
                                            self.btnJue52.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnJue52.titleLabel.numberOfLines = 0;
                                            self.btnJue52.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnJue52.backgroundColor = self->colorRojo;
                                            [self.btnJue52 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:30pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnJue6 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnJue6.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnJue6.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnJue6.titleLabel.numberOfLines = 0;
                                        self.btnJue6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnJue6.backgroundColor = self->colorRojo;
                                            [self.btnJue6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnJue6.backgroundColor = self->colorGris;
                                            [self.btnJue6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }
                            
                        }else if ([dia isEqualToString:@"V"]){
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];
                            
                                
                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            [self->arregloViernes addObject:datosDiasHorarios];
                            
                                if ([horaRep isEqualToString:@"06:00am"]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnVie1 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnVie1.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnVie1.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnVie1.titleLabel.numberOfLines = 0;
                                        self.btnVie1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnVie1.backgroundColor = self->colorRojo;
                                            [self.btnVie1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnVie1.backgroundColor = self->colorGris;
                                            [self.btnVie1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                    });
                                    
                                    
                            
                                    
                                }else if ([horaRep isEqualToString:@"07:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnVie2 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnVie2.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnVie2.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnVie2.titleLabel.numberOfLines = 0;
                                        self.btnVie2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnVie2.backgroundColor = self->colorRojo;
                                            [self.btnVie2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnVie2.backgroundColor = self->colorGris;
                                            [self.btnVie2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"08:00am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnVie3 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnVie3.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnVie3.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnVie3.titleLabel.numberOfLines = 0;
                                        self.btnVie3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnVie3.backgroundColor = self->colorRojo;
                                            [self.btnVie3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnVie3.backgroundColor = self->colorGris;
                                            [self.btnVie3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnVie4 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnVie4.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnVie4.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnVie4.titleLabel.numberOfLines = 0;
                                        self.btnVie4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnVie4.backgroundColor = self->colorRojo;
                                            [self.btnVie4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnVie4.backgroundColor = self->colorGris;
                                            [self.btnVie4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"06:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]) {
                                            
                                            [self.btnVie5 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnVie5.titleLabel.font = [UIFont systemFontOfSize:8];
                                            
                                            self.btnVie5.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnVie5.titleLabel.numberOfLines = 0;
                                            self.btnVie5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnVie5.backgroundColor = self->colorGris;
                                            [self.btnVie5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]){
                                            
                                            [self.btnVie52 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnVie52.titleLabel.font = [UIFont systemFontOfSize:8];
                                            self.btnVie52.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnVie52.titleLabel.numberOfLines = 0;
                                            self.btnVie52.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnMier52.backgroundColor = self->colorRojo;
                                            [self.btnMier52 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:30pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnVie6 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnVie6.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnVie6.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnVie6.titleLabel.numberOfLines = 0;
                                        self.btnVie6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnVie6.backgroundColor = self->colorRojo;
                                            [self.btnVie6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnVie6.backgroundColor = self->colorGris;
                                            [self.btnVie6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }
                            
                        }else if ([dia isEqualToString:@"S"]){
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];
                            
                                
                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            [self->arregloSabado addObject:datosDiasHorarios];
                            
                                if ([horaRep isEqualToString:@"06:00am"]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnSab1 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnSab1.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnSab1.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnSab1.titleLabel.numberOfLines = 0;
                                        self.btnSab1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnSab1.backgroundColor = self->colorRojo;
                                            [self.btnSab1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnSab1.backgroundColor = self->colorGris;
                                            [self.btnSab1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                    });
                                    
                                    
                            
                                    
                                }else if ([horaRep isEqualToString:@"07:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnSab2 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnSab2.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnSab2.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnSab2.titleLabel.numberOfLines = 0;
                                        self.btnSab2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnSab2.backgroundColor = self->colorRojo;
                                            [self.btnSab2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnSab2.backgroundColor = self->colorGris;
                                            [self.btnSab2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"08:00am"] || [horaRep isEqualToString:@"09:15am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if ([horaRep isEqualToString:@"09:15am"]) {
                                            [self.btnSab3 setTitle:[NSString stringWithFormat:@"%@ %@",horaRep, datos.nomclase] forState:UIControlStateNormal];
                                        }else{
                                            [self.btnSab3 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                        self.btnSab3.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnSab3.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnSab3.titleLabel.numberOfLines = 0;
                                        self.btnSab3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnSab3.backgroundColor = self->colorRojo;
                                            [self.btnSab3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnSab3.backgroundColor = self->colorGris;
                                            [self.btnSab3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:00pm"] || [horaRep isEqualToString:@"11:30am"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if ([horaRep isEqualToString:@"11:30am"]) {
                                            [self.btnSab4 setTitle:[NSString stringWithFormat:@"%@ %@",horaRep, datos.nomclase] forState:UIControlStateNormal];
                                        }else{
                                            [self.btnSab4 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        }
                                        
                                        
                                        self.btnSab4.titleLabel.font = [UIFont systemFontOfSize:8];
                                        self.btnSab4.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnSab4.titleLabel.numberOfLines = 0;
                                        self.btnSab4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnSab4.backgroundColor = self->colorRojo;
                                            [self.btnSab4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnSab4.backgroundColor = self->colorGris;
                                            [self.btnSab4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"06:00pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]) {
                                            
                                            [self.btnSab5 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnSab5.titleLabel.font = [UIFont systemFontOfSize:8];
                                            
                                            self.btnSab5.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnSab5.titleLabel.numberOfLines = 0;
                                            self.btnSab5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnSab5.backgroundColor = self->colorGris;
                                            [self.btnSab5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]){
                                            
                                            [self.btnSab52 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                            self.btnSab52.titleLabel.font = [UIFont systemFontOfSize:8];
                                            self.btnSab52.titleLabel.textAlignment = NSTextAlignmentCenter;
                                            self.btnSab52.titleLabel.numberOfLines = 0;
                                            self.btnSab52.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                            
                                            self.btnSab52.backgroundColor = self->colorRojo;
                                            [self.btnSab52 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                    
                                }else if ([horaRep isEqualToString:@"07:30pm"]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.btnSab6 setTitle:[NSString stringWithFormat:@"%@",datos.nomclase] forState:UIControlStateNormal];
                                        self.btnSab6.titleLabel.font = [UIFont systemFontOfSize:8];
                                        
                                        self.btnSab6.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        self.btnSab6.titleLabel.numberOfLines = 0;
                                        self.btnSab6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                        
                                        if ([datos.salon isEqualToString:@"SALÓN CALIENTE"]) {
                                            self.btnSab6.backgroundColor = self->colorRojo;
                                            [self.btnSab6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        }else if ([datos.salon isEqualToString:@"SALÓN TRADICIONAL"]){
                                            self.btnSab6.backgroundColor = self->colorGris;
                                            [self.btnSab6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                        }
                                        
                                    });
                                    
                                    
                                }
                            
                        }else if ([dia isEqualToString:@"D"]){
                            
                            NSArray* horSep = [datos.horario componentsSeparatedByString:@"-"];
                            
                                
                                NSString* horaRep = [horSep[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                
                            NSLog(@"Hora  %@",horaRep);
                            
                            
                            DatosDiasHorario* datosDiasHorarios = [DatosDiasHorario alloc];
                            
                            datosDiasHorarios.nomclase = datos.nomclase;
                            datosDiasHorarios.hora = horaRep;
                            datosDiasHorarios.responsable = datos.responsable;
                            datosDiasHorarios.idclase = datos.idclase;
                            datosDiasHorarios.idsalon = datos.idSalon;
                            
                            //datosDiasHorarios.nomclase = @"BIRKAM";
                            //datosDiasHorarios.hora = horaRep;
                            //datosDiasHorarios.responsable = @"";
                            //datosDiasHorarios.idclase = @"";
                            //datosDiasHorarios.idsalon = @"2";
                            
                            [self->arregloDomingo addObject:datosDiasHorarios];
     
                        }
                    }
                    
                }
                
                
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
            
            
        }else{
            
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


#pragma mark - Acciones

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)btnLun1Action:(id)sender {
    
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"06:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
    
}
- (IBAction)btnLun2Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"07:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnLun3Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"08:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnLun4Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"07:00pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnLun5Action:(id)sender {
    
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"1"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
    
}
- (IBAction)btnLun6Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"07:30pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnLun51Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloLunes) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"2"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"lunes"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnMar1Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"06:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMar2Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"07:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMar3Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"08:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMar4Action:(id)sender {
    
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"07:00pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMar5Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"1"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMar52Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"2"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMar6Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMartes) {
        
        if ([filtro.hora isEqualToString:@"07:30pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"martes"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnMier1Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"06:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMier2Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"07:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMier3Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"08:00pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMier4Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"07:00pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMier5Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"1"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMier52Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"2"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnMier6Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloMiercoles) {
        
        if ([filtro.hora isEqualToString:@"07:30pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"miércoles"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnJue1Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"06:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnJue2Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"07:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnJue3Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"08:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnJue4Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"07:00pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnJue5Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"]&& [filtro.idsalon isEqualToString:@"1"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnJue52Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"]&& [filtro.idsalon isEqualToString:@"2"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnJue6Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloJueves) {
        
        if ([filtro.hora isEqualToString:@"07:30pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"jueves"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnVie1Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"06:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnVieAction:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"07:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnVie3Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"08:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnVie4Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"07:00pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnVie5Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"1"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnVie52Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"] && [filtro.idsalon isEqualToString:@"2"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnVie6Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloViernes) {
        
        if ([filtro.hora isEqualToString:@"07:30pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"viernes"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnSab1Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"06:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnSab2Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"07:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnSab3Action:(id)sender {
    
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"08:00am"] || [filtro.hora isEqualToString:@"09:15am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnSab4Action:(id)sender {
    
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"07:00pm"] || [filtro.hora isEqualToString:@"11:30am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnSab5Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"]&& [filtro.idsalon isEqualToString:@"1"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnSab52Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"06:00pm"]&& [filtro.idsalon isEqualToString:@"2"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}
- (IBAction)btnSab6Action:(id)sender {
    for (DatosDiasHorario* filtro in arregloSabado) {
        
        if ([filtro.hora isEqualToString:@"07:30pm"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"sábado"] :filtro];
            break;
            
        }
    }
}


- (IBAction)btnDomAction:(id)sender {
    
    for (DatosDiasHorario* filtro in arregloDomingo) {
        
        //if ([filtro.hora isEqualToString:@"10:00am"]) {
            
            [self reservarClaseHorario:[self obtenerFecha:@"domingo"] :filtro];
            break;
            
        //}
    }
}


-(void)calcularFecha{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* fechaInicio = [calendar startOfDayForDate:[NSDate date]];
    semana = [[NSMutableArray alloc] init];
    for (int x = 0; x < 7; x++) {
        [semana addObject:[calendar dateByAddingUnit:NSCalendarUnitDay value:x toDate:fechaInicio options:NSCalendarMatchNextTime]];
    }
    
    //NSDate* today = [NSDate date];
    //NSString* fechaActual = [dateForma stringFromDate:today];
    //NSLog(@"%@",semana);

}

-(NSString*)obtenerFecha:(NSString*) diaSeleccionado{
    
    
    for (int cont = 0; cont < [semana count]; cont++) {
        
        NSDate* dia = semana[cont];
        NSString* fechaActual = [dateDias stringFromDate:dia];

        //NSLog(@"%@ %@",diaSeleccionado,fechaActual);
        
        if ([diaSeleccionado isEqualToString:fechaActual]) {
            
            return [dateForma stringFromDate:dia];
        }
        
    }
    
    return nil;
    
}

-(void)reservarClaseHorario:(NSString*)fecha: (DatosDiasHorario*) clases{
    
    //NSUInteger lugaresDisp = [clases.cupoMax integerValue] - [clases.ocupado integerValue];
    
    //if (lugaresDisp > 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"¿Reservar clase?"] message:[NSString stringWithFormat:@"¿Reservar la clase de %@ con el profesor %@ el día %@?",clases.nomclase,clases.responsable,fecha] preferredStyle:UIAlertControllerStyleAlert];
        //[alertController setValue:controller forKey:@"contentViewController"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        }];
        [alertController addAction:cancelAction];
        UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            //NSLog(@"%@", [NSString stringWithFormat:@"%@ Salon %@",clases.idClase,self->idSalon]);
            
            [self reservarClase:[NSString stringWithFormat:@"%@",clases.idclase] :[NSString stringWithFormat:@"%@",clases.idsalon]:[NSString stringWithFormat:@"%@",fecha]];
            
        }];
        [alertController addAction:aceptar];
        
        [self presentViewController:alertController animated:true completion:nil];
        
        
    /*}else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Clase llena"] message:@"Esta clase ya no tiene lugares disponibles" preferredStyle:UIAlertControllerStyleAlert];
        //[alertController setValue:controller forKey:@"contentViewController"];
        
    
        UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

           
            
        }];
        [alertController addAction:aceptar];
        
        [self presentViewController:alertController animated:true completion:nil];
        
        
    }*/
    
}

@end
