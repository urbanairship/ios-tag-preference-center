/*
 Copyright 2017 Urban Airship and Contributors
 */

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        let hexScan = Scanner(string: hex)
        hexScan.scanLocation = 0
        
        var rgb: UInt64 = 0
        
        hexScan.scanHexInt64(&rgb)
        
        let red = (rgb & 0xff0000) >> 16
        let green = (rgb & 0xff00) >> 8
        let blue = rgb & 0xff
        
        self.init(red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: 1)
    }
}

/**
 * Allows for custom font and color styling of the UATagPreferencesViewController and UATagPreferencesViewCell
 */
public class UATagPreferencesStyle: NSCopying {
    
    // MARK: - Style Properties
    
    /**
     * (optional) the preference tag label font
     */
    public var preferenceLabelFont: UIFont?
    
    /**
     * (optional)  the preference tag label color
     */
    public var preferenceLabelColor: UIColor?
    
    /**
     * (optional)  the preference center title font
     */
    public var titleFont: UIFont?
    
    /**
     * (optional)  the preference center title color
     */
    public var titleColor: UIColor?
    
    /**
     * (optional) the table list color
     */
    public var listColor: UIColor?
    
    /**
     * (optional) the view's background color
     */
    public var backgroundColor: UIColor?
    
    /**
     * (optional) the cell separator color
     */
    public var cellSeparatorColor: UIColor?
    
    /**
     * (optional) the cell background color
     */
    public var cellBackgroundColor: UIColor?
    
    /**
     * (optional) the cell tint color
     */
    public var cellSwitchOffTintColor: UIColor?
    
    /**
     * (optional) the preference switch on color
     */
    public var cellSwitchOnColor: UIColor?
    
    /**
     * (optional) the close button font
     */
    public var closeButtonFont: UIFont?
    
    /**
     * (optional) the close button color
     */
    public var closeButtonColor: UIColor?
    
    public static let defaultFontName: String = "Helvetica Neue"
    public static let defaultFontSize: CGFloat = 17
    
    private static let defaultFileName = "UATagPreferenceCenterStyle"
    
    // MARK: - Initialization
    
    /**
     * Creates an instance of UATagPreferencesStyle with optional table and cell styles
     * All parameters are optional
     *
     * - parameters:
     *   - preferenceLabelFont: (optional) the preference tag label font
     *   - preferenceLabelColor: (optional)  the preference tag label color
     *   - titleFont: (optional)  the preference center title font
     *   - titleColor: (optional)  the preference center title color
     *   - listColor: (optional) the table listcolor
     *   - backgroundColor: (optional) the view's background color
     *   - cellSeparatorColor: (optional) the cell separator color
     *   - cellBackgroundColor: (optional) the cell background color
     *   - cellSwitchOffTintColor: (optional) the preference switch off tint color
     *   - cellSwitchOnColor: (optional) the preference switch on color
     *   - closeButtonFont: (optional) the close button font
     *   - closeButtonColor: (optional) the close button color
     */
    public init(preferenceLabelFont: UIFont = UIFont(name: UATagPreferencesStyle.defaultFontName, size: UATagPreferencesStyle.defaultFontSize)!,
         preferenceLabelColor: UIColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00),
         titleFont: UIFont = UIFont(name: UATagPreferencesStyle.defaultFontName, size: UATagPreferencesStyle.defaultFontSize)!,
         titleColor: UIColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00),
         listColor: UIColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00),
         backgroundColor: UIColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00),
         cellSeparatorColor: UIColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00),
         cellBackgroundColor: UIColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00),
         cellSwitchOffTintColor: UIColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00),
         cellSwitchOnColor: UIColor = UIColor(red:0.50, green:0.80, blue:0.99, alpha:1.00),
         closeButtonFont: UIFont = UIFont(name: UATagPreferencesStyle.defaultFontName, size: UATagPreferencesStyle.defaultFontSize)!,
         closeButtonColor: UIColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00)
         ) {
        
        self.preferenceLabelFont = preferenceLabelFont
        self.preferenceLabelColor = preferenceLabelColor
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.listColor = listColor
        self.backgroundColor = backgroundColor
        self.cellSeparatorColor = cellSeparatorColor
        self.cellBackgroundColor = cellBackgroundColor
        self.cellSwitchOffTintColor = cellSwitchOffTintColor
        self.cellSwitchOnColor = cellSwitchOnColor
        self.closeButtonFont = closeButtonFont
        self.closeButtonColor = closeButtonColor
        
    }
    
    /**
     * Creates an instance of UATagPreferencesStyle from a dictionary of
     * property strings and corresponding font/color attributes
     *
     * - parameters:
     *   - styles: (required) a dictionary of property strings and corresponding fonts or color attributes
     */
    convenience init(styles: [String: AnyObject]) {
        self.init()
        
        for (property, value) in styles {
            switch property {
            case stylePropertyKeys.preferenceLabelFont.rawValue:
                if let font = value as? UIFont {
                    self.preferenceLabelFont = font
                }
            case stylePropertyKeys.preferenceLabelColor.rawValue:
                if let color = value as? UIColor {
                    self.preferenceLabelColor = color
                }
            case stylePropertyKeys.titleFont.rawValue:
                if let font = value as? UIFont {
                    self.titleFont = font
                }
            case stylePropertyKeys.titleColor.rawValue:
                if let color = value as? UIColor {
                    self.titleColor = color
                }
            case stylePropertyKeys.listColor.rawValue:
                if let color = value as? UIColor {
                    self.listColor = color
                }
            case stylePropertyKeys.backgroundColor.rawValue:
                if let color = value as? UIColor {
                    self.backgroundColor = color
                }
            case stylePropertyKeys.cellSeparatorColor.rawValue:
                if let color = value as? UIColor {
                    self.cellSeparatorColor = color
                }
            case stylePropertyKeys.cellBackgroundColor.rawValue:
                if let color = value as? UIColor {
                    self.cellBackgroundColor = color
                }
            case stylePropertyKeys.cellSwitchOffTintColor.rawValue:
                if let color = value as? UIColor {
                    self.cellSwitchOffTintColor = color
                }
            case stylePropertyKeys.cellSwitchOnColor.rawValue:
                if let color = value as? UIColor {
                    self.cellSwitchOnColor = color
                }
            case stylePropertyKeys.closeButtonFont.rawValue:
                if let font = value as? UIFont {
                    self.closeButtonFont = font
                }
            case stylePropertyKeys.closeButtonColor.rawValue:
                if let color = value as? UIColor {
                    self.closeButtonColor = color
                }
            default:
                return
            }
        }
    }
    
    /**
     * Creates an instance of UATagPreferencesStyle from a plist file
     *
     * - parameters:
     *   - contentsOfFile: (required) a dictionary of property strings and corresponding fonts or color attributes
     */
    public convenience init(contentsOfFile: String) {
        self.init()
        
        let filePath = Bundle.main.path(forResource: contentsOfFile, ofType: "plist")
        
        if filePath != nil {
            
            self.getStyleFromFile(named: filePath!)
            
        } else {
            NSLog("ERROR: cannot find plist file with name \(contentsOfFile). Using defaults")
            self.setDefaults()
        }
    }
    
    // MARK: - Style Utilities
    
    /**
     * Returns all preferences in dictionary form
     */
    public func getStyleDict() -> [String: AnyObject] {
        var dictToReturn = [String: AnyObject]()
        
        dictToReturn[stylePropertyKeys.preferenceLabelFont.rawValue] = self.preferenceLabelFont
        dictToReturn[stylePropertyKeys.preferenceLabelColor.rawValue] = self.preferenceLabelColor
        dictToReturn[stylePropertyKeys.titleFont.rawValue] = self.titleFont
        dictToReturn[stylePropertyKeys.titleColor.rawValue] = self.titleColor
        dictToReturn[stylePropertyKeys.listColor.rawValue] = self.listColor
        dictToReturn[stylePropertyKeys.backgroundColor.rawValue] = self.backgroundColor
        dictToReturn[stylePropertyKeys.cellSeparatorColor.rawValue] = self.cellSeparatorColor
        dictToReturn[stylePropertyKeys.cellBackgroundColor.rawValue] = self.cellBackgroundColor
        dictToReturn[stylePropertyKeys.cellSwitchOffTintColor.rawValue] = self.cellSwitchOffTintColor
        dictToReturn[stylePropertyKeys.cellSwitchOnColor.rawValue] = self.cellSwitchOnColor
        dictToReturn[stylePropertyKeys.closeButtonFont.rawValue] = self.closeButtonFont
        dictToReturn[stylePropertyKeys.closeButtonColor.rawValue] = self.closeButtonColor
        
        return dictToReturn
    }
    
    /**
     * Creates a copy instance
     */
    public func copy(with zone: NSZone? = nil) -> Any {
        let copyStyle = UATagPreferencesStyle(styles: self.getStyleDict())
        return copyStyle
    }
    
    // MARK: - Private Methods
    
    private func setDefaults() {
        
        if let defaultFilePath = UATagPreferenceCenter.getResourceBundle()?.path(forResource: UATagPreferencesStyle.defaultFileName, ofType: "plist") {
            self.getStyleFromFile(named: defaultFilePath)
        } else {
            // if no default plist is found
            self.preferenceLabelFont = UIFont(name: UATagPreferencesStyle.defaultFontName, size: UATagPreferencesStyle.defaultFontSize)!
            self.preferenceLabelColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00)
            self.titleFont = UIFont(name: UATagPreferencesStyle.defaultFontName, size: UATagPreferencesStyle.defaultFontSize)!
            self.titleColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00)
            self.listColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
            self.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
            self.cellSeparatorColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00)
            self.cellBackgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
            self.cellSwitchOffTintColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00)
            self.cellSwitchOnColor = UIColor(red:0.50, green:0.80, blue:0.99, alpha:1.00)
            self.closeButtonFont = UIFont(name: UATagPreferencesStyle.defaultFontName, size: UATagPreferencesStyle.defaultFontSize)!
            self.closeButtonColor = UIColor(red:0.31, green:0.46, blue:0.56, alpha:1.00)
        }
    }
    
    private func getStyleFromFile(named: String) {
        let styles = NSDictionary(contentsOfFile: named)
        
        if styles != nil {
            self.validateStyleDict(with: styles!)
        }
    }
    
    private func validateStyleDict(with styleDict: NSDictionary) {
        for (styleName, styleValue) in styleDict {
            
            // check if value is a font
            if let styleFont = styleValue as? NSDictionary {
                
                var fontName = UATagPreferencesStyle.defaultFontName
                var fontSize = UATagPreferencesStyle.defaultFontSize
                
                if let name = styleFont[stylePropertyKeys.fontName.rawValue] as? String {
                    let strippedName = name.trimmingCharacters(in: .whitespaces)
                    
                    if strippedName != "" {
                        fontName = strippedName
                    }
                }
                
                if let sizeString = styleFont[stylePropertyKeys.fontSize.rawValue] as? String {
                    if let sizeNumber = NumberFormatter().number(from: sizeString) {
                        if CGFloat(sizeNumber.doubleValue) > 0 {
                            fontSize = CGFloat(sizeNumber.doubleValue)
                        }
                    }
                }
                
                let finalFont = UIFont(name: fontName, size: fontSize)
                
                if let name = styleName as? String {
                    switch name {
                    case stylePropertyKeys.preferenceLabelFont.rawValue:
                        self.preferenceLabelFont = finalFont
                    case stylePropertyKeys.titleFont.rawValue:
                        self.titleFont = finalFont
                    case stylePropertyKeys.closeButtonFont.rawValue:
                        self.closeButtonFont = finalFont
                    default:
                        NSLog("ERROR: Invalid font key supplied: \(styleName)")
                        
                    }
                }
            } else if let styleColor = styleValue as? String {
                if let color = self.convertHexToColor(hex: styleColor) {
                    
                    if let name = styleName as? String {
                        switch name {
                        case stylePropertyKeys.preferenceLabelColor.rawValue:
                            self.preferenceLabelColor = color
                        case stylePropertyKeys.titleColor.rawValue:
                            self.titleColor = color
                        case stylePropertyKeys.listColor.rawValue:
                            self.listColor = color
                        case stylePropertyKeys.backgroundColor.rawValue:
                            self.backgroundColor = color
                        case stylePropertyKeys.cellSeparatorColor.rawValue:
                            self.cellSeparatorColor = color
                        case stylePropertyKeys.cellBackgroundColor.rawValue:
                            self.cellBackgroundColor = color
                        case stylePropertyKeys.cellSwitchOffTintColor.rawValue:
                            self.cellSwitchOffTintColor = color
                        case stylePropertyKeys.cellSwitchOnColor.rawValue:
                            self.cellSwitchOnColor = color
                        case stylePropertyKeys.closeButtonColor.rawValue:
                            self.closeButtonColor = color
                        default:
                            NSLog("ERROR: Invalid font key supplied: \(styleName)")
                        }
                    }
                }
            }
        }
    }
    
    private func convertHexToColor(hex: String) -> UIColor? {
        
        if hex != "" && hex.hasPrefix("#") {
            let strippedHex = String(hex[hex.index(hex.startIndex, offsetBy: 1)..<hex.endIndex])
            return UIColor(hex: strippedHex)
        } else {
            NSLog("UAERROR: Invalid hex value provided: \(hex)")
            return nil
        }
    }
    
}
