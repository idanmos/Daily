//
//  Coordinator.swift
//  Guard
//
//  Created by Idan Moshe on 20/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation

class Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []

    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = self.childCoordinators.firstIndex(of: coordinator) {
            self.childCoordinators.remove(at: index)
        } else {
            debugPrint("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }

    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        self.childCoordinators = self.childCoordinators.filter { $0 is T  == false }
    }

    func removeAllChildCoordinators() {
        self.childCoordinators.removeAll()
    }
    
}

extension Coordinator: Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
