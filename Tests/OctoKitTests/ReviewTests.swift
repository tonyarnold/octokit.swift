//
//  ReviewTests.swift
//  OctoKitTests
//
//  Created by Franco Meloni on 08/02/2020.
//  Copyright © 2020 nerdish by nature. All rights reserved.
//

import OctoKit
import XCTest

class ReviewTests: XCTestCase {
    func testReviews() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/pulls/1/reviews",
            method: .get,
            statusCode: 201,
            fileName: "reviews"
        )

        let reviews = try await Octokit(session: session).listReviews(owner: "octocat", repository: "Hello-World", pullRequestNumber: 1)
        let review = reviews.first
        XCTAssertEqual(review?.body, "Here is the body for the review.")
        XCTAssertEqual(review?.commitID, "ecdd80bb57125d7ba9641ffaa4d7d2c19d3f3091")
        XCTAssertEqual(review?.id, 80)
        XCTAssertEqual(review?.state, .approved)
        XCTAssertEqual(review?.submittedAt, Date(timeIntervalSince1970: 1_574_012_623.0))
        XCTAssertEqual(review?.user.avatarURL, "https://github.com/images/error/octocat_happy.gif")
        XCTAssertNil(review?.user.blog)
        XCTAssertNil(review?.user.company)
        XCTAssertNil(review?.user.email)
        XCTAssertEqual(review?.user.gravatarID, "")
        XCTAssertEqual(review?.user.id, 1)
        XCTAssertNil(review?.user.location)
        XCTAssertEqual(review?.user.login, "octocat")
        XCTAssertNil(review?.user.name)
        XCTAssertNil(review?.user.numberOfPublicGists)
        XCTAssertNil(review?.user.numberOfPublicRepos)
        XCTAssertNil(review?.user.numberOfPrivateRepos)
        XCTAssertEqual(review?.user.type, "User")
    }

    func testPostReview() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/pulls/1/reviews",
            method: .post,
            statusCode: 200,
            fileName: "review"
        )

        let review = try await Octokit(session: session).postReview(owner: "octocat",
                                                                    repository: "Hello-World",
                                                                    pullRequestNumber: 1,
                                                                    event: .approve)
        XCTAssertEqual(review.body, "Here is the body for the review.")
        XCTAssertEqual(review.commitID, "ecdd80bb57125d7ba9641ffaa4d7d2c19d3f3091")
        XCTAssertEqual(review.id, 80)
        XCTAssertEqual(review.state, .approved)
        XCTAssertEqual(review.submittedAt, Date(timeIntervalSince1970: 1_574_012_623.0))
        XCTAssertEqual(review.user.avatarURL, "https://github.com/images/error/octocat_happy.gif")
        XCTAssertNil(review.user.blog)
        XCTAssertNil(review.user.company)
        XCTAssertNil(review.user.email)
        XCTAssertEqual(review.user.gravatarID, "")
        XCTAssertEqual(review.user.id, 1)
        XCTAssertNil(review.user.location)
        XCTAssertEqual(review.user.login, "octocat")
        XCTAssertNil(review.user.name)
        XCTAssertNil(review.user.numberOfPublicGists)
        XCTAssertNil(review.user.numberOfPublicRepos)
        XCTAssertNil(review.user.numberOfPrivateRepos)
        XCTAssertEqual(review.user.type, "User")
    }
}
