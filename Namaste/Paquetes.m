//
//  Paquetes.m
//  Namaste
//
//  Created by Alejandro Rodas on 25/08/22.
//

#import "Paquetes.h"

@interface Paquetes ()

@end

@implementation Paquetes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)btnBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
@end
