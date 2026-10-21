//
//  SubscriptionRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//
import Foundation

protocol SubscriptionRepository {

    func getSubscriptions(
        userId: Int,
        applicationId: String,
        searchName: String,
        searchActive: Int,
        sessionId: String
    ) async throws -> [Subscription]

    func getSubscriptionDetails(
        subscriptionId: Int,
        sessionId: String
    ) async throws -> SubscriptionDetails

    func checkDuplicateSubscription(
        userId: Int,
        applicationId: Int,
        alertDefinitionId: Int,
        alertFlag: Int,
        userSubId: Int,
        sessionId: String
    ) async throws -> DuplicateSubscriptionResponse
    func saveSubscription(
        userSubId: Int,
        alertName: String,
        applicationId: Int,
        alertDefId: Int,
        userId: Int,
        alertTypes: Int,
        mailId: String,
        messageBody: String,
        subject: String,
        alertFlag: Int,
        threshold: Int,
        sortOrder: Int,
        active: Int,
        sessionId: String
    ) async throws -> SaveSubscriptionResponse
}
