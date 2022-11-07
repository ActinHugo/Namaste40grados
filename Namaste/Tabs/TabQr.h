//
//  TabQr.h
//  Namaste
//
//  Created by Alejandro Rodas on 02/07/22.
//

#import "ViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface TabQr : ViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel* lbNombUsu;
- (IBAction)btnMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView* ivQr;
@property (strong, nonatomic) UITableView* tvMenu;
@property (weak, nonatomic) IBOutlet UIView *viewFondo;
@property (weak, nonatomic) IBOutlet UIView *viewMenu;
@property (weak, nonatomic) IBOutlet UITableView *tvMenuPrin;
-(IBAction)esconderMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbClasesRes;
@end

NS_ASSUME_NONNULL_END
