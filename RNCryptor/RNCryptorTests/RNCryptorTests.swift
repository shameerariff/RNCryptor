//
//  RNCryptorTests.swift
//  RNCryptorTests
//
//  Created by Rob Napier on 6/12/15.
//  Copyright © 2015 Rob Napier. All rights reserved.
//

import XCTest
import RNCryptor

let kGoodPassword = "Passw0rd!"
let kBadPassword = "NotThePassword"


extension String {
    public func dataFromHexString() -> NSData? {
        // Based on: http://stackoverflow.com/a/2505561/313633
        let data = NSMutableData()

        let input = self.stringByReplacingOccurrencesOfString(" ", withString: "")
            .stringByReplacingOccurrencesOfString("<", withString: "")
            .stringByReplacingOccurrencesOfString(">", withString: "")

        var string = ""

        for char in input.characters {
            string.append(char)
            if(string.characters.count == 2) {
                let scanner = NSScanner(string: string)
                var value: UInt32 = 0
                scanner.scanHexInt(&value)
                data.appendBytes(&value, length: 1)
                string = ""
            }
        }

        return data
    }
}

class RNCryptorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRandomData() {
        let len = 1024
        do {
            let data = try RNCryptor.randomDataOfLength(len)
            XCTAssertEqual(data.length, len)

            let secondData = try RNCryptor.randomDataOfLength(len)
            XCTAssertNotEqual(data, secondData, "Random data this long should never be equal")

        } catch {
            XCTFail("Failed: \(error)")
        }
    }

    func testKDF() {
        do {
            let password = "a"

            guard let salt = "0102030405060708".dataFromHexString() else { XCTFail(); return }
            let key = try RNCryptor.keyForPassword(password, salt: salt)

            guard let expect = "fc632b0c a6b23eff 9a9dc3e0 e585167f 5a328916 ed19f835 58be3ba9 828797cd".dataFromHexString() else { XCTFail(); return }
            XCTAssertEqual(key, expect)
        } catch  {
            XCTFail("Failed: \(error)")
        }
    }

    //    func testSimple() {
    //        do {
    //            let data = try RNCryptor.randomDataOfLength(1024)
    //            let encryptedData = try RNCryptor.encryptData(data, password: kGoodPassword)
    //            let decryptedData = try RNCryptor.decryptData(data, password: kGoodPassword)
    //            XCTAssertEqual(data, decryptedData)
    //        } catch {
    //            XCTFail("Encryption failed: \(error)")
    //        }
    //    }
    
}
