//
//  KeyChainManager.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import Security
import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    func save(key: String, value: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else {
            print("Error: Could not encode value to Data.")
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error: Failed to save item to Keychain. Status code: \(status)")
        }
        return status == errSecSuccess
    }

    func get(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status != errSecSuccess {
            print("Error: Failed to retrieve item from Keychain. Status code: \(status)")
            return nil
        }

        guard let data = item as? Data else {
            print("Error: Retrieved item is not of type Data.")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error: Failed to delete item from Keychain. Status code: \(status)")
        }
        return status == errSecSuccess
    }
}
