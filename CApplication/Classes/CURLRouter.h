//
//  CURLRouter.h
//  CApplication
//
//  Created by 张九州 on 2017/12/27.
//

#import <Foundation/Foundation.h>

@class CURLParts;

typedef void (^CURLRouterCallback)(CURLParts *parts);

@interface CURLParts : NSObject

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSDictionary *params;

@end

@interface CURLRouter : NSObject

+ (instancetype)router;
+ (instancetype)routerForScheme:(NSString *)scheme;

+ (void)setDefaultScheme:(NSString *)scheme;
+ (BOOL)openURL:(NSURL *)URL;
+ (void)addRoute:(NSString *)route callback:(CURLRouterCallback)callback;

- (void)addRoute:(NSString *)route callback:(CURLRouterCallback)callback;

@end
