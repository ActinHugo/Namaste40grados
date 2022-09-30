//
//  AltaUsuarios.m
//  Namaste
//
//  Created by Alejandro Rodas on 07/07/22.
//

#import "AltaUsuarios.h"
#import "MBProgressHUD.h"

@interface AltaUsuarios ()

@end

@implementation AltaUsuarios

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconocerTap:)];
        self.tgr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:self.tgr];
    
}

- (void)reconocerTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}

#pragma mark - Delegates TextField

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger nsuTamaño = [textField.text length] + [string length] - range.length;
    
    if (textField.tag == 1) {
        
        return (nsuTamaño > 80) ? NO:YES;
        
    }else if(textField.tag == 2){
            
        
        return (nsuTamaño > 50) ? NO:YES;
    }else if(textField.tag == 2){
        
        
        return (nsuTamaño > 20) ? NO:YES;
    }else{
        
        return (nsuTamaño > 10) ? NO:YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UIResponder* resp = [textField.superview viewWithTag:textField.tag + 1];
    
    if (resp) {
        
        [resp becomeFirstResponder];
    }else{
        [resp resignFirstResponder];
    }
    
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 2) {
        
        if(![self validarCorreoAlta:textField.text]){
         
            UIAlertController* alertaControl = [UIAlertController alertControllerWithTitle:@"No es un correo valido" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertaControl addAction:alertAction];
            
            
            [self presentViewController:alertaControl animated:true completion:nil];
        }
    }
}

#pragma mark - validar email

-(BOOL) validarCorreoAlta:(NSString*)email{
    NSString* emailDatos = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailValidar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailDatos];
    return [emailValidar evaluateWithObject:email];
    
}

#pragma mark - Conexiones

-(void)registrarUsuario{
    
    MBProgressHUD* progresoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    progresoHud.mode = MBProgressHUDModeIndeterminate;
    progresoHud.label.text = @"Registrando";
    
    NSString* url = @"http://actinseguro.com/booking/abkcom002.aspx";
    
    NSDictionary* json = @{ @"CIA": [[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],
                            @"NOMBRE": self.nombre.text,
                            @"CORREO" : self.correo.text,
                            @"TELEFONO" : self.telefono.text,
                            @"PAQUETE" : @"",
                            @"PASSWORD" : self.pass.text
    };
    
    /*NSArray *titulos = [NSArray arrayWithObjects:
                        @"CIA",
                        @"NOMBRE",
                        @"CORREO",
                        @"TELEFONO",
                        @"PAQUETE",
                        @"PASSWORD",
                        nil];
    
    
    
    NSMutableArray *datos = [[NSMutableArray alloc]
                             initWithObjects:
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],
                             self.nombre.text,
                             self.correo.text,
                             self.telefono.text,
                             @"",
                             self.pass.text,
                             nil];*/
    
    
    /*NSMutableArray *datos = [[NSMutableArray alloc]
                             initWithObjects:
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"CIA"],
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             nil];*/
    //NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:datos forKeys:titulos];
    NSError* errorJS;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&errorJS];
    
    if (errorJS) {
        NSLog(@"Error al formar JsonAlta %@",errorJS);
    }
    
    NSString* respuesta = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"JSON %@",respuesta);
    
    NSData* cuerpoPost = [respuesta dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:cuerpoPost];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSString* respuestaJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSLog(@"%@",respuestaJson);
        
        NSError* errorJson;
        
        NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        
        if ([[jsonObject valueForKey:@"MSG"] isEqual:@"Ya existe el correo"])  {
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                
                UIAlertController* alertaControl = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:@"El correo %@ ya se encuentra registrado",self.correo.text]message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertaControl addAction:alertAction];
                
                [self presentViewController:alertaControl animated:true completion:nil];
                
            });
        }else{
            
            NSArray * resultadoSep = [[jsonObject valueForKey:@"MSG"] componentsSeparatedByString:@":"];
            
            if (resultadoSep.count == 2) {
                
                NSLog(@"%@",[resultadoSep objectAtIndex:1]);
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.correo.text forKey:@"CORREO"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.nombre.text forKey:@"NOMBRE"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.telefono.text forKey:@"TELEFONO"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PAQUETE"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CIA"];
                    [[NSUserDefaults standardUserDefaults] setObject:[resultadoSep objectAtIndex:1] forKey:@"ID"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.pass.text forKey:@"PASSWORD"];
                    
                    
                    [self performSegueWithIdentifier:@"segUsuCreado" sender:self];
                });
                
                
            }
            
            
        }
        
        
        
    }];
    
    
    [dataTask resume];
    

    
}


#pragma mark - Acciones

- (IBAction)btnCerrar:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}



- (IBAction)btnCrear:(UIButton *)sender {
    
    
    if ([self.nombre.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length != 0 &&
        [self.correo.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length != 0 &&
        [self.pass.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length != 0 &&
        [self.telefono.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length != 0) {
        
        
        [self registrarUsuario];
        
    }else{
        
        UIAlertController* alertaControl = [UIAlertController alertControllerWithTitle:@"Todos los campos son obligaorios" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertaControl addAction:alertAction];
        
        [self presentViewController:alertaControl animated:true completion:nil];
    }
    
    
    
    
}
@end
