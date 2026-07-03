#include <stdint.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <Foundation/NSURLCache.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLSession.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSLock.h>
#import <Foundation/NSProgress.h>
#import <Foundation/NSURLResponse.h>
#import <Foundation/NSHTTPCookieStorage.h>
#import <Foundation/NSOperation.h>
#import <Foundation/NSError.h>
#import <Foundation/NSDictionary.h>
#import "CUPHTTPStreamingTask.h"
#import "CUPHTTPWebSocketTask.h"

#if !__has_feature(objc_arc)
#error "This file must be compiled with ARC enabled"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

typedef struct {
  int64_t version;
  void* (*newWaiter)(void);
  void (*awaitWaiter)(void*);
  void* (*currentIsolate)(void);
  void (*enterIsolate)(void*);
  void (*exitIsolate)(void);
  int64_t (*getMainPortId)(void);
  bool (*getCurrentThreadOwnsIsolate)(int64_t);
  // Version 2 additions:
  void (*postListenerInvocation)(void*, void*, void (*)(void*));
} DOBJC_Context;

id objc_retainBlock(id);

#define BLOCKING_BLOCK_IMPL(ctx, BLOCK_SIG, INVOKE_DIRECT, INVOKE_LISTENER)    \
  assert(ctx->version >= 1);                                                   \
  void* targetIsolate = ctx->currentIsolate();                                 \
  int64_t targetPort = ctx->getMainPortId == NULL ? 0 : ctx->getMainPortId();  \
  return BLOCK_SIG {                                                           \
    void* currentIsolate = ctx->currentIsolate();                              \
    bool mayEnterIsolate =                                                     \
        currentIsolate == NULL &&                                              \
        ctx->getCurrentThreadOwnsIsolate != NULL &&                            \
        ctx->getCurrentThreadOwnsIsolate(targetPort);                          \
    if (currentIsolate == targetIsolate || mayEnterIsolate) {                  \
      if (mayEnterIsolate) {                                                   \
        ctx->enterIsolate(targetIsolate);                                      \
      }                                                                        \
      INVOKE_DIRECT;                                                           \
      if (mayEnterIsolate) {                                                   \
        ctx->exitIsolate();                                                    \
      }                                                                        \
    } else {                                                                   \
      void* waiter = ctx->newWaiter();                                         \
      INVOKE_LISTENER;                                                         \
      ctx->awaitWaiter(waiter);                                                \
    }                                                                          \
  };


__attribute__((visibility("default"))) __attribute__((used))
Protocol* _2n66x0_NSURLSessionDataDelegate(void) { return @protocol(NSURLSessionDataDelegate); }

__attribute__((visibility("default"))) __attribute__((used))
Protocol* _2n66x0_NSURLSessionDownloadDelegate(void) { return @protocol(NSURLSessionDownloadDelegate); }

__attribute__((visibility("default"))) __attribute__((used))
Protocol* _2n66x0_NSURLSessionWebSocketDelegate(void) { return @protocol(NSURLSessionWebSocketDelegate); }

typedef void  (^_ListenerTrampoline)(void);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline _2n66x0_wrapListenerBlock_1pl9qdv(
    _ListenerTrampoline block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void() {
    ctx->postListenerInvocation((__bridge void*)block, NULL, NULL);
  };
}

typedef void  (^_BlockingTrampoline)(void * waiter);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline _2n66x0_wrapBlockingBlock_1pl9qdv(
    _BlockingTrampoline block, _BlockingTrampoline listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(), {
    objc_retainBlock(block);
    block(nil);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter);
  });
}

typedef struct {
  void *arg0;
} _2n66x0_ListenerArgs_xtuoz7;

static void _2n66x0_ListenerArgs_xtuoz7_dispose(void *p) {
  _2n66x0_ListenerArgs_xtuoz7 *args = (_2n66x0_ListenerArgs_xtuoz7 *)p;
  (void)(__bridge_transfer id)(args->arg0);
}

typedef void  (^_ListenerTrampoline_1)(id arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_1 _2n66x0_wrapListenerBlock_xtuoz7(
    _ListenerTrampoline_1 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(id arg0) {
    _2n66x0_ListenerArgs_xtuoz7 *args = (_2n66x0_ListenerArgs_xtuoz7 *)malloc(sizeof(_2n66x0_ListenerArgs_xtuoz7));
    args->arg0 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg0));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_xtuoz7_dispose);
  };
}

typedef void  (^_BlockingTrampoline_1)(void * waiter, id arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_1 _2n66x0_wrapBlockingBlock_xtuoz7(
    _BlockingTrampoline_1 block, _BlockingTrampoline_1 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0), {
    objc_retainBlock(block);
    block(nil, (__bridge id)(__bridge_retained void*)(arg0));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, (__bridge id)(__bridge_retained void*)(arg0));
  });
}

typedef struct {
  void *arg0;
  void *arg1;
  void *arg2;
} _2n66x0_ListenerArgs_r8gdi7;

static void _2n66x0_ListenerArgs_r8gdi7_dispose(void *p) {
  _2n66x0_ListenerArgs_r8gdi7 *args = (_2n66x0_ListenerArgs_r8gdi7 *)p;
  (void)(__bridge_transfer id)(args->arg0);
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
}

typedef void  (^_ListenerTrampoline_2)(id arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_2 _2n66x0_wrapListenerBlock_r8gdi7(
    _ListenerTrampoline_2 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(id arg0, id arg1, id arg2) {
    _2n66x0_ListenerArgs_r8gdi7 *args = (_2n66x0_ListenerArgs_r8gdi7 *)malloc(sizeof(_2n66x0_ListenerArgs_r8gdi7));
    args->arg0 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg0));
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_r8gdi7_dispose);
  };
}

typedef void  (^_BlockingTrampoline_2)(void * waiter, id arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_2 _2n66x0_wrapBlockingBlock_r8gdi7(
    _BlockingTrampoline_2 block, _BlockingTrampoline_2 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0, id arg1, id arg2), {
    objc_retainBlock(block);
    block(nil, (__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, (__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  });
}

typedef struct {
  long arg0;
  void *arg1;
} _2n66x0_ListenerArgs_1kva9v1;

static void _2n66x0_ListenerArgs_1kva9v1_dispose(void *p) {
  _2n66x0_ListenerArgs_1kva9v1 *args = (_2n66x0_ListenerArgs_1kva9v1 *)p;
  (void)(__bridge_transfer id)(args->arg1);
}

typedef void  (^_ListenerTrampoline_3)(long arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_3 _2n66x0_wrapListenerBlock_1kva9v1(
    _ListenerTrampoline_3 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(long arg0, id arg1) {
    _2n66x0_ListenerArgs_1kva9v1 *args = (_2n66x0_ListenerArgs_1kva9v1 *)malloc(sizeof(_2n66x0_ListenerArgs_1kva9v1));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_1kva9v1_dispose);
  };
}

typedef void  (^_BlockingTrampoline_3)(void * waiter, long arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_3 _2n66x0_wrapBlockingBlock_1kva9v1(
    _BlockingTrampoline_3 block, _BlockingTrampoline_3 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(long arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef struct {
  void *arg0;
  void *arg1;
} _2n66x0_ListenerArgs_pfv6jd;

static void _2n66x0_ListenerArgs_pfv6jd_dispose(void *p) {
  _2n66x0_ListenerArgs_pfv6jd *args = (_2n66x0_ListenerArgs_pfv6jd *)p;
  (void)(__bridge_transfer id)(args->arg0);
  (void)(__bridge_transfer id)(args->arg1);
}

typedef void  (^_ListenerTrampoline_4)(id arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_4 _2n66x0_wrapListenerBlock_pfv6jd(
    _ListenerTrampoline_4 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(id arg0, id arg1) {
    _2n66x0_ListenerArgs_pfv6jd *args = (_2n66x0_ListenerArgs_pfv6jd *)malloc(sizeof(_2n66x0_ListenerArgs_pfv6jd));
    args->arg0 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg0));
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_pfv6jd_dispose);
  };
}

typedef void  (^_BlockingTrampoline_4)(void * waiter, id arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_4 _2n66x0_wrapBlockingBlock_pfv6jd(
    _BlockingTrampoline_4 block, _BlockingTrampoline_4 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, (__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, (__bridge id)(__bridge_retained void*)(arg0), (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef struct {
  NSURLSessionAuthChallengeDisposition arg0;
  void *arg1;
} _2n66x0_ListenerArgs_n8yd09;

static void _2n66x0_ListenerArgs_n8yd09_dispose(void *p) {
  _2n66x0_ListenerArgs_n8yd09 *args = (_2n66x0_ListenerArgs_n8yd09 *)p;
  (void)(__bridge_transfer id)(args->arg1);
}

typedef void  (^_ListenerTrampoline_5)(NSURLSessionAuthChallengeDisposition arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_5 _2n66x0_wrapListenerBlock_n8yd09(
    _ListenerTrampoline_5 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(NSURLSessionAuthChallengeDisposition arg0, id arg1) {
    _2n66x0_ListenerArgs_n8yd09 *args = (_2n66x0_ListenerArgs_n8yd09 *)malloc(sizeof(_2n66x0_ListenerArgs_n8yd09));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_n8yd09_dispose);
  };
}

typedef void  (^_BlockingTrampoline_5)(void * waiter, NSURLSessionAuthChallengeDisposition arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_5 _2n66x0_wrapBlockingBlock_n8yd09(
    _BlockingTrampoline_5 block, _BlockingTrampoline_5 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(NSURLSessionAuthChallengeDisposition arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef struct {
  NSURLSessionDelayedRequestDisposition arg0;
  void *arg1;
} _2n66x0_ListenerArgs_1otpo83;

static void _2n66x0_ListenerArgs_1otpo83_dispose(void *p) {
  _2n66x0_ListenerArgs_1otpo83 *args = (_2n66x0_ListenerArgs_1otpo83 *)p;
  (void)(__bridge_transfer id)(args->arg1);
}

typedef void  (^_ListenerTrampoline_6)(NSURLSessionDelayedRequestDisposition arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_6 _2n66x0_wrapListenerBlock_1otpo83(
    _ListenerTrampoline_6 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(NSURLSessionDelayedRequestDisposition arg0, id arg1) {
    _2n66x0_ListenerArgs_1otpo83 *args = (_2n66x0_ListenerArgs_1otpo83 *)malloc(sizeof(_2n66x0_ListenerArgs_1otpo83));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_1otpo83_dispose);
  };
}

typedef void  (^_BlockingTrampoline_6)(void * waiter, NSURLSessionDelayedRequestDisposition arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_6 _2n66x0_wrapBlockingBlock_1otpo83(
    _BlockingTrampoline_6 block, _BlockingTrampoline_6 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(NSURLSessionDelayedRequestDisposition arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef struct {
  NSURLSessionResponseDisposition arg0;
} _2n66x0_ListenerArgs_16sve1d;

typedef void  (^_ListenerTrampoline_7)(NSURLSessionResponseDisposition arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_7 _2n66x0_wrapListenerBlock_16sve1d(
    _ListenerTrampoline_7 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(NSURLSessionResponseDisposition arg0) {
    _2n66x0_ListenerArgs_16sve1d *args = (_2n66x0_ListenerArgs_16sve1d *)malloc(sizeof(_2n66x0_ListenerArgs_16sve1d));
    args->arg0 = arg0;
    ctx->postListenerInvocation((__bridge void*)block, args, NULL);
  };
}

typedef void  (^_BlockingTrampoline_7)(void * waiter, NSURLSessionResponseDisposition arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_7 _2n66x0_wrapBlockingBlock_16sve1d(
    _BlockingTrampoline_7 block, _BlockingTrampoline_7 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(NSURLSessionResponseDisposition arg0), {
    objc_retainBlock(block);
    block(nil, arg0);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0);
  });
}

typedef struct {
  void * arg0;
  void *arg1;
} _2n66x0_ListenerArgs_18v1jvf;

static void _2n66x0_ListenerArgs_18v1jvf_dispose(void *p) {
  _2n66x0_ListenerArgs_18v1jvf *args = (_2n66x0_ListenerArgs_18v1jvf *)p;
  (void)(__bridge_transfer id)(args->arg1);
}

typedef void  (^_ListenerTrampoline_8)(void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_8 _2n66x0_wrapListenerBlock_18v1jvf(
    _ListenerTrampoline_8 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1) {
    _2n66x0_ListenerArgs_18v1jvf *args = (_2n66x0_ListenerArgs_18v1jvf *)malloc(sizeof(_2n66x0_ListenerArgs_18v1jvf));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_18v1jvf_dispose);
  };
}

typedef void  (^_BlockingTrampoline_8)(void * waiter, void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_8 _2n66x0_wrapBlockingBlock_18v1jvf(
    _BlockingTrampoline_8 block, _BlockingTrampoline_8 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef void  (^_ProtocolTrampoline)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_18v1jvf(id target, void * sel, id arg1) {
  return ((_ProtocolTrampoline)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
} _2n66x0_ListenerArgs_fjrv01;

static void _2n66x0_ListenerArgs_fjrv01_dispose(void *p) {
  _2n66x0_ListenerArgs_fjrv01 *args = (_2n66x0_ListenerArgs_fjrv01 *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
}

typedef void  (^_ListenerTrampoline_9)(void * arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_9 _2n66x0_wrapListenerBlock_fjrv01(
    _ListenerTrampoline_9 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2) {
    _2n66x0_ListenerArgs_fjrv01 *args = (_2n66x0_ListenerArgs_fjrv01 *)malloc(sizeof(_2n66x0_ListenerArgs_fjrv01));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_fjrv01_dispose);
  };
}

typedef void  (^_BlockingTrampoline_9)(void * waiter, void * arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_9 _2n66x0_wrapBlockingBlock_fjrv01(
    _BlockingTrampoline_9 block, _BlockingTrampoline_9 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  });
}

typedef void  (^_ProtocolTrampoline_1)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_fjrv01(id target, void * sel, id arg1, id arg2) {
  return ((_ProtocolTrampoline_1)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  void *arg3;
} _2n66x0_ListenerArgs_bklti2;

static void _2n66x0_ListenerArgs_bklti2_dispose(void *p) {
  _2n66x0_ListenerArgs_bklti2 *args = (_2n66x0_ListenerArgs_bklti2 *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
  (void)(__bridge_transfer id)(args->arg3);
}

typedef void  (^_ListenerTrampoline_10)(void * arg0, id arg1, id arg2, id arg3);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_10 _2n66x0_wrapListenerBlock_bklti2(
    _ListenerTrampoline_10 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, id arg3) {
    _2n66x0_ListenerArgs_bklti2 *args = (_2n66x0_ListenerArgs_bklti2 *)malloc(sizeof(_2n66x0_ListenerArgs_bklti2));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = (__bridge void*)(objc_retainBlock(arg3));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_bklti2_dispose);
  };
}

typedef void  (^_BlockingTrampoline_10)(void * waiter, void * arg0, id arg1, id arg2, id arg3);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_10 _2n66x0_wrapBlockingBlock_bklti2(
    _BlockingTrampoline_10 block, _BlockingTrampoline_10 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, id arg3), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), objc_retainBlock(arg3));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), objc_retainBlock(arg3));
  });
}

typedef void  (^_ProtocolTrampoline_2)(void * sel, id arg1, id arg2, id arg3);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_bklti2(id target, void * sel, id arg1, id arg2, id arg3) {
  return ((_ProtocolTrampoline_2)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  void *arg3;
  void *arg4;
} _2n66x0_ListenerArgs_xx612k;

static void _2n66x0_ListenerArgs_xx612k_dispose(void *p) {
  _2n66x0_ListenerArgs_xx612k *args = (_2n66x0_ListenerArgs_xx612k *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
  (void)(__bridge_transfer id)(args->arg3);
  (void)(__bridge_transfer id)(args->arg4);
}

typedef void  (^_ListenerTrampoline_11)(void * arg0, id arg1, id arg2, id arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_11 _2n66x0_wrapListenerBlock_xx612k(
    _ListenerTrampoline_11 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, id arg3, id arg4) {
    _2n66x0_ListenerArgs_xx612k *args = (_2n66x0_ListenerArgs_xx612k *)malloc(sizeof(_2n66x0_ListenerArgs_xx612k));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg3));
    args->arg4 = (__bridge void*)(objc_retainBlock(arg4));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_xx612k_dispose);
  };
}

typedef void  (^_BlockingTrampoline_11)(void * waiter, void * arg0, id arg1, id arg2, id arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_11 _2n66x0_wrapBlockingBlock_xx612k(
    _BlockingTrampoline_11 block, _BlockingTrampoline_11 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, id arg3, id arg4), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), (__bridge id)(__bridge_retained void*)(arg3), objc_retainBlock(arg4));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), (__bridge id)(__bridge_retained void*)(arg3), objc_retainBlock(arg4));
  });
}

typedef void  (^_ProtocolTrampoline_3)(void * sel, id arg1, id arg2, id arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_xx612k(id target, void * sel, id arg1, id arg2, id arg3, id arg4) {
  return ((_ProtocolTrampoline_3)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3, arg4);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  void *arg3;
} _2n66x0_ListenerArgs_1tz5yf;

static void _2n66x0_ListenerArgs_1tz5yf_dispose(void *p) {
  _2n66x0_ListenerArgs_1tz5yf *args = (_2n66x0_ListenerArgs_1tz5yf *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
  (void)(__bridge_transfer id)(args->arg3);
}

typedef void  (^_ListenerTrampoline_12)(void * arg0, id arg1, id arg2, id arg3);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_12 _2n66x0_wrapListenerBlock_1tz5yf(
    _ListenerTrampoline_12 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, id arg3) {
    _2n66x0_ListenerArgs_1tz5yf *args = (_2n66x0_ListenerArgs_1tz5yf *)malloc(sizeof(_2n66x0_ListenerArgs_1tz5yf));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg3));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_1tz5yf_dispose);
  };
}

typedef void  (^_BlockingTrampoline_12)(void * waiter, void * arg0, id arg1, id arg2, id arg3);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_12 _2n66x0_wrapBlockingBlock_1tz5yf(
    _BlockingTrampoline_12 block, _BlockingTrampoline_12 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, id arg3), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), (__bridge id)(__bridge_retained void*)(arg3));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), (__bridge id)(__bridge_retained void*)(arg3));
  });
}

typedef void  (^_ProtocolTrampoline_4)(void * sel, id arg1, id arg2, id arg3);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_1tz5yf(id target, void * sel, id arg1, id arg2, id arg3) {
  return ((_ProtocolTrampoline_4)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  int64_t arg3;
  int64_t arg4;
} _2n66x0_ListenerArgs_ly2579;

static void _2n66x0_ListenerArgs_ly2579_dispose(void *p) {
  _2n66x0_ListenerArgs_ly2579 *args = (_2n66x0_ListenerArgs_ly2579 *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
}

typedef void  (^_ListenerTrampoline_13)(void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_13 _2n66x0_wrapListenerBlock_ly2579(
    _ListenerTrampoline_13 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4) {
    _2n66x0_ListenerArgs_ly2579 *args = (_2n66x0_ListenerArgs_ly2579 *)malloc(sizeof(_2n66x0_ListenerArgs_ly2579));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = arg3;
    args->arg4 = arg4;
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_ly2579_dispose);
  };
}

typedef void  (^_BlockingTrampoline_13)(void * waiter, void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_13 _2n66x0_wrapBlockingBlock_ly2579(
    _BlockingTrampoline_13 block, _BlockingTrampoline_13 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, arg4);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, arg4);
  });
}

typedef void  (^_ProtocolTrampoline_5)(void * sel, id arg1, id arg2, int64_t arg3, int64_t arg4);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_ly2579(id target, void * sel, id arg1, id arg2, int64_t arg3, int64_t arg4) {
  return ((_ProtocolTrampoline_5)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3, arg4);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  int64_t arg3;
  int64_t arg4;
  int64_t arg5;
} _2n66x0_ListenerArgs_h68abb;

static void _2n66x0_ListenerArgs_h68abb_dispose(void *p) {
  _2n66x0_ListenerArgs_h68abb *args = (_2n66x0_ListenerArgs_h68abb *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
}

typedef void  (^_ListenerTrampoline_14)(void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4, int64_t arg5);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_14 _2n66x0_wrapListenerBlock_h68abb(
    _ListenerTrampoline_14 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4, int64_t arg5) {
    _2n66x0_ListenerArgs_h68abb *args = (_2n66x0_ListenerArgs_h68abb *)malloc(sizeof(_2n66x0_ListenerArgs_h68abb));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = arg3;
    args->arg4 = arg4;
    args->arg5 = arg5;
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_h68abb_dispose);
  };
}

typedef void  (^_BlockingTrampoline_14)(void * waiter, void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4, int64_t arg5);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_14 _2n66x0_wrapBlockingBlock_h68abb(
    _BlockingTrampoline_14 block, _BlockingTrampoline_14 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, int64_t arg3, int64_t arg4, int64_t arg5), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, arg4, arg5);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, arg4, arg5);
  });
}

typedef void  (^_ProtocolTrampoline_6)(void * sel, id arg1, id arg2, int64_t arg3, int64_t arg4, int64_t arg5);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_h68abb(id target, void * sel, id arg1, id arg2, int64_t arg3, int64_t arg4, int64_t arg5) {
  return ((_ProtocolTrampoline_6)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3, arg4, arg5);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  int64_t arg3;
  void *arg4;
} _2n66x0_ListenerArgs_jyim80;

static void _2n66x0_ListenerArgs_jyim80_dispose(void *p) {
  _2n66x0_ListenerArgs_jyim80 *args = (_2n66x0_ListenerArgs_jyim80 *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
  (void)(__bridge_transfer id)(args->arg4);
}

typedef void  (^_ListenerTrampoline_15)(void * arg0, id arg1, id arg2, int64_t arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_15 _2n66x0_wrapListenerBlock_jyim80(
    _ListenerTrampoline_15 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, int64_t arg3, id arg4) {
    _2n66x0_ListenerArgs_jyim80 *args = (_2n66x0_ListenerArgs_jyim80 *)malloc(sizeof(_2n66x0_ListenerArgs_jyim80));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = arg3;
    args->arg4 = (__bridge void*)(objc_retainBlock(arg4));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_jyim80_dispose);
  };
}

typedef void  (^_BlockingTrampoline_15)(void * waiter, void * arg0, id arg1, id arg2, int64_t arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_15 _2n66x0_wrapBlockingBlock_jyim80(
    _BlockingTrampoline_15 block, _BlockingTrampoline_15 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, int64_t arg3, id arg4), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, objc_retainBlock(arg4));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, objc_retainBlock(arg4));
  });
}

typedef void  (^_ProtocolTrampoline_7)(void * sel, id arg1, id arg2, int64_t arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_jyim80(id target, void * sel, id arg1, id arg2, int64_t arg3, id arg4) {
  return ((_ProtocolTrampoline_7)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3, arg4);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  void *arg3;
  void *arg4;
  void *arg5;
} _2n66x0_ListenerArgs_l2g8ke;

static void _2n66x0_ListenerArgs_l2g8ke_dispose(void *p) {
  _2n66x0_ListenerArgs_l2g8ke *args = (_2n66x0_ListenerArgs_l2g8ke *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
  (void)(__bridge_transfer id)(args->arg3);
  (void)(__bridge_transfer id)(args->arg4);
  (void)(__bridge_transfer id)(args->arg5);
}

typedef void  (^_ListenerTrampoline_16)(void * arg0, id arg1, id arg2, id arg3, id arg4, id arg5);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_16 _2n66x0_wrapListenerBlock_l2g8ke(
    _ListenerTrampoline_16 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, id arg3, id arg4, id arg5) {
    _2n66x0_ListenerArgs_l2g8ke *args = (_2n66x0_ListenerArgs_l2g8ke *)malloc(sizeof(_2n66x0_ListenerArgs_l2g8ke));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg3));
    args->arg4 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg4));
    args->arg5 = (__bridge void*)(objc_retainBlock(arg5));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_l2g8ke_dispose);
  };
}

typedef void  (^_BlockingTrampoline_16)(void * waiter, void * arg0, id arg1, id arg2, id arg3, id arg4, id arg5);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_16 _2n66x0_wrapBlockingBlock_l2g8ke(
    _BlockingTrampoline_16 block, _BlockingTrampoline_16 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, id arg3, id arg4, id arg5), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), (__bridge id)(__bridge_retained void*)(arg3), (__bridge id)(__bridge_retained void*)(arg4), objc_retainBlock(arg5));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), (__bridge id)(__bridge_retained void*)(arg3), (__bridge id)(__bridge_retained void*)(arg4), objc_retainBlock(arg5));
  });
}

typedef void  (^_ProtocolTrampoline_8)(void * sel, id arg1, id arg2, id arg3, id arg4, id arg5);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_l2g8ke(id target, void * sel, id arg1, id arg2, id arg3, id arg4, id arg5) {
  return ((_ProtocolTrampoline_8)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3, arg4, arg5);
}

typedef struct {
  void * arg0;
  void *arg1;
  void *arg2;
  NSURLSessionWebSocketCloseCode arg3;
  void *arg4;
} _2n66x0_ListenerArgs_1lx650f;

static void _2n66x0_ListenerArgs_1lx650f_dispose(void *p) {
  _2n66x0_ListenerArgs_1lx650f *args = (_2n66x0_ListenerArgs_1lx650f *)p;
  (void)(__bridge_transfer id)(args->arg1);
  (void)(__bridge_transfer id)(args->arg2);
  (void)(__bridge_transfer id)(args->arg4);
}

typedef void  (^_ListenerTrampoline_17)(void * arg0, id arg1, id arg2, NSURLSessionWebSocketCloseCode arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_17 _2n66x0_wrapListenerBlock_1lx650f(
    _ListenerTrampoline_17 block, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  NSCAssert(ctx->version >= 2, @"package:objective_c is too old");
  return ^void(void * arg0, id arg1, id arg2, NSURLSessionWebSocketCloseCode arg3, id arg4) {
    _2n66x0_ListenerArgs_1lx650f *args = (_2n66x0_ListenerArgs_1lx650f *)malloc(sizeof(_2n66x0_ListenerArgs_1lx650f));
    args->arg0 = arg0;
    args->arg1 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg1));
    args->arg2 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg2));
    args->arg3 = arg3;
    args->arg4 = (__bridge void*)((__bridge id)(__bridge_retained void*)(arg4));
    ctx->postListenerInvocation((__bridge void*)block, args, &_2n66x0_ListenerArgs_1lx650f_dispose);
  };
}

typedef void  (^_BlockingTrampoline_17)(void * waiter, void * arg0, id arg1, id arg2, NSURLSessionWebSocketCloseCode arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_17 _2n66x0_wrapBlockingBlock_1lx650f(
    _BlockingTrampoline_17 block, _BlockingTrampoline_17 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2, NSURLSessionWebSocketCloseCode arg3, id arg4), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, (__bridge id)(__bridge_retained void*)(arg4));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2), arg3, (__bridge id)(__bridge_retained void*)(arg4));
  });
}

typedef void  (^_ProtocolTrampoline_9)(void * sel, id arg1, id arg2, NSURLSessionWebSocketCloseCode arg3, id arg4);
__attribute__((visibility("default"))) __attribute__((used))
void  _2n66x0_protocolTrampoline_1lx650f(id target, void * sel, id arg1, id arg2, NSURLSessionWebSocketCloseCode arg3, id arg4) {
  return ((_ProtocolTrampoline_9)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2, arg3, arg4);
}
#undef BLOCKING_BLOCK_IMPL

#pragma clang diagnostic pop
