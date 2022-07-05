struct C {
    struct AppInfo {
        static let appName = "🌍Pangaea"
        static let primaryColor = "orangeColor"
        static let secondaryColor = "lightOrangeColor"
        
        static let cellIdetifier = "ReusebleCell"
        static let cellNibName = "CustomMessageCell"
        
        static let loginToChat = "LoginToChat"
        static let registerToChat = "RegisterToChat"
    }
    struct Firebase {
        static let collectionName = "messages"
        static let messageBodyField = "messageBody"
        static let senderField = "sender"
        static let dateField = "date"
    }
}
