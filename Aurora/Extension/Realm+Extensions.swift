//
//  Realm+Extensions.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

extension Realm {
  /**
   - Parameter block: It's the piece of code you pass to the method to execute. So, this is technically checking if a
   write block is already in progress and if so, then the code you pass in will be executed in that write
   process, if not, then it will open a new write and execute the code you pass.
   */
  public func safeWrite(_ block: (() throws -> Void)) throws {
    if isInWriteTransaction {
      try block()
    } else {
      try write(block)
    }
  }
}

extension Object {

/// Same as .observe, but the block is called after write transaction was commited.
  func safelyObserve(_ block: @escaping (ObjectChange<RLMObjectBase>) -> Void) -> NotificationToken {
    let dispatchQueue = OperationQueue.current?.underlyingQueue ?? DispatchQueue.main
    return self.observe { otherBlock in
        dispatchQueue.async {
          block(otherBlock)
        }
    }
  }

}

extension Results where Element: RealmCollectionValue {

    /// Same as .observe, but the block is called after write transaction was commited.
    func safelyObserve(_ block: @escaping (RealmSwift.RealmCollectionChange<RealmSwift.Results<Element>>) -> Void) -> RealmSwift.NotificationToken {
        let dispatchQueue = OperationQueue.current?.underlyingQueue ?? DispatchQueue.main
        return self.observe { otherBlock in
            dispatchQueue.async {
                block(otherBlock)
            }
        }
    }
}
