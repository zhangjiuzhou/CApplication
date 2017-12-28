//
//  CURLRouter.m
//  CApplication
//
//  Created by 张九州 on 2017/12/27.
//

#import "CURLRouter.h"

static NSString * defaultScheme;

@interface CURLParts ()

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation CURLParts

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ params:%@", self.path, self.params];
}

@end

@interface CURLRoute : NSObject

@property (nonatomic, strong) NSRegularExpression *regExp;
@property (nonatomic, strong) NSArray *paramNames;
@property (nonatomic, strong) CURLRouterCallback callback;

@end

@implementation CURLRoute

- (instancetype)initWithPatternString:(NSString *)patternString
                           paramNames:(NSArray *)paramNames
                             callback:(CURLRouterCallback)callback {
    if (self = [super init]) {
        self.regExp = [NSRegularExpression regularExpressionWithPattern:patternString
                                                                 options:0
                                                                   error:NULL];
        self.paramNames = paramNames;
        self.callback = callback;
    }
    return self;
}

- (BOOL)match:(NSString *)path paramsPtr:(NSDictionary * __autoreleasing *)paramsPtr {
    NSTextCheckingResult *match = [self.regExp firstMatchInString:path options:0 range:NSMakeRange(0, path.length)];
    if (match) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        for (NSInteger i = 1; i < match.numberOfRanges; i++) {
            NSString *value = [path substringWithRange:[match rangeAtIndex:i]];
            params[self.paramNames[i - 1]] = value;
        }
        if (paramsPtr) {
            *paramsPtr = [params copy];
        }

        return YES;
    }
    return NO;
}

@end

@interface CURLRouter ()

@property (nonatomic, strong) NSMutableArray<CURLRoute *> *routes;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredRoutes;

@end

@implementation CURLRouter

+ (instancetype)router {
    NSAssert(defaultScheme != nil, nil);
    return [self routerForScheme:defaultScheme];
}

+ (instancetype)routerForScheme:(NSString *)scheme {
    static NSMutableDictionary<NSString *, CURLRouter *> *routers;
    if (!routers) {
        routers = [NSMutableDictionary dictionary];
    }
    CURLRouter *router = routers[scheme];
    if (!router) {
        router = [CURLRouter new];
        routers[scheme] = router;
    }
    return router;
}

+ (void)setDefaultScheme:(NSString *)scheme {
    NSAssert(defaultScheme == nil, nil);
    defaultScheme = scheme;
}

+ (BOOL)openURL:(NSURL *)URL {
    NSAssert(defaultScheme != nil, nil);
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSString *scheme = components.scheme ? : defaultScheme;
    CURLRouter *router = [[self class] routerForScheme:scheme];
    if (router) {
        // 需要一些容错处理
        // 1. path必须以/开始，必须不能以/结束
        // 2. 多个/替换为1个
        // 3. path的第一部分可能被识别为host，手动修复
        NSString *path = components.path;
        if ([path rangeOfString:@"/"].location != 0) {
            path = [@"/" stringByAppendingString:path];
        }
        if (![path isEqualToString:@"/"] && [path rangeOfString:@"/" options:NSBackwardsSearch].location == path.length - 1) {
            path = [path substringToIndex:path.length - 1];
        }
        NSRegularExpression *multipleSlash = [NSRegularExpression regularExpressionWithPattern:@"/{2,}"
                                                                                       options:0
                                                                                         error:NULL];
        path = [multipleSlash stringByReplacingMatchesInString:path options:0 range:NSMakeRange(0, path.length) withTemplate:@"/"];
        if (components.host && [components.host rangeOfString:@"."].location == NSNotFound) {
            path = [NSString stringWithFormat:@"/%@%@", components.host, path];
        }
        components.path = path;
        return [router _openURLWithURLComponents:components];
    }
    return NO;
}

+ (void)addRoute:(NSString *)route callback:(CURLRouterCallback)callback {
    return [[self router] addRoute:route callback:callback];
}

- (instancetype)init {
    if (self = [super init]) {
        self.routes = [NSMutableArray array];
        self.registeredRoutes = [NSMutableSet set];
    }
    return self;
}

- (void)addRoute:(NSString *)route callback:(CURLRouterCallback)callback {
    // 允许以下格式：
    // 1. 单个/
    // 2. 多个以/开始的部分，参数前带:。 如/foo/bar/:id
    NSString * pattern = @"^/$|^(/[A-Za-z0-9-:]+)+$";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSAssert([regExp numberOfMatchesInString:route options:0 range:NSMakeRange(0, route.length)] > 0, nil);

    // 禁止重复定义
    // /foo/bar/:id和/foo/bar/:uid也算重复，因为参数位置一样
    CURLRoute *r = [self _createRoute:route callback:callback];
    NSAssert(![self.registeredRoutes containsObject:r.regExp.pattern], nil);

    [self.routes addObject:r];
    [self.registeredRoutes addObject:r.regExp.pattern];
}

- (BOOL)_openURLWithURLComponents:(NSURLComponents *)components {
    for (CURLRoute *route in self.routes) {
        NSDictionary *params;
        if ([route match:components.path paramsPtr:&params]) {
            NSMutableDictionary *allParams = [params mutableCopy];
            for (NSURLQueryItem *queryItem in components.queryItems) {
                allParams[queryItem.name] = queryItem.value;
            }

            CURLParts *parts = [CURLParts new];
            parts.path = components.path;
            parts.params = [allParams copy];
            route.callback(parts);

            return YES;
        }
    }
    return NO;
}

- (CURLRoute *)_createRoute:(NSString *)route callback:(CURLRouterCallback)callback {
    // 转换为正则表达式。如：/foo/bar/:uid/:id -> ^/foo/bar/(:[^/]+)/(:[^/]+)$
    // 记录参数名的顺序，因为参数将按照位置匹配。如：[uid, id]
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@":[^/]+"
                                                                            options:0
                                                                              error:NULL];
    NSArray<NSTextCheckingResult *> *matches = [regExp matchesInString:route options:0 range:NSMakeRange(0, route.length)];
    NSMutableArray *paramNames = [NSMutableArray array];
    for (NSTextCheckingResult *checkingResult in matches) {
        NSString *paramName = [[route substringWithRange:checkingResult.range] substringFromIndex:1];
        [paramNames addObject:paramName];
    }

    for (NSString *paramName in paramNames) {
        route = [route stringByReplacingOccurrencesOfString:[@"/:" stringByAppendingString:paramName] withString:@"/([^/]+)"];
    }

    NSString *patternString = [NSString stringWithFormat:@"^%@$", route];
    return [[CURLRoute alloc] initWithPatternString:patternString
                                         paramNames:[paramNames copy]
                                           callback:callback];
}

@end
