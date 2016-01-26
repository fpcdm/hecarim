//
//  UIColor+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIColor+Framework.h"

@implementation UIColor (Framework)

+ (UIColor *)colorWithHex:(NSString *)hex
{
    return [UIColor colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha
{
    //处理参数
    hex = hex ? [hex uppercaseString] : @"";
    if ([hex hasPrefix:@"0X"]) {
        hex = [hex substringFromIndex:2];
    }
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    //解析颜色
    NSString *strA = nil;
    NSString *strR = nil;
    NSString *strG = nil;
    NSString *strB = nil;
    
    //长度解析
    switch (hex.length) {
            //RGB
        case 3:
        {
            NSString *tmpR = [hex substringWithRange:NSMakeRange(0, 1)];
            NSString *tmpG = [hex substringWithRange:NSMakeRange(1, 1)];
            NSString *tmpB = [hex substringWithRange:NSMakeRange(2, 1)];
            
            strR = [NSString stringWithFormat:@"%@%@", tmpR, tmpR];
            strG = [NSString stringWithFormat:@"%@%@", tmpG, tmpG];
            strB = [NSString stringWithFormat:@"%@%@", tmpB, tmpB];
        }
            break;
            //ARGB
        case 4:
        {
            NSString *tmpA = [hex substringWithRange:NSMakeRange(0, 1)];
            NSString *tmpR = [hex substringWithRange:NSMakeRange(1, 1)];
            NSString *tmpG = [hex substringWithRange:NSMakeRange(2, 1)];
            NSString *tmpB = [hex substringWithRange:NSMakeRange(3, 1)];
            
            strA = [NSString stringWithFormat:@"%@%@", tmpA, tmpA];
            strR = [NSString stringWithFormat:@"%@%@", tmpR, tmpR];
            strG = [NSString stringWithFormat:@"%@%@", tmpG, tmpG];
            strB = [NSString stringWithFormat:@"%@%@", tmpB, tmpB];
        }
            break;
            //RRGGBB
        case 6:
        {
            strR = [hex substringWithRange:NSMakeRange(0, 2)];
            strG = [hex substringWithRange:NSMakeRange(2, 2)];
            strB = [hex substringWithRange:NSMakeRange(4, 2)];
        }
            break;
            //AARRGGBB
        case 8:
        {
            strA = [hex substringWithRange:NSMakeRange(0, 2)];
            strR = [hex substringWithRange:NSMakeRange(2, 2)];
            strG = [hex substringWithRange:NSMakeRange(4, 2)];
            strB = [hex substringWithRange:NSMakeRange(6, 2)];
        }
            break;
            //ERROR
        default:
            return [UIColor clearColor];
            break;
    }
    
    //解析透明度，字符串的透明度优先级高于alpha参数
    if (strA) {
        unsigned int a;
        [[NSScanner scannerWithString:strA] scanHexInt:&a];
        //计算十六进制对应透明度
        alpha = (a * 1.0f) / 255.0f;
    }
    
    //解析颜色
    unsigned int r, g, b;
    [[NSScanner scannerWithString:strR] scanHexInt:&r];
    [[NSScanner scannerWithString:strG] scanHexInt:&g];
    [[NSScanner scannerWithString:strB] scanHexInt:&b];
    
    float fr = (r * 1.0f) / 255.0f;
    float fg = (g * 1.0f) / 255.0f;
    float fb = (b * 1.0f) / 255.0f;
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}

+ (UIColor *)colorWithValue:(NSString *)value
{
    return [UIColor colorWithValue:value alpha:1.0f];
}

+ (UIColor *)colorWithValue:(NSString *)value alpha:(CGFloat)alpha
{
    static dispatch_once_t			once;
    static NSMutableDictionary *	namedColors = nil;
    
    dispatch_once( &once, ^
                  {
                      namedColors = [[NSMutableDictionary alloc] init];
                      namedColors[@"aliceblue"]			 = @"F0F8FF";
                      namedColors[@"antiquewhite"]		 = @"FAEBD7";
                      namedColors[@"aqua"]				 = @"00FFFF";
                      namedColors[@"aquamarine"]			 = @"7FFFD4";
                      namedColors[@"azure"]				 = @"F0FFFF";
                      namedColors[@"beige"]				 = @"F5F5DC";
                      namedColors[@"bisque"]				 = @"FFE4C4";
                      namedColors[@"black"]				 = @"000000";
                      namedColors[@"blanchedalmond"]		 = @"FFEBCD";
                      namedColors[@"blue"]				 = @"0000FF";
                      namedColors[@"blueviolet"]			 = @"8A2BE2";
                      namedColors[@"brown"]				 = @"A52A2A";
                      namedColors[@"burlywood"]			 = @"DEB887";
                      namedColors[@"cadetblue"]			 = @"5F9EA0";
                      namedColors[@"chartreuse"]			 = @"7FFF00";
                      namedColors[@"chocolate"]			 = @"D2691E";
                      namedColors[@"coral"]				 = @"FF7F50";
                      namedColors[@"cornflowerblue"]		 = @"6495ED";
                      namedColors[@"cornsilk"]			 = @"FFF8DC";
                      namedColors[@"crimson"]				 = @"DC143C";
                      namedColors[@"cyan"]				 = @"00FFFF";
                      namedColors[@"darkblue"]			 = @"00008B";
                      namedColors[@"darkcyan"]			 = @"008B8B";
                      namedColors[@"darkgoldenrod"]		 = @"B8860B";
                      namedColors[@"darkgray"]			 = @"A9A9A9";
                      namedColors[@"darkgreen"]			 = @"006400";
                      namedColors[@"darkkhaki"]			 = @"BDB76B";
                      namedColors[@"darkmagenta"]			 = @"8B008B";
                      namedColors[@"darkolivegreen"]		 = @"556B2F";
                      namedColors[@"darkorange"]			 = @"FF8C00";
                      namedColors[@"darkorchid"]			 = @"9932CC";
                      namedColors[@"darkred"]				 = @"8B0000";
                      namedColors[@"darksalmon"]			 = @"E9967A";
                      namedColors[@"darkseagreen"]		 = @"8FBC8F";
                      namedColors[@"darkslateblue"]		 = @"483D8B";
                      namedColors[@"darkslategray"]		 = @"2F4F4F";
                      namedColors[@"darkturquoise"]		 = @"00CED1";
                      namedColors[@"darkviolet"]			 = @"9400D3";
                      namedColors[@"deeppink"]			 = @"FF1493";
                      namedColors[@"deepskyblue"]			 = @"00BFFF";
                      namedColors[@"dimgray"]				 = @"696969";
                      namedColors[@"dodgerblue"]			 = @"1E90FF";
                      namedColors[@"feldspar"]			 = @"D19275";
                      namedColors[@"firebrick"]			 = @"B22222";
                      namedColors[@"floralwhite"]			 = @"FFFAF0";
                      namedColors[@"forestgreen"]			 = @"228B22";
                      namedColors[@"fuchsia"]				 = @"FF00FF";
                      namedColors[@"gainsboro"]			 = @"DCDCDC";
                      namedColors[@"ghostwhite"]			 = @"F8F8FF";
                      namedColors[@"gold"]				 = @"FFD700";
                      namedColors[@"goldenrod"]			 = @"DAA520";
                      namedColors[@"gray"]				 = @"808080";
                      namedColors[@"green"]				 = @"008000";
                      namedColors[@"greenyellow"]			 = @"ADFF2F";
                      namedColors[@"honeydew"]			 = @"F0FFF0";
                      namedColors[@"hotpink"]				 = @"FF69B4";
                      namedColors[@"indianred"]			 = @"CD5C5C";
                      namedColors[@"indigo"]				 = @"4B0082";
                      namedColors[@"ivory"]				 = @"FFFFF0";
                      namedColors[@"khaki"]				 = @"F0E68C";
                      namedColors[@"lavender"]			 = @"E6E6FA";
                      namedColors[@"lavenderblush"]		 = @"FFF0F5";
                      namedColors[@"lawngreen"]			 = @"7CFC00";
                      namedColors[@"lemonchiffon"]		 = @"FFFACD";
                      namedColors[@"lightblue"]			 = @"ADD8E6";
                      namedColors[@"lightcoral"]			 = @"F08080";
                      namedColors[@"lightcyan"]			 = @"E0FFFF";
                      namedColors[@"lightgoldenrodyellow"] = @"FAFAD2";
                      namedColors[@"lightgrey"]			 = @"D3D3D3";
                      namedColors[@"lightgreen"]			 = @"90EE90";
                      namedColors[@"lightpink"]			 = @"FFB6C1";
                      namedColors[@"lightsalmon"]			 = @"FFA07A";
                      namedColors[@"lightseagreen"]		 = @"20B2AA";
                      namedColors[@"lightskyblue"]		 = @"87CEFA";
                      namedColors[@"lightslateblue"]		 = @"8470FF";
                      namedColors[@"lightslategray"]		 = @"778899";
                      namedColors[@"lightsteelblue"]		 = @"B0C4DE";
                      namedColors[@"lightyellow"]			 = @"FFFFE0";
                      namedColors[@"lime"]				 = @"00FF00";
                      namedColors[@"limegreen"]			 = @"32CD32";
                      namedColors[@"linen"]				 = @"FAF0E6";
                      namedColors[@"magenta"]				 = @"FF00FF";
                      namedColors[@"maroon"]				 = @"800000";
                      namedColors[@"mediumaquamarine"]	 = @"66CDAA";
                      namedColors[@"mediumblue"]			 = @"0000CD";
                      namedColors[@"mediumorchid"]		 = @"BA55D3";
                      namedColors[@"mediumpurple"]		 = @"9370D8";
                      namedColors[@"mediumseagreen"]		 = @"3CB371";
                      namedColors[@"mediumslateblue"]		 = @"7B68EE";
                      namedColors[@"mediumspringgreen"]	 = @"00FA9A";
                      namedColors[@"mediumturquoise"]		 = @"48D1CC";
                      namedColors[@"mediumvioletred"]		 = @"C71585";
                      namedColors[@"midnightblue"]		 = @"191970";
                      namedColors[@"mintcream"]			 = @"F5FFFA";
                      namedColors[@"mistyrose"]			 = @"FFE4E1";
                      namedColors[@"moccasin"]			 = @"FFE4B5";
                      namedColors[@"navajowhite"]			 = @"FFDEAD";
                      namedColors[@"navy"]				 = @"000080";
                      namedColors[@"oldlace"]				 = @"FDF5E6";
                      namedColors[@"olive"]				 = @"808000";
                      namedColors[@"olivedrab"]			 = @"6B8E23";
                      namedColors[@"orange"]				 = @"FFA500";
                      namedColors[@"orangered"]			 = @"FF4500";
                      namedColors[@"orchid"]				 = @"DA70D6";
                      namedColors[@"palegoldenrod"]		 = @"EEE8AA";
                      namedColors[@"palegreen"]			 = @"98FB98";
                      namedColors[@"paleturquoise"]		 = @"AFEEEE";
                      namedColors[@"palevioletred"]		 = @"D87093";
                      namedColors[@"papayawhip"]			 = @"FFEFD5";
                      namedColors[@"peachpuff"]			 = @"FFDAB9";
                      namedColors[@"peru"]				 = @"CD853F";
                      namedColors[@"pink"]				 = @"FFC0CB";
                      namedColors[@"plum"]				 = @"DDA0DD";
                      namedColors[@"powderblue"]			 = @"B0E0E6";
                      namedColors[@"purple"]				 = @"800080";
                      namedColors[@"red"]					 = @"FF0000";
                      namedColors[@"rosybrown"]			 = @"BC8F8F";
                      namedColors[@"royalblue"]			 = @"4169E1";
                      namedColors[@"saddlebrown"]			 = @"8B4513";
                      namedColors[@"salmon"]				 = @"FA8072";
                      namedColors[@"sandybrown"]			 = @"F4A460";
                      namedColors[@"seagreen"]			 = @"2E8B57";
                      namedColors[@"seashell"]			 = @"FFF5EE";
                      namedColors[@"sienna"]				 = @"A0522D";
                      namedColors[@"silver"]				 = @"C0C0C0";
                      namedColors[@"skyblue"]				 = @"87CEEB";
                      namedColors[@"slateblue"]			 = @"6A5ACD";
                      namedColors[@"slategray"]			 = @"708090";
                      namedColors[@"snow"]				 = @"FFFAFA";
                      namedColors[@"springgreen"]			 = @"00FF7F";
                      namedColors[@"steelblue"]			 = @"4682B4";
                      namedColors[@"tan"]					 = @"D2B48C";
                      namedColors[@"teal"]				 = @"008080";
                      namedColors[@"thistle"]				 = @"D8BFD8";
                      namedColors[@"tomato"]				 = @"FF6347";
                      namedColors[@"turquoise"]			 = @"40E0D0";
                      namedColors[@"violet"]				 = @"EE82EE";
                      namedColors[@"violetred"]			 = @"D02090";
                      namedColors[@"wheat"]				 = @"F5DEB3";
                      namedColors[@"white"]				 = @"FFFFFF";
                      namedColors[@"whitesmoke"]			 = @"F5F5F5";
                      namedColors[@"yellow"]				 = @"FFFF00";
                      namedColors[@"yellowgreen"]			 = @"9ACD32";
                      namedColors[@"transparent"]			 = @"";
                      namedColors[@"clear"]			         = @"";
                  });
    
    NSString *lowerValue = [value lowercaseString];
    if ([namedColors objectForKey:lowerValue]) {
        value = [namedColors objectForKey:lowerValue];
    }
    return [UIColor colorWithHex:value alpha:alpha];
}

+ (NSString *)stringFromColor:(UIColor *)color
{
    return [UIColor stringFromColor:color alpha:NO];
}

+ (NSString *)stringFromColor:(UIColor *)color alpha:(BOOL)alpha
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    NSString *strA = @"";
    if (alpha) {
        CGFloat a = CGColorGetAlpha(color.CGColor);
        strA = [NSString stringWithFormat:@"%02lX", lround(a * 255)];
    }
    
    return [NSString stringWithFormat:@"#%@%02lX%02lX%02lX",
            strA,
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

@end
