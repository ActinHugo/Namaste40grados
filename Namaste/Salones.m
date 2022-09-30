//
//  Salones.m
//  Namaste
//
//  Created by Alejandro Rodas on 02/08/22.
//

#import "Salones.h"

@interface Salones ()


@end

@implementation Salones{
    
    NSString* salonSelec;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ivReservar.layer.cornerRadius = 15;
    self.ivReservar.layer.masksToBounds = true;
    
    self.ivReservar.layer.borderWidth = 1.0;
    self.ivReservar.layer.borderColor = [[UIColor colorWithRed:115.0/255.0 green:35.0/255.0 blue:38.0/255.0 alpha:1.0]CGColor];
    
    salonSelec = @"caliente";
    
    [self setNeedsStatusBarAppearanceUpdate];
}



- (IBAction)btnSalida:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnReservar:(id)sender {
    
    if ([salonSelec isEqualToString:@"caliente"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"SALÓN CALIENTE" forKey:@"reservar"];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"SALÓN TRADICIONAL" forKey:@"reservar"];

    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    
}

-(IBAction)swipeDerecha:(id)sender{
    
    self.ivSalon.image = [UIImage imageNamed:@"s_caliente.png"];
    self.ivSeleccion.image = [UIImage imageNamed:@"boton_caliente.png"];
    self.lbDescripcion.text = @"¿Cómo funciona el Salón Caliente?... Es un salón especialmente climatizado a 40 grados de temperatura y 40% de humedad. Que ayuda a estirar y calentar los músculos de manera segura y poder profundizar más en los asanas.";
    
}

-(IBAction)swipeIzquierda:(id)sender{
    
    self.ivSalon.image = [UIImage imageNamed:@"s_tradicional.png"];
    self.ivSeleccion.image = [UIImage imageNamed:@"boton_tradicional.png"];
    self.lbDescripcion.text = @"Es un salón acondicionado para la práctica de las diferentes disciplinas del yoga, como Antigravity, Hatha y Yoga Kids, todas ellas a temperatura ambiente.";
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
@end
