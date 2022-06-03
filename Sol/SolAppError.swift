//
//  SolAppError.swift
//  Sol
//
//  Created by Júlio César Flores on 31/05/22.
//

import SwiftUI
import Combine
import Foundation

struct SolAppError {
    private static let notificationName = Notification.Name("SolAppError")
    private static let errorTag = "error"
    private static let cancelTag = "cancel"
    private static let retryTag = "retry"

    typealias Action = (() -> Void)
    fileprivate typealias ErrorPayload = (error: Error, cancel: Action, retry: Action)

    fileprivate static var handlingError: ErrorPayload?

    static func `throw`(error: Error, cancelAction: @escaping Action, retryAction: @escaping Action) {
        let notification = Notification(
            name: Self.notificationName,
            object: nil,
            userInfo: [Self.errorTag: error, Self.retryTag: retryAction, Self.cancelTag: cancelAction]
        )

        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }

    fileprivate static var publisher: AnyPublisher<ErrorPayload, Never> {
        NotificationCenter.default
            .publisher(for: Self.notificationName)
            .compactMap({
                guard let userInfo = $0.userInfo,
                      let error = userInfo[Self.errorTag] as? Error,
                      let cancelAction = userInfo[Self.cancelTag] as? Action,
                      let retryAction = userInfo[Self.retryTag] as? Action
                else {
                    return nil
                }

                return (error, cancelAction, retryAction)
            })
            .eraseToAnyPublisher()
    }

    private init() {}
}

extension View {
    func handleError(_ isHandlingError: Binding<Bool>, locale: LocaleService) -> some View {
        self.onReceive(SolAppError.publisher) { (error) in
            SolAppError.handlingError = error
            isHandlingError.wrappedValue = true
        }
        .alert(SolAppError.handlingError?.error.localizedDescription ?? "", isPresented: isHandlingError) {
            Button(locale["try again"]) {
                SolAppError.handlingError?.retry()
                SolAppError.handlingError = nil
                isHandlingError.wrappedValue = false
            }
            Button(locale["cancel"]) {
                SolAppError.handlingError?.cancel()
                SolAppError.handlingError = nil
                isHandlingError.wrappedValue = false
            }
        }
    }
}
