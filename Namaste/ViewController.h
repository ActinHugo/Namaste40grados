//
//  ViewController.h
//  Namaste
//
//  Created by Alejandro Rodas on 23/06/22.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfPass;
@property (nonatomic) UITapGestureRecognizer *tgr;
- (IBAction)btnLogin:(id)sender;
- (IBAction)btnRegistrar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginCustom;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisCustom;


@end

