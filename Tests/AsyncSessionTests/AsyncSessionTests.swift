import XCTest
@testable import AsyncSession

final class AsyncSessionTests: XCTestCase {
    
    var sut: AsyncSession!
    
    override func setUp() {
        super.setUp()
        sut = AsyncSession()
    }
    
    func testCheckHTTPMethods() {
        XCTAssertTrue(AsyncSession.Method.get.rawValue == "GET")
        XCTAssertTrue(AsyncSession.Method.post.rawValue == "POST")
        XCTAssertTrue(AsyncSession.Method.put.rawValue == "PUT")
        XCTAssertTrue(AsyncSession.Method.delete.rawValue == "DELETE")
    }
    
    func testHeaders() throws {
        let request = try sut.request(url: URL(string: "https://ww.mtdtechnology.net/api")!, method: .get, headers: ["header_key": "header_value"])
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        XCTAssertTrue(request.allHTTPHeaderFields?["header_key"] == "header_value")
    }
    
    func testBody() throws {
        let body = SomeBodyMock.mock()
        let request = try sut.request(url: URL(string: "https://ww.mtdtechnology.net/api")!, method: .get, headers: ["header_key": "header_value"], body: body)
        XCTAssertNotNil(request.httpBody)
        let value = try JSONDecoder().decode(SomeBodyMock.self, from: request.httpBody!)
        XCTAssertEqual(value.title, "title")
    }
}
