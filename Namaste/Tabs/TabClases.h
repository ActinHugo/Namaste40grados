//
//  TabClases.h
//  Namaste
//
//  Created by Alejandro Rodas on 02/07/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabClases : ViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lbNomUsu;
- (IBAction)btnMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionClases;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (weak, nonatomic) IBOutlet UIView *viewFondo;
@property (weak, nonatomic) IBOutlet UIView *viewMenu;
-(IBAction)esconderMenu:(id)sender;

@end

NS_ASSUME_NONNULL_END
