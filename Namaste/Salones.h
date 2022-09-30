//
//  Salones.h
//  Namaste
//
//  Created by Alejandro Rodas on 02/08/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface Salones : UIViewController

- (IBAction)btnSalida:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ivSalon;
@property (weak, nonatomic) IBOutlet UIImageView *ivSeleccion;
@property (weak, nonatomic) IBOutlet UILabel *lbDescripcion;
@property (weak, nonatomic) IBOutlet UIButton *ivReservar;
- (IBAction)btnReservar:(id)sender;

@end

NS_ASSUME_NONNULL_END
