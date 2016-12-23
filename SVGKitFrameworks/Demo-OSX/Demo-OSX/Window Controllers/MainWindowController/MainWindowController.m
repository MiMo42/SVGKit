//
//  MainWindowController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "MainWindowController.h"

#import "MainSplitViewController.h"
#import "ImageCollectionListViewController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (void)windowDidLoad {

    [super windowDidLoad];

    NSAssert(self.window != nil, @"window is expected to be non nil by this time.");
 
    self.window.titleVisibility = NSWindowTitleHidden;
}

@end
