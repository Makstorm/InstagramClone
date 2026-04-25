//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Kingfisher
import SwiftUI

struct NotificationCell: View {

    let notification: Notification

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
                NavigationLink(value: notification.post) {
                    KFImage(URL(string: notification.post?.imageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .padding(.leading, 2)
                }
            } else {
                Button {
                    print("DEBUG: Handle follow here")
                } label: {
                    Text("Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 88, height: 32)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

            }

        }
        .padding(.horizontal)
    }
}

#Preview {
    NotificationCell(notification: DeveloperPreview.shared.notifications[0])
}
