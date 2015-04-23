//
//  KBPGPDecrypt.m
//  Keybase
//
//  Created by Gabriel on 3/27/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "KBPGPDecrypt.h"

#import "KBRunBlocks.h"

@interface KBPGPDecrypt ()
@end

@implementation KBPGPDecrypt

- (void)decryptWithOptions:(KBRPgpDecryptOptions *)options streams:(NSArray *)streams client:(KBRPClient *)client sender:(id)sender completion:(void (^)(NSArray *streams))completion {
  KBRunBlocks *sb = [[KBRunBlocks alloc] init];
  sb.objects = streams;
  sb.runBlock = ^(KBStream *stream, KBCompletionBlock runCompletion) {
    [self decryptWithOptions:options stream:stream client:client sender:sender completion:^(NSError *error, KBStream *stream) {
      runCompletion(error);
    }];
  };
  sb.completionBlock = ^(NSArray *errors, NSArray *streams) {
    completion(streams);
  };
  [sb run];
}

- (void)decryptWithOptions:(KBRPgpDecryptOptions *)options stream:(KBStream *)stream client:(KBRPClient *)client sender:(id)sender completion:(void (^)(NSError *error, KBStream *stream))completion {
  KBRPgpRequest *request = [[KBRPgpRequest alloc] initWithClient:client];

  [stream registerWithClient:client sessionId:request.sessionId];

  KBRStream *source = [[KBRStream alloc] init];
  source.fd = stream.label;

  KBRStream *sink = [[KBRStream alloc] init];
  sink.fd = stream.label;

  [request pgpDecryptWithSessionID:request.sessionId source:source sink:sink opts:options completion:^(NSError *error, KBRPgpSigVerification *pgpSigVerification) {

    // TODO sig verify
    stream.error = error;

    completion(error, stream);
  }];
}

@end
