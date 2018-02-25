//
//  KnotSocketClientEvents.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/27/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: comment all new events
enum KnotSocketClientEvent: String {
    // MARK: Cases
    
    /// Emitted when the client connects. This is also called on a successful reconnection. A connect event gets one
    /// data item: the namespace that was connected to.
    ///
    /// ```swift
    /// socket.on(clientEvent: .connect) {data, ack in
    ///     guard let nsp = data[0] as? String else { return }
    ///     // Some logic using the nsp
    /// }
    /// ```
    case connect
    
    /// Emitted when the socket has disconnected and will not attempt to try to reconnect.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .disconnect) {data, ack in
    ///     // Some cleanup logic
    /// }
    /// ```
    case disconnect
    
    /// Emitted when an error occurs.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .error) {data, ack in
    ///     // Some logging
    /// }
    /// ```
    case error
    
    /// Emitted whenever the engine sends a ping.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .ping) {_, _ in
    ///   // Maybe keep track of latency?
    /// }
    /// ```
    case ping
    
    /// Emitted whenever the engine gets a pong.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .pong) {_, _ in
    ///   // Maybe keep track of latency?
    /// }
    /// ```
    case pong
    
    /// Emitted when the client begins the reconnection process.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .reconnect) {data, ack in
    ///     // Some reconnect event logic
    /// }
    /// ```
    case reconnect
    
    /// Emitted each time the client tries to reconnect to the server.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .reconnectAttempt) {data, ack in
    ///     // Some reconnect attempt logging
    /// }
    /// ```
    case reconnectAttempt
    
    /// Emitted every time there is a change in the client's status.
    ///
    /// Usage:
    ///
    /// ```swift
    /// socket.on(clientEvent: .statusChange) {data, ack in
    ///     // Some status changing logging
    /// }
    /// ```
    case statusChange
    
    case ready
    case notReady
    case identify
    case identity
    case devices
    case update
}
