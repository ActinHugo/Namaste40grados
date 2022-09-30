//
//  CcClases.h
//  Namaste
//
//  Created by Alejandro Rodas on 11/07/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CcClases : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivFondoCell;
@property (strong, nonatomic) IBOutlet UILabel *lbNomMaestro;
@property (strong, nonatomic) IBOutlet UILabel *lbTipoClase;
@property (strong, nonatomic) IBOutlet UILabel *lbHorario;
@property (weak, nonatomic) IBOutlet UILabel *lbFechaClase;

@end

NS_ASSUME_NONNULL_END
