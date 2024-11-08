import XCTest
import Combine
@testable import CurrentConverterApp
@testable import NetworkManager

/*final class CurrentConverterAppTests: XCTestCase {
    var networkManager: NetworkManager!
    var cancellables: Set<AnyCancellable>!
    var mockSession: MyMockSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
        mockSession = MyMockSession()
        networkManager = NetworkManager(networkSession: mockSession)
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testGetCurrencyDataSuccess() async throws {
        mockSession.mockData = """
            {
                "currencies": {
                    "USD": "United States Dollar",
                    "EUR": "Euro"
                },
            "success": true
            }
            """.data(using: .utf8)
        
        let result = try await networkManager.getCurrencyData()
        XCTAssertEqual(result.currencies["USD"], "United States Dollar")
    }
    
    func testGetCurrencyDataBadBadServerResponse() async throws {
        
        mockSession.error = URLError(.badServerResponse)
        
        do {
            _ = try await networkManager.getCurrencyData()
            XCTFail("Expected URLError with .badServerResponse, but no error was thrown")
        } catch let error as MyAppError {
            switch error {
            case .networkError(let additionalError as URLError):
                XCTAssertEqual(additionalError.code, .badServerResponse)
            default:
                XCTFail("Expected MyAppError.networkError, but got a different MyAppError: \(error)")
            }
        } catch {
            XCTFail("Expected MyAppError.networkError, but got a different error: \(error)")
        }
    }
    
    func testGetCurrencyDataBadURL() async throws {
        mockSession.error = URLError(.badURL)
        
        do {
            _ = try await networkManager.getCurrencyData()
            XCTFail("Expected URLError with .badServerResponse, but no error was thrown")
        } catch let error as MyAppError {
            switch error {
            case .networkError(let additionalError as URLError):
                XCTAssertEqual(additionalError.code, .badURL)
            default:
                XCTFail("Expected MyAppError.networkError, but got a different MyAppError: \(error)")
            }
        } catch {
            XCTFail("Expected MyAppError.networkError, but got a different error: \(error)")
        }
    }
}*/
