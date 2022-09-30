//
//  Horarios.m
//  Namaste
//
//  Created by Alejandro Rodas on 02/08/22.
//

#import "Horarios.h"

@interface Horarios ()

@end

@implementation Horarios

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)btnBack:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
@end
