//
//  ImageCollectionListViewController.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;

#import "ImageCollection.h"

@interface ImageCollectionListViewController : NSViewController 

typedef void(^ImageCollectionListSelectionHandler)(NSArray <ImageCollection *> *imageCollections);

@property (strong) NSArray <ImageCollection *> *imageCollections;

@property (nonatomic, copy) ImageCollectionListSelectionHandler collectionSelectionHandler;

@end


