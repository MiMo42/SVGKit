//
//  ViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 02/05/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import SVGKit;

#import "ViewController.h"

@interface ViewController ()

@property (strong) IBOutlet SVGKLayeredImageView *svgImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //_svgFastImageView.image = [SVGKImage imageNamed:@"Coins"];
    _svgImageView.image = [SVGKImage imageNamed:@"NewTux"];
    
    /*
    NSError *error = nil;
    NSData *pdfData = [SVGKExporterPDF exportAsPDFData:[SVGKImage imageNamed:@"NewTux"] error:&error];
    
    NSArray *arr = [[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask];
    NSURL *documentsURL = [arr firstObject];
    NSURL *documentURL = [documentsURL URLByAppendingPathComponent:@"svgtopdf.pdf" isDirectory:NO];
    
    [pdfData writeToURL:documentURL atomically:YES];
    
    NSLog(@"File Written.");
    */
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
