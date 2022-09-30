//
//  NuestrasClases.m
//  Namaste
//
//  Created by Alejandro Rodas on 18/08/22.
//

#import "NuestrasClases.h"
#import "ObjetoClase.h"

@interface NuestrasClases ()

@end

@implementation NuestrasClases{
    
    NSString* claseSelecc;
    NSMutableArray* arregloClases;
    int posicion;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbNomClase.layer.cornerRadius = 15;
    self.lbNomClase.layer.masksToBounds = true;
    
    self.ivReservar.layer.cornerRadius = 15;
    self.ivReservar.layer.masksToBounds = true;
    
    self.ivReservar.layer.borderWidth = 1.0;
    self.ivReservar.layer.borderColor = [[UIColor colorWithRed:115.0/255.0 green:35.0/255.0 blue:38.0/255.0 alpha:1.0]CGColor];
    
    arregloClases = [[NSMutableArray alloc] initWithCapacity:5];
    posicion = 0;
    
    claseSelecc = @"HOT VINYASA";
    
    [self cargaClases];
    
}

#pragma mark - Carga Datos

-(void)cargaClases{
    
    ObjetoClase* objeto = [ObjetoClase alloc];
    objeto.titulo = @"BIKRAM 60-90";
    objeto.imagen = @"bikram.png";
    objeto.descripcion = @"Bikram 60 y Bikram 90 son el mismo tipo de yoga,.. Bikram Yoga es una variante de Hatha Yoga. La técnica consiste en una combinación de posturas que engloba los beneficios de distintos tipos de yoga, haciendo breves pausas entre postura y postura para alinear tu cuerpo. Durante la clase se desarrolla una secuencia de 26 posturas que se repiten dos veces y 2 ejercicios de respiración que se realizan en una habitación con calor. La diferencia con Bikram 60, es únicamente la duración de la clase y no se repiten todas las 26 posturas, solo algunas. Durante de clase, las palabras del maestro son como un mantra, conectan la mente y el cuerpo, la atención se centra en la respiración y la realización de asanas.  Esto es literalmente 90 o 60 minutos de meditación en movimiento.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"ANTI GRAVITY";
    objeto.imagen = @"antigravity.png";
    objeto.descripcion = @"Aerostretching - es un estiramiento y fortalecimiento de los músculos del cuerpo usando paños que cuelgan en el aire como equipo deportivo. Este conjunto de ejercicios ayudará a estirar la columna vertebral, fortalecer los músculos de la espalda, abrir el pecho y ejercitar las articulaciones de los hombros. En esta clase lograras un estiramiento total de todo el cuerpo.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"HOT ROCKET";
    objeto.imagen = @"hot_rocket.png";
    objeto.descripcion = @"Es una variación de Ashtanga Vinyasa Yoga, con menos respiraciones en cada postura. En Hot Rocket se estimula el sistema nervioso, mejorando fuerza y flexibilidad. Su ritmo es dinámico e incluye también invertidas y posturas de equilibrio.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"YOGA KIDS";
    objeto.imagen = @"yoga_kids.png";
    objeto.descripcion = @"Yoga kids es yoga tradicional para los menores de edad que quieran comenzar a practicar yoga. Ayuda a mejorar la postura. Se realiza en el salón tradicional y se pueden llegar a ocupar las hamacas de Antigravity con los pequeños.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"HATHA";
    objeto.imagen = @"hatha.png";
    objeto.descripcion = @"Hatha es un estilo clásico de posturas y técnicas de respiración. Su objetivo es crear un equilibrio entre las energías masculinas y femeninas que existen dentro de nosotros mismos. Además, también se utilizan las posturas de yoga para lograr el equilibrio entre la fuerza y la flexibilidad./nPara realizar una buena práctica de Hatha yoga, debemos cumplir tres requisitos: posturas físicas, técnicas de respiración, meditación.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"HOT VINYASA";
    objeto.imagen = @"hot_vinyasa.png";
    objeto.descripcion = @"El Vinyasa Yoga es un estilo de yoga dinámico y fluido, basado en la sincronización de la respiración con los movimientos del cuerpo. La respiración es clave en esta práctica. Esta modalidad de yoga se ordena en varias secuencias de posturas de yoga unidas entre sí. A lo largo de la práctica, las posiciones se desarrollan a través de la respiración.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"HOT TRX";
    objeto.imagen = @"trx.png";
    objeto.descripcion = @"Las clases de 40 grades TRX, o los entrenamientos de suspensión, están diseñados para ejercitar nuestro cuerpo a través del uso del peso corporal. No sólo se ejercita la fuerza, sino que también se mejora la flexibilidad y equilibrio. Si se añade una temperatura 40º a la ecuación, lograrás una mayor elasticidad, depuración y número de calorías quemadas.";
    
    [arregloClases addObject:objeto];
    
    objeto = [ObjetoClase alloc];
    objeto.titulo = @"YOGA WHEEL";
    objeto.imagen = @"yoga_wheel.png";
    objeto.descripcion = @"La rueda de yoga es la pieza clave en tu equipo…se utiliza para ayudarte con diferentes asanas y ejercicios inspirados en el yoga.Las ruedas de yoga se han vuelto cada vez más populares porque se pueden usar para estirar y relajar los músculos de la espalda, el cuello y los hombros, así como los flexores profundos de la cadera. También se pueden utilizar para mejorar las líneas correctas en las posturas de equilibrio desafiantes.";
    
    [arregloClases addObject:objeto];
    
    [self seleccionClase];
}

#pragma mark - Seleccion Clase

-(void)seleccionClase{
    
    if (posicion < arregloClases.count && posicion > -1) {
        
        NSLog(@"Posicion arreglo %d",posicion);
        
        self.ivClases.image = [UIImage imageNamed:[[arregloClases objectAtIndex:posicion]imagen]];
        self.lbNomClase.text =[[arregloClases objectAtIndex:posicion]titulo];
        self.tvDesClase.text =[[arregloClases objectAtIndex:posicion]descripcion];
        
        if (posicion == 0) {
            
            self.ivBackClase.hidden = YES;
        }else{
            
            self.ivBackClase.hidden = NO;
        }
        
        if(posicion == arregloClases.count - 1){
            
            self.ivNextClase.hidden = YES;
        }else{
            self.ivNextClase.hidden = NO;
        }
        
    }
}


# pragma mark - Acciones

- (IBAction)btnBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnNextClase:(id)sender {
    
    if (posicion < arregloClases.count - 1) {
        posicion++;
    }
    
    [self seleccionClase];
}

- (IBAction)btnBackClase:(id)sender {
    
    if (posicion > 0) {
        posicion--;
    }
    
    [self seleccionClase];
}

- (IBAction)btnReservar:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Clase" forKey:@"reservar"];

    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
@end
