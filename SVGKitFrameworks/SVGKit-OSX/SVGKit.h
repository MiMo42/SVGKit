//
//  SVGKit-OSX.h
//  SVGKit-OSX
//
//  Created by Michael Monscheuer on 02/05/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for SVGKit-OSX.
FOUNDATION_EXPORT double SVGKit_OSXVersionNumber;

//! Project version string for SVGKit-OSX.
FOUNDATION_EXPORT const unsigned char SVGKit_OSXVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SVGKit_OSX/PublicHeader.h>

// Exporters
#import <SVGKit/SVGKExporterNSImage.h>
#import <SVGKit/SVGKExporterPDF.h>
#import <SVGKit/SVGKExporterNSData.h>

#if V_1_COMPATIBILITY_COMPILE_CALAYEREXPORTER_CLASS
#import <SVGKit/CALayerExporter.h>
#endif

// App Kit
#import <SVGKit/SVGKImage.h>
#import <SVGKit/SVGKFastImageView.h>

// CSS
#import <SVGKit/DocumentCSS.h>
#import <SVGKit/CSSStyleDeclaration.h>
#import <SVGKit/CSSRule.h>
#import <SVGKit/CSSStyleSheet.h>
#import <SVGKit/CSSStyleRule.h>
#import <SVGKit/CSSRuleList.h>
#import <SVGKit/CSSRuleList+Mutable.h>
#import <SVGKit/CSSPrimitiveValue.h>
#import <SVGKit/CSSPrimitiveValue_ConfigurablePixelsPerInch.h>
#import <SVGKit/CSSValueList.h>
#import <SVGKit/CSSValue_ForSubclasses.h>
#import <SVGKit/CSSValue.h>

// SVG
#import <SVGKit/SVGAngle.h>
#import <SVGKit/SVGAnimatedPreserveAspectRatio.h>
#import <SVGKit/SVGDefsElement.h>
#import <SVGKit/SVGDocument.h>
#import <SVGKit/SVGDocument_Mutable.h>
#import <SVGKit/SVGElementInstance.h>
#import <SVGKit/SVGElementInstance_Mutable.h>
#import <SVGKit/SVGElementInstanceList.h>
#import <SVGKit/SVGElementInstanceList_Internal.h>
#import <SVGKit/SVGGElement.h>
#import <SVGKit/SVGStylable.h>
#import <SVGKit/SVGLength.h>
#import <SVGKit/SVGMatrix.h>
#import <SVGKit/SVGNumber.h>
#import <SVGKit/SVGPoint.h>
#import <SVGKit/SVGPreserveAspectRatio.h>
#import <SVGKit/SVGRect.h>
#import <SVGKit/SVGSVGElement_Mutable.h>
#import <SVGKit/SVGTransform.h>
#import <SVGKit/SVGUseElement.h>
#import <SVGKit/SVGUseElement_Mutable.h>
#import <SVGKit/SVGViewSpec.h>
#import <SVGKit/SVGHelperUtilities.h>
#import <SVGKit/SVGTransformable.h>
#import <SVGKit/SVGFitToViewBox.h>
#import <SVGKit/SVGTextPositioningElement.h>
#import <SVGKit/SVGTextContentElement.h>
#import <SVGKit/SVGTextPositioningElement_Mutable.h>

#import <SVGKit/SVGGradientElement.h>
#import <SVGKit/SVGGradientStop.h>
#import <SVGKit/SVGStyleCatcher.h>
#import <SVGKit/SVGStyleElement.h>
#import <SVGKit/SVGCircleElement.h>
#import <SVGKit/SVGDescriptionElement.h>
#import <SVGKit/SVGElement.h>
#import <SVGKit/SVGElement_ForParser.h>
#import <SVGKit/SVGEllipseElement.h>
#import <SVGKit/SVGGroupElement.h>
#import <SVGKit/SVGImageElement.h>
#import <SVGKit/SVGLineElement.h>
#import <SVGKit/SVGPathElement.h>
#import <SVGKit/SVGPolygonElement.h>
#import <SVGKit/SVGPolylineElement.h>
#import <SVGKit/SVGRectElement.h>

#import <SVGKit/SVGSVGElement.h>
#import <SVGKit/SVGTextElement.h>
#import <SVGKit/SVGTitleElement.h>

// DOM
#import <SVGKit/DOMHelperUtilities.h> 
#import <SVGKit/DOMHelperUtilities.h>
#import <SVGKit/DOMGlobalSettings.h>

// Core Animation
#import <SVGKit/CALayer+RecursiveClone.h>
#import <SVGKit/CALayerWithChildHitTest.h>
#import <SVGKit/CAShapeLayerWithHitTest.h>

// Core Graphics
#import <SVGKit/CGPathAdditions.h>

// Misc
#import <SVGKit/AppleSucksDOMImplementation.h>
#import <SVGKit/Attr.h>
#import <SVGKit/CDATASection.h>
#import <SVGKit/CharacterData.h>
#import <SVGKit/Comment.h>
#import <SVGKit/Document+Mutable.h>
#import <SVGKit/Document.h>

#import <SVGKit/DocumentStyle.h>
#import <SVGKit/StyleSheetList+Mutable.h>
#import <SVGKit/StyleSheetList.h>
#import <SVGKit/StyleSheet.h>
#import <SVGKit/MediaList.h>
#import <SVGKit/DocumentFragment.h>
#import <SVGKit/DocumentType.h>

#import <SVGKit/Element.h>
#import <SVGKit/EntityReference.h>
#import <SVGKit/NamedNodeMap.h>
#import <SVGKit/NamedNodeMap_Iterable.h>
#import <SVGKit/Node+Mutable.h>
#import <SVGKit/Node.h>
#import <SVGKit/NodeList+Mutable.h>
#import <SVGKit/NodeList.h>
#import <SVGKit/ProcessingInstruction.h>
#import <SVGKit/Text.h>

#import <SVGKit/ConverterSVGToCALayer.h>

#import <SVGKit/BaseClassForAllSVGBasicShapes.h>
#import <SVGKit/BaseClassForAllSVGBasicShapes_ForSubclasses.h>

#import <SVGKit/SVGKImage+CGContext.h>

#import <SVGKit/SVGKSourceLocalFile.h>
#import <SVGKit/SVGKSourceString.h>
#import <SVGKit/SVGKSourceURL.h>
#import <SVGKit/SVGKParserDefsAndUse.h>
#import <SVGKit/SVGKParserDOM.h>
#import <SVGKit/SVGKParserGradient.h>
#import <SVGKit/SVGKParserPatternsAndGradients.h>
#import <SVGKit/SVGKParserStyles.h>
#import <SVGKit/SVGKParserSVG.h>
#import <SVGKit/SVGKParser.h>
#import <SVGKit/SVGKParseResult.h>
#import <SVGKit/SVGKParserExtension.h>
#import <SVGKit/SVGKPointsAndPathsParser.h>
#import <SVGKit/SVGGradientLayer.h>

#import <SVGKit/SVGKLayer.h>
#import <SVGKit/SVGKImage.h>
#import <SVGKit/SVGKSource.h>
#import <SVGKit/NSCharacterSet+SVGKExtensions.h>
#import <SVGKit/SVGKFastImageView.h>
#import <SVGKit/SVGKImageView.h>
#import <SVGKit/SVGKLayeredImageView.h>
#import <SVGKit/SVGKPattern.h>
#import <SVGKit/SVGUtils.h>
