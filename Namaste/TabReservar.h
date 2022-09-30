//
//  TabReservar.h
//  Namaste
//
//  Created by Alejandro Rodas on 09/07/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabReservar : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lbNomUsu;
@property UIPickerView* pvSalon;
@property UIDatePicker* dpFecha;
@property (weak, nonatomic) IBOutlet UITextField *tfSalonEdit;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewSalon;
@property (weak, nonatomic) IBOutlet UILabel *lbSalon;
- (IBAction)vtSalon:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewFecha;
- (IBAction)vtFecha:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbFecha;
@property (weak, nonatomic) IBOutlet UICollectionView *cvClasesRes;
@property (weak, nonatomic) IBOutlet UIView *viewFondo;
@property (weak, nonatomic) IBOutlet UIView *viewMenu;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
-(IBAction)esconderMenu:(id)sender;
- (IBAction)btnMenu:(id)sender;


@end

NS_ASSUME_NONNULL_END
