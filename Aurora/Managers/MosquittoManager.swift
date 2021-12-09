//
//  MosquittoManager.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import CocoaMQTT
import Foundation

enum ApiTopic: String {
  case aurora_text_msg = "aurora_text_msg"
}

enum ConnectionState {
  case disconnected
  case connected
}

class MosquittoManager: ObservableObject {

  var mqttClient: CocoaMQTT?
  var connectionState: ConnectionState = .disconnected
  var subscribedTopics: [String] = []
  let realmManager: RealmManager

  init(realmManager: RealmManager) {
    self.realmManager = realmManager
    mqttSetup()
  }

  func mqttSetup() {
    mqttClient = CocoaMQTT(clientID: UIDevice.current.identifierForVendor?.uuidString ?? "default", host: "frqsaldanha.com", port: 1883)
    mqttClient?.username = ""
    mqttClient?.password = ""
    mqttClient?.willMessage  = CocoaMQTTMessage(topic: ApiTopic.aurora_text_msg.rawValue, string: "\(AppSettings.getUserName() ?? "??????") left the chat")
    mqttClient?.keepAlive = 60
    mqttClient?.delegate = self
    mqttClient?.autoReconnect = true

    connect()
  }

  func connect() {
    if self.connectionState == .connected {
      log.debug("Connect called while already connected!")
      return
    }

    if mqttClient?.connect() == true {
      log.debug("Connect called successfully")
    } else {
      log.debug("Something went wrong while calling connect!!!")
    }
  }

  func disconnect() {
    log.debug("Disconnect called")
    mqttClient?.disconnect()
  }

  func startObservingTopics() {
    mqttClient?.subscribe(ApiTopic.aurora_text_msg.rawValue)
    subscribedTopics.append(ApiTopic.aurora_text_msg.rawValue)
  }

  func publish(_ request: ApiTopic, message: String = "") {
    mqttClient?.publish(request.rawValue, withString: message)
  }

  func unsubscribeAll() {
    mqttClient?.unsubscribe(subscribedTopics)
  }

  func sendMessage(deviceId: String, username: String, timestamp: Double, content: String, type: Int) {
    let model = MQTTChatModel(deviceId: deviceId, username: username, timestamp: timestamp, content: content, type: type)
    publish(.aurora_text_msg, message: model.toJson())
  }
}

extension MosquittoManager: CocoaMQTTDelegate {
  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
    log.debug("didSubscribeTopics: \(success)")
  }

  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    log.debug("didUnsubscribeTopics: \(topics)")
  }


  func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {

    if ack == .accept {
      self.connectionState = .connected
      log.debug("didConnectAck: \(ack.description)")

      startObservingTopics()
      sendMessage(deviceId: UIDevice().deviceId, username: "\(AppSettings.getUserName() ?? "??????")", timestamp: Date().millisecondsSince1970, content: "\(AppSettings.getUserName() ?? "??????") entered the chat", type: ChatMessageType.textUser.rawValue)
    }
  }

  func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    log.debug("didPublishMessage Topic: \(message.topic) Message: \(message.string ?? "---")")
  }

  func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    log.debug("didPublishAck \(id)")
  }

  func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
    log.debug("didReceiveMessage Topic: \(message.topic) Message: \(message.string ?? "---")")
    if message.topic == ApiTopic.aurora_text_msg.rawValue {
      let model = MQTTChatModel(jsonString: message.string ?? "")
      realmManager.createMessage(deviceId: model.deviceId, username: model.username, timestamp: model.timestamp, content: model.content, type: ChatMessageType(rawValue: model.type) ?? .textUser)
    }
  }

  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
    log.debug("didSubscribeTopic \(topic)")
  }

  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    log.debug("didUnsubscribeTopic \(topic)")
  }

  func mqttDidPing(_ mqtt: CocoaMQTT) {
    log.debug("mqttDidPing")
  }

  func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    log.debug("mqttDidReceivePong")
  }

  func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    self.connectionState = .disconnected
    if let error  = err {
      log.error("mqttDidDisconnect with error: \(error)")
    } else {
      log.debug("mqttDidDisconnect")
    }
  }
}
