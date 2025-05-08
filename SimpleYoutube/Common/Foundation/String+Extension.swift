//
//  String+Extension.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

extension String {
    func formatYouTubeDate() -> String {
        // 1. 將 ISO8601 字串轉為 Date
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // 可留可不留
        guard let date = isoFormatter.date(from: self) ?? ISO8601DateFormatter().date(from: self) else {
            return self // fallback
        }

        // 2. 將 Date 轉為指定格式字串
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current // 顯示為本地時間
        return formatter.string(from: date)
    }
}
