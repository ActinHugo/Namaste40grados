//
//  NuestrasClases.h
//  Namaste
//
//  Created by Alejandro Rodas on 18/08/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NuestrasClases : UIViewController
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ivClases;
@property (weak, nonatomic) IBOutlet UILabel *lbNomClase;
@property (weak, nonatomic) IBOutlet UITextView *tvDesClase;
@property (weak, nonatomic) IBOutlet UIButton *ivReservar;
- (IBAction)btnReservar:(id)sender;
- (IBAction)btnBackClase:(id)sender;
- (IBAction)btnNextClase:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ivBackClase;
@property (weak, nonatomic) IBOutlet UIButton *ivNextClase;

@end

NS_ASSUME_NONNULL_END
