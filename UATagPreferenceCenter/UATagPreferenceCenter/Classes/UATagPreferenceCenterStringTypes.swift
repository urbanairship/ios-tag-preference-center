/*
 Copyright 2017 Urban Airship and Contributors
 */

enum endPoint: String {
    case channel = "channels"
}

enum saveKeys: String {
    case preferences
    case preferenceTags
    case preferenceNames
    case preferenceTagGroups
    case title = "preferenceCenterTitle"
    case style = "preferenceCenterStyle"
}

enum apiKeys: String {
    case channel
    case tagGroups = "tag_groups"
    case tags
    case displayNames
    case preferences
    case title
}

enum jsonKeys: String {
    case channel
    case tagGroup
    case tag
    case displayName
    case preferences
    case title
}

enum stylePropertyKeys: String {
    case fontName
    case fontSize
    case preferenceLabelFont
    case preferenceLabelColor
    case titleFont
    case titleColor
    case listColor
    case backgroundColor
    case cellSeparatorColor
    case cellBackgroundColor
    case cellSwitchOffTintColor
    case cellSwitchOnColor
    case closeButtonFont
    case closeButtonColor
}
