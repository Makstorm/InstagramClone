//
//  FeedViewModelTests.swift
//  InstagramCloneTests
//
//  Created by Maxym Horobets on 09.05.2026.
//

import XCTest
@testable import InstagramClone

@MainActor
final class FeedViewModelTests: XCTestCase {
    var viewModel: FeedViewModel!
    var mockFeedService: MockFeedService!
    var mockLikeService: MockLikePostService!
    var mockPostSaveService: MockSavePostService!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockLikeService = MockLikePostService()
        mockPostSaveService = MockSavePostService()
        mockFeedService = MockFeedService()
        mockUserService = MockUserService()
        
        viewModel = FeedViewModel(
            feedService: mockFeedService,
            userService: mockUserService,
            likePostService: mockLikeService,
            savePostService: mockPostSaveService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockFeedService = nil
        mockLikeService = nil
        mockPostSaveService = nil
        mockUserService = nil
        
        super.tearDown()
    }
    
    func testFetchFeedPosts() async {
        await viewModel.fetchPosts()
        
        XCTAssertFalse(viewModel.posts.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .complete)
        
        for post in viewModel.posts {
            XCTAssertNotNil(post.user)
            XCTAssertEqual(post.ownerUid, post.user?.id)
        }
    }
    
    func testRefreshPosts() async {
        viewModel.posts = []
        await viewModel.fetchPosts()
        let countBeforeRefresh = viewModel.posts.count
        
        await viewModel.refreshPosts()
        let countAfterRefresh = viewModel.posts.count
        
        XCTAssertEqual(countBeforeRefresh, countAfterRefresh)
    }
    
    func testLikePost() async {
        await viewModel.fetchPosts()
        let post = viewModel.posts[0]
        let likesBefore = post.likes
        
        await viewModel.like(post)
        XCTAssertTrue(viewModel.posts[0].didLike)
        XCTAssertEqual(viewModel.posts[0].likes, likesBefore + 1)
        XCTAssertTrue(mockLikeService.didCallLikePost)
    }
    
    func testUnlikePost() async {
        await viewModel.fetchPosts()
        viewModel.posts[0].likes += 1
        let post = viewModel.posts[0]
        
        let likesBefore = post.likes
        
        await viewModel.unlike(post)
        XCTAssertFalse(viewModel.posts[0].didLike)
        XCTAssertEqual(viewModel.posts[0].likes, likesBefore > 0 ? likesBefore - 1 : 0)
        XCTAssertTrue(mockLikeService.didCallUnlikePost)
    }
    
    func testUnlikePostNotNegative() async {
        await viewModel.fetchPosts()
        
        viewModel.posts[0].likes = 0
        let post = viewModel.posts[0]
        
        await viewModel.unlike(post)
        
        XCTAssertFalse(viewModel.posts[0].didLike)
        XCTAssertTrue(viewModel.posts[0].likes >= 0)
    }
    
    func testSavePost() async {
        await viewModel.fetchPosts()
        let post = viewModel.posts[0]
        
        await viewModel.save(post)
        
        XCTAssertTrue(viewModel.posts[0].didSave)
        XCTAssertTrue(mockPostSaveService.didCallSavePost)
    }
    
    func testUnsavePost() async {
        await viewModel.fetchPosts()
        let post = viewModel.posts[0]
        
        await viewModel.unsave(post)
        
        XCTAssertFalse(viewModel.posts[0].didSave)
        XCTAssertTrue(mockPostSaveService.didCallUnsavePost)
    }
}
