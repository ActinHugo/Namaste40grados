//
//  Galeria.m
//  Namaste
//
//  Created by Alejandro Rodas on 03/11/22.
//

#import "Galeria.h"

@interface Galeria ()

@end

@implementation Galeria

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];

}



- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDarkContent;
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
@end
