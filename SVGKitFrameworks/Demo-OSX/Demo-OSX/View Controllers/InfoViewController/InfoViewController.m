//
//  InfoViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 23/12/2016.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "InfoViewController.h"

#import "ImageViewerViewController.h"

@interface InfoViewController ()

@property (strong) SVGKImage *svgImage;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SVGImageDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:
        ^(NSNotification * _Nonnull note) {
        
           // self.svgImage = note.object;
        }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
