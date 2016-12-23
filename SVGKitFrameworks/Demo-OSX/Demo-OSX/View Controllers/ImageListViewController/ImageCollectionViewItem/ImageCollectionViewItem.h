//
//  ImageCollectionViewItem.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 20/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;

#import "ImageFile.h"

@interface ImageCollectionViewItem : NSCollectionViewItem

@property (strong) ImageFile *imageFile;

@end
