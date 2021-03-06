// Objective-C API for talking to multicrypt Go package.
//   gobind -lang=objc multicrypt
//
// File is generated by gobind. Do not edit.

#ifndef __Hello_H__
#define __Hello_H__

@import Foundation;
#include "Universe.objc.h"

#include "Rpc.objc.h"
#include "ContractTransaction.objc.h"
#include "Util.objc.h"

@class HelloK;
@class HelloKeys;
@class HelloWrapperContractTransaction;

@interface HelloK : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)operation;
- (void)setOperation:(NSString*)v;
// skipped field K.Args with unsupported type: []interface{}

@end

@interface HelloKeys : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field Keys.Keys with unsupported type: []string

@end

@interface HelloWrapperContractTransaction : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field WrapperContractTransaction.Inputs with unsupported type: []struct{External int "json:\"External\""; PrevHash string "json:\"PrevHash\""; Address string "json:\"Address\""; Vout int "json:\"vout\""; Internal int "json:\"Internal\""}

// skipped field WrapperContractTransaction.Outputs with unsupported type: []struct{Address string "json:\"Address\""; Value int64 "json:\"Value\""; AssetID string "json:\"AssetID\""}

// skipped field WrapperContractTransaction.Attributes with unsupported type: []struct{Usage uint16 "json:\"Usage\""; Data []byte "json:\"Data\""}

- (long)version;
- (void)setVersion:(long)v;
- (long)transactionType;
- (void)setTransactionType:(long)v;
@end

@interface Hello : NSObject
// skipped variable Coin with unsupported type: *multicrypt/Neo.Coin

// skipped variable Contract with unsupported type: multicrypt/Neo/Transactions/ContractTransaction.ContractTransaction

@end

FOUNDATION_EXPORT NSString* HelloGenerateAddress(NSString* mnemonic, long external, long internal);

FOUNDATION_EXPORT NSString* HelloNewAccount(void);

FOUNDATION_EXPORT NSString* HelloPrepareInvocationTransactionAndSign(NSString* operation, NSData* transInJson, NSData* scriptInJson, NSData* keysJsonData, NSString* mnemonic);

FOUNDATION_EXPORT NSString* HelloPrepareTransactionAndSign(long transType, NSData* transInJson, NSData* keysJsonData, NSString* mnemonic);

FOUNDATION_EXPORT NSData* HelloPrinter(NSString* a);

FOUNDATION_EXPORT NSString* HelloSecondFunc(NSData* s);

FOUNDATION_EXPORT BOOL HelloSendTransaction(NSString* url, NSString* transactionData);

FOUNDATION_EXPORT NSString* HelloStringToFixed8(NSString* s);

#endif
