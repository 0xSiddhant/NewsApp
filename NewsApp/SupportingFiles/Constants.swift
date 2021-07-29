//
//  Constants.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

import Foundation

enum Categories: String, CaseIterable {
    case business,
         entertainment,
         general,
         health,
         science,
         sports,
         technology
    
    var title: String {
        return rawValue.capitalized
    }
    
    var imageName: String {
        switch self {
        case .business:
            return "personalhotspot"
        case .entertainment:
            return "camera.metering.center.weighted"
        case .science:
            return "gyroscope"
        case .sports:
            return "gamecontroller.fill"
        case .health:
            return "heart.text.square.fill"
        case .general:
            return "text.bubble.fill"
        case .technology:
            return "network"
        }
    }
    
}

enum Lanugages: String, CaseIterable, SettingModel {
    case ar,
         de,
         en,
         es,
         fr,
         he,
         it,
         nl,
         no,
         pt,
         ru,
         se,
         zh
    
    var fullName: String {
        switch self {
        case .ar: return "Arabic"
        case .de: return "German"
        case .en: return "English"
        case .es: return "Spanish"
        case .fr: return "French"
        case .he: return "Hebrew"
        case .it: return "Italian"
        case .nl: return "Dutch"
        case .no: return "Norwegian"
        case .pt: return "Portuguese"
        case .ru: return "Russian"
        case .se: return "Sami"
        case .zh: return "Chinese"
        }
    }
}

enum Countries: String, CaseIterable, SettingModel {
    case ae,
         ar,
         au,
         be,
         bg,
         br,
         ca,
         ch,
         cn,
         co,
         cu,
         cz,
         de,
         eg,
         fr,
         gb,
         gr,
         hk,
         hu,
         id,
         ie,
         il,
         `in`,
         it,
         jp,
         kr,
         lt,
         lv,
         ma,
         mx,
         my,
         ng,
         nl,
         nz,
         ph,
         pl,
         pt,
         ro,
         rs,
         ru,
         sa,
         se,
         sg,
         si,
         sk,
         th,
         tr,
         tw,
         ua,
         us,
         ve,
         za
    
    var fullName: String {
        switch self {
        
        case .ae: return "United Arab Emirates"
        case .ar: return "Argentina"
        case .au: return "Australia"
        case .be: return "Belgium"
        case .bg: return "Bulgaria"
        case .br: return "Brazil"
        case .ca: return "Canada"
        case .ch: return "Switzerland"
        case .cn: return "China"
        case .co: return "Colombia"
        case .cu: return "Cuba"
        case .cz: return "Czechia"
        case .de: return "Germany"
        case .eg: return "Egypt"
        case .fr: return "France"
        case .gb: return "United Kingdom"
        case .gr: return "Greece"
        case .hk: return "Hong Kong"
        case .hu: return "Hungary"
        case .id: return "Indonesia"
        case .ie: return "Ireland"
        case .il: return "Israel"
        case .in: return "India"
        case .it: return "Italy"
        case .jp: return "Japan"
        case .kr: return "South Korea"
        case .lt: return "Lithuania"
        case .lv: return "Latvia"
        case .ma: return "Maldives"
        case .mx: return "Mexico"
        case .my: return "Malaysia"
        case .ng: return "Nigeria"
        case .nl: return "Netherlands"
        case .nz: return "New Zealand"
        case .ph: return "Philippines"
        case .pl: return "Poland"
        case .pt: return "Portugal"
        case .ro: return "Romania"
        case .rs: return "Serbia"
        case .ru: return "Russia"
        case .sa: return "South Africa"
        case .se: return "Sweden"
        case .sg: return "Singapore"
        case .si: return "Slovenia"
        case .sk: return "Slovakia"
        case .th: return "Thailand"
        case .tr: return "Turkey"
        case .tw: return "Taiwan"
        case .ua: return "Ukraine"
        case .us: return "United States"
        case .ve: return "Venezuela"
        case .za: return "South Africa"
        }
    }
}
