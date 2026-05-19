//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Kingfisher
import SwiftUI

struct NotificationCell: View {
    @EnvironmentObject var viewModel: NotificationsViewModel
    private let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }

    var body: some View {
        HStack {

            NavigationLink(value: notification.user) {
                CircularProfileImageView(user: notification.user, size: .xSmall)
            }
            // notification message

            Text(
                "\(Text(notification.user?.username ?? "").font(.subheadline).fontWeight(.semibold)) \(Text(notification.type.notificationMessage).font(.subheadline)) \(Text(notification.timestamp.timestampString()).foregroundStyle(.gray).font(.footnote))"
            )

            Spacer()

            if notification.type != .follow {
                if let post = notification.post {
                    NavigationLink(value: post) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipped()
                            .padding(.leading, 2)
                    }
                }
            } else {
                Button {
                    followButtonTapped()
                } label: {
                    Text(buttonTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 100, height: 32)
                        .foregroundStyle(buttonForegroundColor)
                        .background(buttonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(buttonBorderColor, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal)
    }
}

private extension NotificationCell {
    var notifiationIndex: Int? {
        return viewModel.notifications.firstIndex(where: { $0.id == notification.id })
    }
    
    func followButtonTapped() {
        guard let relationState = notification.user?.userRelationState else { return }
        
        switch relationState {
        case .notFollowed:
            viewModel.follow(for: notification, with: notifiationIndex)
        case .followed:
            viewModel.unfollow(for: notification, with: notifiationIndex)
        case .requestedToFollow:
            print("DEBUG: Remove follow request")
        default:
            break
        }
    }
}

private extension NotificationCell {
    private var buttonTitle: String {
        guard let relationState = notification.user?.userRelationState else { return "Loading" }

        switch relationState {
        case .unknown: 
            return "Loading..."
        case .isCurrentUser:
            return "Edit Profile"
        case .notFollowed:
            return "Follow"
        case .followed:
            return "Following"
        case .requestedToFollow:
            return "Requested"
        case .blocked:
            return "Blocked"
        }
    }
    
    private var buttonBackground: Color {
        guard let relationState = notification.user?.userRelationState else { return .white }
        
        switch relationState {
        case .notFollowed:
            return .blue
        default:
            return .white
        }
    }
    
    private var buttonForegroundColor: Color {
        guard let relationState = notification.user?.userRelationState else { return .black }
        switch relationState {
        case .notFollowed:
            return .white
        default:
            return .black
        }
    }
    
    private var buttonBorderColor: Color {
        guard let relationState = notification.user?.userRelationState else { return .gray }
        
        switch relationState {
        case .notFollowed:
            return.clear
        default:
            return .gray
        }
    }
}

#Preview {
    NotificationCell(notification: DeveloperPreview.shared.notifications[0])
}
