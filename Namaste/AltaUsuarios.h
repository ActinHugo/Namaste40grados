//
//  AltaUsuarios.h
//  Namaste
//
//  Created by Alejandro Rodas on 07/07/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AltaUsuarios : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nombre;
@property (strong, nonatomic) IBOutlet UITextField *correo;
@property (strong, nonatomic) IBOutlet UITextField *pass;
@property (strong, nonatomic) IBOutlet UITextField *telefono;
- (IBAction)btnCrear:(UIButton *)sender;
- (IBAction)btnCerrar:(id)sender;
@property (nonatomic) UITapGestureRecognizer *tgr;

@end

NS_ASSUME_NONNULL_END
