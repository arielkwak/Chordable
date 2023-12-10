//
//  Helper.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/9/23.
//
//  Adapeted from https://github.com/67443-Mobile-Apps/PriceScan_JSON_Starter/blob/main/PriceCheck/Resources/Helper.swift
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
