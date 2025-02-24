import Combine
@testable import CurexConverter
import Mocker
import Moya
@testable import NetworkManager
import XCTest

final class CurrentConverterAppTests: XCTestCase {
    var networkManager: RemoteDataSource!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []

        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        networkManager = NetworkManager(configuration: configuration)
    }

    override func tearDownWithError() throws {
        networkManager = nil
        cancellables = nil
        try super.tearDownWithError()
    }

    func testGetCurrencyDataSuccess() async throws {
        let url = URL(string: "https://api.apilayer.com/currency_data/list")!

        let mockData = """
            {
                "currencies": {
                    "USD": "United States Dollar",
                    "EUR": "Euro"
                },
                "success": true
            }
        """.data(using: .utf8)

        let mock = Mock(url: url, contentType: .json, statusCode: 200, data: [
            .get: mockData!,
        ])
        mock.register()

        do {
            let currencies = try await networkManager.getCurrencyData()
            XCTAssertEqual(currencies.currencies["USD"], "United States Dollar")
            XCTAssertEqual(currencies.currencies["EUR"], "Euro")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testConvertCurrencyData() async throws {
        let url = URL(string: "https://api.apilayer.com/currency_data/convert?amount=5&from=EUR&to=RUB")!

        let mockData = """
            {
              "info": {
                "quote": 111.087821,
                "timestamp": 1732627444
              },
              "query": {
                "amount": 5,
                "from": "EUR",
                "to": "RUB"
              },
              "result": 123.456789,
              "success": true
            }
        """.data(using: .utf8)

        let mock = Mock(url: url, contentType: .json, statusCode: 200, data: [
            .get: mockData!,
        ])
        mock.register()

        do {
            let convert = try await networkManager.convertCurrencyData(to: "RUB", from: "EUR", amount: 5)
            XCTAssertEqual(convert.result, 123.456789)
        } catch {
            XCTFail("Unexpected error: \(error)")
            print(String(data: mockData!, encoding: .utf8) ?? "Invalid Data")
        }
    }

    func testMoyaErrorUnderlying() async {
        let customError = MyAppError.networkError(additionalError: NSError(domain: "Test", code: 123, userInfo: nil))
        let moyaError: MoyaError = .underlying(customError, nil)

        if case let .underlying(underlyingError, _) = moyaError {
            if let myAppError = underlyingError as? MyAppError {
                switch myAppError {
                case let .networkError(additionalError):
                    if let nsError = additionalError as? NSError {
                        XCTAssertEqual(nsError.code, 123, "Unexpected error code")
                    } else {
                        XCTFail("Expected NSError, but got: \(additionalError)")
                    }
                default:
                    XCTFail("Expected networkError case, but got: \(myAppError)")
                }
            } else {
                XCTFail("Expected MyAppError, but got: \(underlyingError)")
            }
        } else {
            XCTFail("Expected MoyaError.underlying, but got: \(moyaError)")
        }
    }
}
