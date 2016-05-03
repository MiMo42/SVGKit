//
//  SVGKExporterPDF.h
//  SVGKit-OSX
//
//  Created by Michael Monscheuer on 02/05/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVGKImage;

@interface SVGKExporterPDF : NSObject

+ (NSData *) exportAsPDFData:(SVGKImage *)image error:(NSError **)outError;

+ (NSData *)exportAsPDFData:(SVGKImage *)image withRect:(NSRect)rect
                      error:(NSError **)error;
@end
