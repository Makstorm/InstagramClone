//
//  FollowRequestsViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import Foundation
import Combine

@MainActor
class FollowRequestsViewModel: ObservableObject {
    @Published var requests = [FollowRequest]()
    @Published var loadingState: ContentLoadingState = .loading
    
    private let followRequestService: FollowRequestServiceProtocol
    private let userService: UserServiceProtocol
    
    init(followRequestService: FollowRequestServiceProtocol, userService: UserServiceProtocol) {
        self.followRequestService = followRequestService
        self.userService = userService
    }
    
    func fetchRequests() async {
        do {
            requests = try await followRequestService.fetchFollowRequests()
            try await fetchUserDataForRequests(requests)
            loadingState = requests.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
        }
    }
    
    func accept(_ request: FollowRequest) async {
        guard let index = removeRequestOptimistically(request) else { return }
        do {
            try await followRequestService.accept(request)
        } catch {
            requests.insert(request, at: index)
            print("DEBUG: Failed to accept request with error: \(error.localizedDescription)")
        }
    }
    
    func reject(_ request: FollowRequest) async {
        guard let index = removeRequestOptimistically(request) else { return }
        do {
            try await followRequestService.reject(request)
        } catch {
            requests.insert(request, at: index)
            print("DEBUG: Failed to accept request with error: \(error.localizedDescription)")
        }
    }
    
    private func removeRequestOptimistically(_ request: FollowRequest) -> Int? {
        guard let index = requests.firstIndex(where: { $0.id == request.id }) else { return nil }
        requests.remove(at: index)
        
        if requests.isEmpty {
            loadingState = .empty
        }
        
        return index
    }
    
    private func fetchUserDataForRequests(_ requests: [FollowRequest]) async throws {
        var result = requests
        
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            for (index, request) in result.enumerated() {
                guard let self else { return }
                
                group.addTask {
                    let user = try await self.userService.fetchUser(withUid: request.fromUserId)
                    return (index, user)
                }
            }
            
            for try await (index, user) in group {
                result[index].user = user
            }
        }
        
        self.requests = result
    }
}
