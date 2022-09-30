//
//  Principal.m
//  Namaste
//
//  Created by Alejandro Rodas on 16/08/22.
//

#import "Principal.h"

@interface Principal ()

@end

@implementation Principal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


#pragma mark - Metodos de vista

-(void)viewWillAppear:(BOOL)animated{
    
    NSString* reservar =[[NSUserDefaults standardUserDefaults] objectForKey:@"reservar"];
    
    //NSLog(@"Reservar %@",reservar);
    
    if (![reservar isEqualToString:@""]) {
        
        self.selectedIndex = 2;
        
    }
    
}



@end
