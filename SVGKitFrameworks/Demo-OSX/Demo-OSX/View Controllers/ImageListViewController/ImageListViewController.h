//
//  ImageListViewController.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 20/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;

#import "ImageCollection.h"
#import "ImageFile.h"

@interface ImageListViewController : NSViewController

typedef void(^ImageListSelectionHandler)(ImageFile *imageFile);

@property (strong) NSArray <ImageCollection *> *imageCollections;

@property (nonatomic, copy) ImageListSelectionHandler imageSelectionHandler;

@end
