//
//  Conocenos.m
//  Namaste
//
//  Created by Alejandro Rodas on 12/08/22.
//

#import "Conocenos.h"

@interface Conocenos ()

@end

@implementation Conocenos

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepararFondo];
    
    //Prueb 333
    
    //self.viewMenu.translatesAutoresizingMaskIntoConstraints = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)prepararFondo{
    
    /*UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewFondo.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30.0, 30.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //maskLayer.frame = self.viewFondo.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.viewFondo.layer.mask = maskLayer;*/
    
    self.viewFondo.clipsToBounds = YES;
    self.viewFondo.layer.cornerRadius = 30;
    self.viewFondo.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;

    
    /*if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.viewFondo.backgroundColor = [UIColor clearColor];

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.viewFondo.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self.viewFondo addSubview:blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
    }*/
    
}


- (IBAction)btnBack:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
