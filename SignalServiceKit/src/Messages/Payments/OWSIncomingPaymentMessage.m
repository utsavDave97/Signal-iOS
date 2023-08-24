//
// Copyright 2023 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

#import "OWSIncomingPaymentMessage.h"
#import <SignalCoreKit/NSDate+OWS.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSIncomingPaymentMessage ()

@end

#pragma mark -

@implementation OWSIncomingPaymentMessage

- (instancetype)initIncomingMessageWithBuilder:(TSIncomingMessageBuilder *)messageBuilder
                           paymentCancellation:(nullable TSPaymentCancellation *)paymentCancellation
                           paymentNotification:(nullable TSPaymentNotification *)paymentNotification
                                paymentRequest:(nullable TSPaymentRequest *)paymentRequest
{
    OWSAssertDebug(paymentCancellation != nil || paymentNotification != nil || paymentRequest != nil);

    self = [super initIncomingMessageWithBuilder:messageBuilder];
    if (!self) {
        return self;
    }

    _paymentCancellation = paymentCancellation;
    _paymentNotification = paymentNotification;
    _paymentRequest = paymentRequest;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                      bodyRanges:(nullable MessageBodyRanges *)bodyRanges
                    contactShare:(nullable OWSContact *)contactShare
                       editState:(TSEditState)editState
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
                       giftBadge:(nullable OWSGiftBadge *)giftBadge
               isGroupStoryReply:(BOOL)isGroupStoryReply
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
           storyAuthorUuidString:(nullable NSString *)storyAuthorUuidString
              storyReactionEmoji:(nullable NSString *)storyReactionEmoji
                  storyTimestamp:(nullable NSNumber *)storyTimestamp
              wasRemotelyDeleted:(BOOL)wasRemotelyDeleted
               authorPhoneNumber:(nullable NSString *)authorPhoneNumber
                      authorUUID:(nullable NSString *)authorUUID
                            read:(BOOL)read
         serverDeliveryTimestamp:(uint64_t)serverDeliveryTimestamp
                      serverGuid:(nullable NSString *)serverGuid
                 serverTimestamp:(nullable NSNumber *)serverTimestamp
                  sourceDeviceId:(unsigned int)sourceDeviceId
                          viewed:(BOOL)viewed
                 wasReceivedByUD:(BOOL)wasReceivedByUD
             paymentCancellation:(nullable TSPaymentCancellation *)paymentCancellation
             paymentNotification:(nullable TSPaymentNotification *)paymentNotification
                  paymentRequest:(nullable TSPaymentRequest *)paymentRequest
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId
                     attachmentIds:attachmentIds
                              body:body
                        bodyRanges:bodyRanges
                      contactShare:contactShare
                         editState:editState
                   expireStartedAt:expireStartedAt
                         expiresAt:expiresAt
                  expiresInSeconds:expiresInSeconds
                         giftBadge:giftBadge
                 isGroupStoryReply:isGroupStoryReply
                isViewOnceComplete:isViewOnceComplete
                 isViewOnceMessage:isViewOnceMessage
                       linkPreview:linkPreview
                    messageSticker:messageSticker
                     quotedMessage:quotedMessage
      storedShouldStartExpireTimer:storedShouldStartExpireTimer
             storyAuthorUuidString:storyAuthorUuidString
                storyReactionEmoji:storyReactionEmoji
                    storyTimestamp:storyTimestamp
                wasRemotelyDeleted:wasRemotelyDeleted
                 authorPhoneNumber:authorPhoneNumber
                        authorUUID:authorUUID
                              read:read
           serverDeliveryTimestamp:serverDeliveryTimestamp
                        serverGuid:serverGuid
                   serverTimestamp:serverTimestamp
                    sourceDeviceId:sourceDeviceId
                            viewed:viewed
                   wasReceivedByUD:wasReceivedByUD];

    if (!self) {
        return self;
    }

    _paymentCancellation = paymentCancellation;
    _paymentNotification = paymentNotification;
    _paymentRequest = paymentRequest;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (BOOL)shouldBeSaved
{
    return YES;
}

- (BOOL)hasRenderableContent
{
    return YES;
}

@end

NS_ASSUME_NONNULL_END
