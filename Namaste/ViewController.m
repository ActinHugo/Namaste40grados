//
//  ViewController.m
//  Namaste
//
//  Created by Alejandro Rodas on 23/06/22.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController (){
    

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tfEmail setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"CORREO"]];
    
    /*if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"CORREO"] isEqual:@""]) {
        
        [self Conexiones:[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"]];
        
    }*/
    
    
    if ([self.tfEmail.text length] > 0){
        
        [self.tfPass becomeFirstResponder];
    }else{
        
        [self.tfEmail becomeFirstResponder];
    }
    
    self.tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconocerTap:)];
        self.tgr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:self.tgr];
    
    self.tfEmail.layer.cornerRadius = 15;
    self.tfEmail.layer.masksToBounds = true;
    
    self.tfPass.layer.cornerRadius = 15;
    self.tfPass.layer.masksToBounds = true;
    
    self.btnLoginCustom.layer.cornerRadius = 15;
    self.btnLoginCustom.layer.masksToBounds = true;
    
    self.btnRegisCustom.layer.cornerRadius = 15;
    self.btnRegisCustom.layer.masksToBounds = true;
}

- (void)reconocerTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger nsuTamaño = [textField.text length] + [string length] - range.length;
    
    if (textField.tag == 1) {
        return (nsuTamaño > 50) ? NO : YES;
    }else{
        
        return (nsuTamaño > 20) ? NO : YES;
    }
    
};

- (IBAction)btnRegistrar:(id)sender {
    
    [self performSegueWithIdentifier:@"segAlta" sender:self];
    
}

- (IBAction)btnLogin:(id)sender {
    
    if ([self.tfEmail.text length] > 0 && [self validarCorreo:self.tfEmail.text]) {
        
        if ([self.tfPass.text length] == 0) {
            
            UIAlertController* alertaControl = [UIAlertController alertControllerWithTitle:@"Ingresa la contraseña" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertaControl addAction:alertAction];
            
            [self presentViewController:alertaControl animated:true completion:nil];
            
            [self.tfPass becomeFirstResponder];
            
        }else{
            
            [self Conexiones:self.tfPass.text];
        }
        
        
    }else{
                
        UIAlertController* alertaControl = [UIAlertController alertControllerWithTitle:@"No es un correo valido" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertaControl addAction:alertAction];
        
        [self presentViewController:alertaControl animated:true completion:nil];
    }
    
    
}

#pragma mark - validar email

-(BOOL) validarCorreo:(NSString*)email{
    NSString* emailDatos = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailValidar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailDatos];
    return [emailValidar evaluateWithObject:email];
    
}

#pragma mark - conexiones

-(void)Conexiones:(NSString*) pass{
    
    MBProgressHUD* progreso = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progreso.mode = MBProgressHUDModeIndeterminate;
    progreso.label.text = @"Descargando";
    
    NSString* url = [NSString stringWithFormat:@"http:www.actinseguro.com/booking/abkcom001.aspx?%@,%@",self.tfEmail.text,self.tfPass.text];
    
    NSLog(@"%@",url);
    
    NSURL* urlData = [NSURL URLWithString:url];
    
    NSURLSessionDataTask* urlSession = [[NSURLSession sharedSession] dataTaskWithURL:urlData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",respuesta);
        
        NSError* errorJson;
        
        //bool anuncio = NO;
        
        NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJson];
        
        if ([[jsonObject valueForKey:@"CIA"]isEqual:@"No Encontrado"]) {
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertController* alertaControl = [UIAlertController alertControllerWithTitle:@"Usuario o Password incorrecto, verifica los datos" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertaControl addAction:alertAction];
                
                [self presentViewController:alertaControl animated:true completion:nil];
                
            });
            
            
        }else {
            
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject valueForKey:@"CORREO"] forKey:@"CORREO"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject valueForKey:@"NOMBRE"] forKey:@"NOMBRE"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject valueForKey:@"TELEFONO"] forKey:@"TELEFONO"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject valueForKey:@"PAQUETE"] forKey:@"PAQUETE"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject valueForKey:@"CIA"] forKey:@"CIA"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject valueForKey:@"ID"] forKey:@"ID"];
            [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"PASSWORD"];
            
            NSArray* anuncioArray = [jsonObject objectForKey:@"ANUNCIOS"];

            //NSLog(@"Anuncios %lu",(unsigned long)anuncioArray.count);
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ANUNCIO"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"reservar"];
            
            if (anuncioArray.count > 0) {
                
                NSDictionary* jsonObjAnuncio = [anuncioArray objectAtIndex:0];
                
                //NSLog(@"Anuncio %@",[jsonObjAnuncio valueForKey:@"ANUNCIO"]);
                
                [[NSUserDefaults standardUserDefaults] setObject:[jsonObjAnuncio valueForKey:@"ANUNCIO"] forKey:@"ANUNCIO"];
                
                //anuncio = YES;

            }
            
            
            /*for (int x = 0; x < anuncio.count ; x++) {
                
                NSDictionary* jsonObjAnuncio = [anuncio objectAtIndex:0];
                
                
            }*/
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                self.tfPass.text = @"";
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self performSegueWithIdentifier:@"segPrincipal" sender:self];
                    
                
                
            });
        }
    }];
    
    [urlSession resume];
}
@end
