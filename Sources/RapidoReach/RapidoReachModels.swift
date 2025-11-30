//
//  RapidoReach.swift
//  RapidoReach
//
//  Created by Yasir M Turk on 28/07/2020.
//

import Foundation

/// Registered user's information
public struct RapidoReachUser: Decodable {
    /// Registered user's id
    public let id: String
    /// Whetther Survery is available for the registered user
    public let survey_available: Bool
    ///
    public let profiled: Bool
    ///
    public let moments_polling_frequency: Int
    /// Rewards object for this user
    public var rewards: RapidoReachReward?
}

public struct ReplyObject: Decodable{
    public let ErrorCode: String
    public let Errors: Array<String>
    public let Info: Array<String>
    public let Data: Array<RapidoReachUser>
}

public struct fetchRewardsReplyObject: Decodable{
    public let ErrorCode: String
    public let Errors: Array<String>
    public let Info: Array<String>
    public let Data: Array<RapidoReachReward>
}

/// Rewards information
public struct RapidoReachReward: Decodable {
    /// id
    public let appuser_reward_ids: String
    /// Total reward points availble for this user
    public let total_rewards: Int
    /// Optional richer reward objects from backend
    public let rewards: [RapidoReachRewardItem]?
}

public struct RapidoReachRewardItem: Decodable {
    public let transactionIdentifier: String?
    public let placementIdentifier: String?
    public let placementTag: String?
    public let currencyName: String?
    public let rewardAmount: Double
    public let saleMultiplier: Double?
}

public struct RapidoReachSurvey: Decodable {
    public let surveyIdentifier: String
    public let lengthInMinutes: Int
    public let rewardAmount: Double
    public let currencyName: String?
    public let isHotTile: Bool
    public let isSale: Bool
    public let saleMultiplier: Double
    public let saleEndDate: String?
    public let preSaleRewardAmount: Double
    public let provider: String?
}
