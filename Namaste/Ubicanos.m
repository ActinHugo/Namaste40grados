//
//  Ubicanos.m
//  Namaste
//
//  Created by Alejandro Rodas on 02/08/22.
//

#import "Ubicanos.h"

@interface Ubicanos ()

@end

@implementation Ubicanos{
    
    bool selecEsme,selecPalma;
    NSString* coordEsme;
    NSString* coordPalm;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    selecEsme = YES;
    selecPalma = NO;
    
    coordEsme = @"19.552424372458333, -99.27089532147968";
    coordPalm = @"19.393147, -99.281823";
    
    self.viewDireccion.layer.cornerRadius = 20;
    self.viewDireccion.layer.masksToBounds = true;
    
    self.ivMapa.layer.cornerRadius = 20;
    self.ivMapa.layer.masksToBounds = true;
    
    self.ivMapa.layer.borderWidth = 1.0;
    self.ivMapa.layer.borderColor = [[UIColor colorWithRed:47.0/255.0 green:184.0/255.0 blue:255.0/255.0 alpha:1.0]CGColor];
    
    self.ivWaze.layer.cornerRadius = 20;
    self.ivWaze.layer.masksToBounds = true;
    
    self.ivWaze.layer.borderWidth = 1.0;
    self.ivWaze.layer.borderColor = [[UIColor colorWithRed:47.0/255.0 green:184.0/255.0 blue:255.0/255.0 alpha:1.0]CGColor];
    
    [self datosEsmeralda];
    
}

-(void)seleccionEsmeralda{
    
    if (!selecEsme) {
        
        [self datosEsmeralda];
        
    }
}

-(void)datosEsmeralda{
    
    self.lbTituloDir.text = @"Zona Esmeralda";
    self.lbEstado.text = @"(Estado de México)";
    self.lbDireccion.text = @"Av. Adolfo Ruiz Cortines #247, Lomas de Atizapan, 52977 Cd López Mateos, Méx. México";
    [self.lbDireccion sizeToFit];
}

-(void)datosInterlomas{
    
    self.lbTituloDir.text = @"Próximamente";
    self.lbEstado.text = @"";
    self.lbDireccion.text = @"";
    [self.lbDireccion sizeToFit];
}

#pragma mark - Acciones

- (IBAction)btnPalm:(id)sender {
    
    if (!selecPalma) {
        [sender setImage:[UIImage imageNamed:@"proximamente_on"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [self.ivEsme setImage:[UIImage imageNamed:@"esmeralda_off"] forState:UIControlStateNormal];
        [self.ivEsme setSelected:NO];
        selecEsme = NO;
        selecPalma = YES;
        [self.ivWaze setEnabled:NO];
        [self.ivMapa setEnabled:NO];
        [self datosInterlomas];
    }
}

- (IBAction)btnEsme:(id)sender {
    
    if (!selecEsme) {
        [sender setImage:[UIImage imageNamed:@"esmeralda_on"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [self.ivPalma setImage:[UIImage imageNamed:@"proximamente_off"] forState:UIControlStateNormal];
        [self.ivPalma setSelected:NO];
        selecEsme = YES;
        selecPalma = NO;
        [self.ivWaze setEnabled:YES];
        [self.ivMapa setEnabled:YES];
        [self datosEsmeralda];
    }/*else{
        [sender setImage:[UIImage imageNamed:@"esmeralda_off"] forState:UIControlStateSelected];
        [sender setSelected:NO];
        selecEsme = NO;
    }*/

}

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}


- (IBAction)btnMapa:(id)sender {
    
    if (selecEsme) {
        
        NSURL *appleURL = [NSURL URLWithString:@"http://maps.apple.com/?daddr=19.552424372458333,-99.27089532147968"];

        if ([[UIApplication sharedApplication] canOpenURL:appleURL]) {
                [[UIApplication sharedApplication] openURL:appleURL
                                                   options:@{}
                                         completionHandler:^(BOOL success){
                                         }];
                return;
            }
        
    }
    
    if(selecPalma){
        
        NSURL *appleURL = [NSURL URLWithString:@"http://maps.apple.com/?daddr=19.393147,-99.281823"];

        if ([[UIApplication sharedApplication] canOpenURL:appleURL]) {
                [[UIApplication sharedApplication] openURL:appleURL
                                                   options:@{}
                                         completionHandler:^(BOOL success){
                                         }];
                return;
            }
    }
    
}
- (IBAction)btnWaze:(id)sender {
    
    if (selecEsme) {
        
        NSURL *wazeURL = [NSURL URLWithString:@"https://waze.com/ul?ll=19.552424372458333,-99.27089532147968&navigate=yes"];

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
                [[UIApplication sharedApplication] openURL:wazeURL
                                                   options:@{}
                                         completionHandler:^(BOOL success){
                                         }];
                return;
        }else{
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]
                                               options:@{}
                                     completionHandler:^(BOOL success){
                                     }];
            
            /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"WAZE"] message:[NSString stringWithFormat:@"No se tiene instalado la aplicación de waze"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                [self.presentingViewController  dismissViewControllerAnimated:NO completion:nil];
                
            }];
            [alertController addAction:aceptar];
            
            [self presentViewController:alertController animated:true completion:nil];*/
        }
        
    }
    
    if(selecPalma){
        
        NSURL *wazeURL = [NSURL URLWithString:@"https://waze.com/ul?ll=19.393147,-99.281823&navigate=yes"];

        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
                [[UIApplication sharedApplication] openURL:wazeURL
                                                   options:@{}
                                         completionHandler:^(BOOL success){
                                         }];
                return;
        }else{
                
               /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"WAZE"] message:[NSString stringWithFormat:@"No se tiene instalado la aplicación de waze"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    [self.presentingViewController  dismissViewControllerAnimated:NO completion:nil];
                    
                }];
                [alertController addAction:aceptar];
                
                [self presentViewController:alertController animated:true completion:nil];*/
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]
                                               options:@{}
                                     completionHandler:^(BOOL success){
                                     }];
        }
    }
    
    
}


#pragma mark - Cambio de estilo
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDarkContent;
}
@end
