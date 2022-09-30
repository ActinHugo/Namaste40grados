//
//  PdfVista.m
//  Namaste
//
//  Created by Alejandro Rodas on 16/08/22.
//

#import "PdfVista.h"
#import <PDFKit/PDFKit.h>

@interface PdfVista ()

@end

@implementation PdfVista

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PDFView *View = [[PDFView alloc] initWithFrame: self.view.bounds];
    View.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    View.autoScales = NO ;
    View.displayDirection = kPDFDisplayDirectionHorizontal;
    View.displayMode = kPDFDisplaySinglePageContinuous;
    View.displaysRTL = YES ;
    [View setDisplaysPageBreaks:YES];
    [View setDisplayBox:kPDFDisplayBoxTrimBox];
    [View zoomIn:self];
    [self.view addSubview:View];

    NSURL* URL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"ANUNCIO"]];
    
    //NSURL * URL = [[NSBundle mainBundle] URLForResource: [[NSUserDefaults standardUserDefaults] objectForKey:@"ANUNCIO"] withExtension: @ "pdf" ];
    
    //NSLog(@"%@",URL);
    
    PDFDocument * document = [[PDFDocument alloc] initWithURL: URL];
    View.document = document;
    
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(cerrarPdf:) userInfo:nil repeats:NO];
    
    [self performSelector:@selector(cerrarPdf:) withObject:nil afterDelay:5.0];
    
}

-(IBAction)cerrarPdf:(id)sender{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self performSegueWithIdentifier:@"seguePdfPrincipal" sender:self];
}


@end
