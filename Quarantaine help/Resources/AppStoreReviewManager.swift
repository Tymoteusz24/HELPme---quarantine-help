//
//  AppStoreReviewManager.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 19/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit


import StoreKit

enum AppStoreReviewManager {
    
  // 1.
  static let minimumReviewWorthyActionCount = 3

  static func requestReviewIfAppropriate() -> Bool {
    print("request review")
    let defaults = UserDefaults.standard
    let bundle = Bundle.main

    // 2.
    var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)

    // 3.
    actionCount += 1
    

    // 4.
    defaults.set(actionCount, forKey: .reviewWorthyActionCount)
    
    print("actionCount\(actionCount)")

    // 5.
    guard actionCount % minimumReviewWorthyActionCount == 0 else {
      return false
    }
     

    // 6.
    let bundleVersionKey = kCFBundleVersionKey as String
    let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
    let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)

    // 7.
    guard lastVersion == nil || lastVersion != currentVersion else {
      return false
    }
    
    
    defaults.set(0, forKey: .reviewWorthyActionCount)
    defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    
    return true

   
   

    
  }
}


extension UserDefaults {
  enum Key: String {
    case reviewWorthyActionCount
    case lastReviewRequestAppVersion
  }

  func integer(forKey key: Key) -> Int {
    return integer(forKey: key.rawValue)
  }

  func string(forKey key: Key) -> String? {
    return string(forKey: key.rawValue)
  }

  func set(_ integer: Int, forKey key: Key) {
    set(integer, forKey: key.rawValue)
  }

  func set(_ object: Any?, forKey key: Key) {
    set(object, forKey: key.rawValue)
  }
}

