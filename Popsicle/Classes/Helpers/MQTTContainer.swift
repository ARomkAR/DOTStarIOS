//
//  MQTTContainer.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import Foundation
import CocoaMQTT

struct Message {
    private static let messageFormat = "{\"state\":false,\"index\":0,\"brightness\":172.00,\"color\":{<color>}}"
    let state: Bool
    let index: Int
    let brightness: Double
    let color: UIColor
    let format: UIColor.Format

    var message: String? {

        guard let colorString = self.color.represent(in: self.format)?.stringFormatted else { return nil }

        return "{\"state\":\(self.state),\"index\":\(self.index),\"brightness\":\(String(format: "%.2f", brightness)),\"color\":{\(colorString)}}"
    }
}

final class MQTTContainer {

    enum Topics: String {
        case update = "lights/POPULED/update"
        case announce = "lights/POPULED/announce"
        case deviceStatus = "lights/POPULED/deviceStatus"
        case acknoledgement = "lights/POPULED/acknoledgement"
    }

    typealias PixelColor = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat)
    private typealias WorkItem = (message: DispatchWorkItem, path: String)

    private static let messageFormat = "{\"state\":false,\"index\":0,\"brightness\":172.00,\"color\":{<color>}}"
    private static let colorFragment = "<color>"

    private static let shared = MQTTContainer()

    private var mqtt: CocoaMQTT
    private var workItem: WorkItem?

    private init() {
        let clientID = "Home-:" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "", port: 1)
        mqtt.username = ""
        mqtt.password = ""
        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.keepAlive = 60
        mqtt.delegate = self
        mqtt.autoReconnect = true
    }

    static func start(with completion: (_ status: Bool)-> Void) {

        let status = shared.mqtt.connect()
        completion(status)
    }

    static func send(message: Message) {

        guard let formattedMessage = message.message else { return }

        if shared.mqtt.connState != .connected {
            let item = DispatchWorkItem {

                shared.mqtt.publish(Topics.update.rawValue,
                                    withString: formattedMessage,
                                    qos: .qos1,
                                    retained: true,
                                    dup: false)
            }

            shared.workItem = (message: item, path: formattedMessage)
            shared.mqtt.connect()
        } else {
            shared.mqtt.publish("lights/POPULED/update",
                                withString: formattedMessage,
                                qos: .qos1,
                                retained: true,
                                dup: false)
        }
    }
}

extension MQTTContainer: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        /// Validate the server certificate
        ///
        /// Some custom validation...
        ///
        /// if validatePassed {
        ///     completionHandler(true)
        /// } else {
        ///     completionHandler(false)
        /// }
        completionHandler(true)
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")

        if ack == .accept {
            mqtt.subscribe(Topics.announce.rawValue, qos: CocoaMQTTQOS.qos0)
            mqtt.subscribe(Topics.deviceStatus.rawValue, qos: CocoaMQTTQOS.qos0)
            mqtt.subscribe(Topics.acknoledgement.rawValue, qos: CocoaMQTTQOS.qos0)

            if let workItem = MQTTContainer.shared.workItem {
                workItem.message.perform()
            }
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string ?? "")")

        if MQTTContainer.shared.workItem?.path == message.string {
            MQTTContainer.shared.workItem = nil
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string ?? "") with id \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("didPing")
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        _console("mqttDidDisconnect")
        mqtt.disconnect()
    }

    private func _console(_ info: String) {
        print("Delegate: \(info)")
    }
}

