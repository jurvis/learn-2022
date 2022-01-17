import UIKit

// Returning multipole values from functions
func getUser() -> (firstName: String, lastName: String) {
    ("Taylor", "Swift")
}

let user = getUser()

print("Name: \(user.firstName)")

// Error Handling

enum PasswordError: Error {
    case short, obvious
}

func checkPassword(_ password: String) throws -> String {
    if password.count < 5 {
        throw PasswordError.short
    }
    
    if password == "12345" {
            throw PasswordError.obvious
    }

    if password.count < 8 {
        return "OK"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}

do {
    let res = try checkPassword("12345")
    print ("Password rating: \(res)")
} catch PasswordError.short {
    print("Please use longer password")
} catch PasswordError.obvious {
    print("Too easy")
} catch {
    print("Error")
}

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

luckyNumbers.filter { $0 % 2 != 0 }.sorted().map{ print("\($0) is a lucky number ")}



