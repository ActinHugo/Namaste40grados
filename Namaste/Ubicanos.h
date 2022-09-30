//
//  Ubicanos.h
//  Namaste
//
//  Created by Alejandro Rodas on 02/08/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ubicanos : UIViewController
- (IBAction)btnBack:(id)sender;
- (IBAction)btnEsme:(id)sender;
- (IBAction)btnPalm:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbTituloDir;
@property (weak, nonatomic) IBOutlet UILabel *lbDireccion;
- (IBAction)btnMapa:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ivEsme;
@property (weak, nonatomic) IBOutlet UIButton *ivPalma;
@property (weak, nonatomic) IBOutlet UIView *viewDireccion;

@property (weak, nonatomic) IBOutlet UIButton *ivMapa;
@property (weak, nonatomic) IBOutlet UILabel *lbEstado;
- (IBAction)btnWaze:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ivWaze;

@end

NS_ASSUME_NONNULL_END
