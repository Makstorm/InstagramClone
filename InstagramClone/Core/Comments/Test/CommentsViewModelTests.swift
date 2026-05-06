//
//  CommentViewModelTests.swift
//  InstagramCloneTests
//
//  Created by Maxym Horobets on 05.05.2026.
//

import XCTest
@testable import InstagramClone

@MainActor
final class CommentsViewModelTests: XCTestCase {
    private var viewModel: CommentsViewModel!
    private var post: Post!
    private var mockCommentService: MockCommentService!
    private var mockUserService: MockUserService!
    private var currentUser: User!
    
    override func setUp() {
        super.setUp()
        
        self.post = MockData.posts[0]
        self.mockCommentService = MockCommentService(postId: post.id)
        self.mockUserService = MockUserService()
        self.currentUser = MockData.users[0]
        
        viewModel = CommentsViewModel(
            post: post,
            commentService: mockCommentService,
            userService: mockUserService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockCommentService = nil
        mockUserService = nil
        post = nil
        currentUser = nil
        
        super.tearDown()
    }
    
    func testFetchComments_Success() async {
        XCTAssertEqual(viewModel.loadingState, .loading)
        
        await viewModel.fetchComments()
        let commentUsers = viewModel.comments.map { $0.user }
        
        XCTAssertFalse(viewModel.comments.isEmpty)
        XCTAssertFalse(commentUsers.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .complete)
    }
    
    func testFetchComments_Failure() async {
        self.mockCommentService.errorToThrow = NSError(domain: "", code: -1)
        
        await viewModel.fetchComments()
        
        XCTAssertTrue(viewModel.comments.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .error)
    }
    
    func testEmptyState_Success() async {
        mockCommentService.shouldTestEmptyState = true
        
        await viewModel.fetchComments()
        
        XCTAssertEqual(viewModel.loadingState, .empty)
    }
    
    func testUploadComment_Success() async {
        let commentText = "New test comment"
        
        await viewModel.uploadComment(commentText: commentText, currentUser: currentUser)
        
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertEqual(viewModel.comments.first?.commnetText, commentText)
        XCTAssertNotNil(viewModel.comments.first?.user)
        XCTAssertEqual(viewModel.comments.first?.user?.id, currentUser.id)
    }
    
    func testUploadComment_Failure() async {
       let commentText = "New test comment"
        mockCommentService.errorToThrow = NSError(domain: "", code: -1)
        
        await viewModel.uploadComment(commentText: commentText, currentUser: currentUser)
        
        XCTAssertTrue(viewModel.comments.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .error)
    }
}

class MockCommentService: CommentServiceProtocol {
    var postId: String
    var errorToThrow: Error?
    var shouldTestEmptyState = false
    
    init(postId: String) {
        self.postId = postId
    }
    
    func uploadComment(commentText: String, postOwnerUid: String) async throws -> Comment {
        if let errorToThrow { throw errorToThrow }
        
        return Comment(
            id: "123",
            postOwnerUid: postOwnerUid,
            commnetText: commentText,
            postId: MockData.posts[0].id,
            timestamp: Date(),
            commentOwnerUid: ""
        )
    }
    
    func fetchComments() async throws -> [Comment] {
        if let errorToThrow { throw errorToThrow }
        
        if shouldTestEmptyState {
            return []
        } else {
            return MockData.comments
        }
    }
}
