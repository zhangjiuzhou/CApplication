//
//  CModuleManager.m
//  CApplication
//
//  Created by 张九州 on 2017/12/22.
//

#import "CModuleManager.h"
#import <objc/runtime.h>

@interface CModuleFactory : NSObject

@property (nonatomic, strong) id (^block)(void);
@property (nonatomic, strong) id module;

@end

@implementation CModuleFactory

@synthesize module = _module;

- (instancetype)initWithBlock:(id (^)(void))block {
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (id)module {
    if (!_module) {
        _module = self.block();
        self.block = nil;
    }
    return _module;
}

@end

@interface CModuleManager ()

@property (nonatomic, strong) NSMutableDictionary *moduleMap;

@end

@implementation CModuleManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static id sharedManager;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self class] new];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.moduleMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerModuleWithProtocol:(Protocol *)protocol block:(id (^)(void))block {
    NSString *protocolStr = NSStringFromProtocol(protocol);
    if (!self.moduleMap[protocolStr]) {
        self.moduleMap[protocolStr] = [[CModuleFactory alloc] initWithBlock:block];
    }
}

- (void)registerModuleWithProtocol:(Protocol *)protocol class:(Class)klass {
    NSString *protocolStr = NSStringFromProtocol(protocol);
    if (!self.moduleMap[protocolStr]) {
        self.moduleMap[protocolStr] = [[CModuleFactory alloc] initWithBlock:^id{
            return [klass new];
        }];
    }
}

- (void)registerModuleWithProtocol:(Protocol *)protocol object:(id)object {
    NSString *protocolStr = NSStringFromProtocol(protocol);
    if (!self.moduleMap[protocolStr]) {
        self.moduleMap[protocolStr] = [[CModuleFactory alloc] initWithBlock:^id{
            return object;
        }];
    }
}

- (id)moduleWithProtocol:(Protocol *)protocol {
    CModuleFactory *factory = self.moduleMap[NSStringFromProtocol(protocol)];
    id module = factory.module;
    if (factory) {
        NSAssert(module != nil, @"Module object of protocol %@ must no be nil.", NSStringFromProtocol(protocol));
    }
    if (module) {
        NSAssert([module conformsToProtocol:protocol],
                 @"Module object of class %@ does not conform to protocol %@.",
                 NSStringFromClass([module class]),
                 NSStringFromProtocol(protocol));
    }
    return module;
}

@end
