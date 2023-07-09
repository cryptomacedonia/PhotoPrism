//
//  AppData.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 5.7.23.
//

import Foundation

// MARK: - AppData
struct AppData: Codable {
    let config: Config?
    let data: DataClass?
    let id: String?
    let provider: String?
    let status: String?
    let user: User?
    static func getMeSomeSampleData() -> AppData {
        return try! JSONDecoder().decode(Self.self, from: Data(sampleJson.utf8))
    }
}

// MARK: - Config
struct Config: Codable {
    let mode: String?
    let name: String?
    let about: String?
    let edition: String?
    let version: String?
    let copyright: String?
    let flags: String?
    let baseUri: String?
    let staticUri: String?
    let cssUri: String?
    let jsUri: String?
    let manifestUri: String?
    let apiUri: String?
    let contentUri: String?
    let videoUri: String?
    let wallpaperUri: String?
    let siteUrl: String?
    let siteDomain: String?
    let siteAuthor: String?
    let siteTitle: String?
    let siteCaption: String?
    let siteDescription: String?
    let sitePreview: String?
    let legalInfo: String?
    let legalUrl: String?
    let appName: String?
    let appMode: String?
    let appIcon: String?
    let appColor: String?
    let restart: Bool?
    let debug: Bool?
    let trace: Bool?
    let test: Bool?
    let demo: Bool?
    let sponsor: Bool?
    let readonly: Bool?
    let uploadNSFW: Bool?
    let configPublic: Bool?
    let authMode: String?
    let usersPath: String?
    let loginUri: String?
    let registerUri: String?
    let passwordLength: Int?
    let passwordResetUri: String?
    let experimental: Bool?
    let albumCategories: [String]?
    let albums: [Album]?
    let cameras: [Camera]?
    let lenses: [Lense]?
    let countries: [Country]?
    let people: [Person]?
    let thumbs: [Thumb]?
    let tier: Int?
    let membership: String?
    let customer: String?
    let mapKey: String?
    let downloadToken: String?
    let previewToken: String?
    let disable: Disable?
    let count: Count?
    let pos: Pos?
    let years: [Int]?
    let colors: [Color]?
    let categories: [Category]?
    let clip: Int?
    let server: Server?
    let settings: Settings?
    let acl: ACL?
    let ext: EXT?
}

// MARK: - ACL
struct ACL: Codable {
    let albums: Albums?
    let calendar: Albums?
    let config: Albums?
    let aclDefault: Albums?
    let favorites: Albums?
    let feedback: Albums?
    let files: Albums?
    let folders: Albums?
    let labels: Albums?
    let logs: Albums?
    let moments: Albums?
    let password: Albums?
    let people: Albums?
    let photos: Albums?
    let places: Albums?
    let services: Albums?
    let settings: Albums?
    let shares: Albums?
    let users: Albums?
    let videos: Albums?
}

// MARK: - Albums
struct Albums: Codable {
    let accessAll: Bool?
    let accessLibrary: Bool?
    let create: Bool?
    let delete: Bool?
    let download: Bool?
    let fullAccess: Bool?
    let manage: Bool?
    let rate: Bool?
    let react: Bool?
    let share: Bool?
    let subscribe: Bool?
    let update: Bool?
}

// MARK: - Album
struct Album: Codable {
    let id: Int?
    let uid: String?
    let slug: String?
    let type: String?
    let title: String?
    let location: String?
    let category: String?
    let caption: String?
    let description: String?
    let notes: String?
    let filter: String?
    let order: String?
    let template: String?
    let state: String?
    let country: String?
    let year: Int?
    let month: Int?
    let day: Int?
    let favorite: Bool?
    let albumPrivate: Bool?
    let thumb: String?
    let createdBy: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
}

// MARK: - Camera
struct Camera: Codable {
    let id: Int?
    let slug: String?
    let name: String?
    let make: String?
    let model: String?
}

// MARK: - Category
struct Category: Codable {
    let uid: String?
    let slug: String?
    let name: String?
}

// MARK: - Color
struct Color: Codable {
    let example: String?
    let name: String?
    let slug: String?
}

// MARK: - Count
struct Count: Codable {
    let all: Int?
    let photos: Int?
    let live: Int?
    let videos: Int?
    let cameras: Int?
    let lenses: Int?
    let countries: Int?
    let hidden: Int?
    let favorites: Int?
    let review: Int?
    let stories: Int?
    let countPrivate: Int?
    let albums: Int?
    let privateAlbums: Int?
    let moments: Int?
    let privateMoments: Int?
    let months: Int?
    let privateMonths: Int?
    let states: Int?
    let privateStates: Int?
    let folders: Int?
    let privateFolders: Int?
    let files: Int?
    let people: Int?
    let places: Int?
    let labels: Int?
    let labelMaxPhotos: Int?
}

// MARK: - Country
struct Country: Codable {
    let id: String?
    let slug: String?
    let name: String?
}

// MARK: - Disable
struct Disable: Codable {
    let webdav: Bool?
    let settings: Bool?
    let places: Bool?
    let backups: Bool?
    let tensorflow: Bool?
    let faces: Bool?
    let classification: Bool?
    let sips: Bool?
    let ffmpeg: Bool?
    let exiftool: Bool?
    let darktable: Bool?
    let rawtherapee: Bool?
    let imagemagick: Bool?
    let heifconvert: Bool?
    let vectors: Bool?
    let jpegxl: Bool?
    let raw: Bool?
}

// MARK: - EXT
struct EXT: Codable {
    let plus: Plus?
}

// MARK: - Plus
struct Plus: Codable {
}

// MARK: - Lense
struct Lense: Codable {
    let id: Int?
    let slug: String?
    let name: String?
    let make: String?
    let model: String?
    let type: String?
}

// MARK: - Person
struct Person: Codable {
    let uid: String?
    let name: String?
    let keywords: [String]?
}

// MARK: - Pos
struct Pos: Codable {
    let uid: String?
    let cid: String?
    let utc: String?
    let lat: Double?
    let lng: Double?
}

// MARK: - Server
struct Server: Codable {
    let cores: Int?
    let routines: Int?
    let memory: Memory?
}

// MARK: - Memory
struct Memory: Codable {
    let total: Int?
    let free: Int?
    let used: Int?
    let reserved: Int?
    let info: String?
}

// MARK: - Settings
struct Settings: Codable {
    let ui: UI?
    let search: Search?
    let maps: Maps?
    let features: Features?
    let settingsImport: Import?
    let index: Index?
    let stack: Stack?
    let share: Share?
    let download: Download?
    let templates: Templates?
}

// MARK: - Download
struct Download: Codable {
    let name: String?
    let disabled: Bool?
    let originals: Bool?
    let mediaRaw: Bool?
    let mediaSidecar: Bool?
}

// MARK: - Features
struct Features: Codable {
    let account: Bool?
    let albums: Bool?
    let archive: Bool?
    let delete: Bool?
    let download: Bool?
    let edit: Bool?
    let estimates: Bool?
    let favorites: Bool?
    let files: Bool?
    let folders: Bool?
    let featuresImport: Bool?
    let labels: Bool?
    let library: Bool?
    let logs: Bool?
    let moments: Bool?
    let people: Bool?
    let places: Bool?
    let featuresPrivate: Bool?
    let ratings: Bool?
    let reactions: Bool?
    let review: Bool?
    let search: Bool?
    let services: Bool?
    let settings: Bool?
    let share: Bool?
    let upload: Bool?
    let videos: Bool?
}

// MARK: - Index
struct Index: Codable {
    let path: String?
    let convert: Bool?
    let rescan: Bool?
    let skipArchived: Bool?
}

// MARK: - Maps
struct Maps: Codable {
    let animate: Int?
    let style: String?
}

// MARK: - Search
struct Search: Codable {
    let batchSize: Int?
}

// MARK: - Import
struct Import: Codable {
    let path: String?
    let move: Bool?
}

// MARK: - Share
struct Share: Codable {
    let title: String?
}

// MARK: - Stack
struct Stack: Codable {
    let uuid: Bool?
    let meta: Bool?
    let name: Bool?
}

// MARK: - Templates
struct Templates: Codable {
    let templatesDefault: String?
}

// MARK: - UI
struct UI: Codable {
    let scrollbar: Bool?
    let zoom: Bool?
    let theme: String?
    let language: String?
    let timeZone: String?
}

// MARK: - Thumb
struct Thumb: Codable {
    let size: String?
    let use: String?
    let w: Int?
    let h: Int?
}

// MARK: - DataClass
struct DataClass: Codable {
    let tokens: [String]?
    let shares: [String]?
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let uid: String?
    let authProvider: String?
    let authID: String?
    let name: String?
    let displayName: String?
    let email: String?
    let role: String?
    let attr: String?
    let superAdmin: Bool?
    let canLogin: Bool?
    let loginAt: String?
    let webDAV: Bool?
    let basePath: String?
    let uploadPath: String?
    let canInvite: Bool?
    let details: Details?
    let settings: SettingsClass?
    let thumb: String?
    let thumbSrc: String?
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - Details
struct Details: Codable {
    let birthYear: Int?
    let birthMonth: Int?
    let birthDay: Int?
    let nameTitle: String?
    let givenName: String?
    let middleName: String?
    let familyName: String?
    let nameSuffix: String?
    let nickName: String?
    let nameSrc: String?
    let gender: String?
    let about: String?
    let bio: String?
    let location: String?
    let country: String?
    let phone: String?
    let siteURL: String?
    let profileURL: String?
    let orgTitle: String?
    let orgName: String?
    let orgEmail: String?
    let orgPhone: String?
    let orgURL: String?
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - SettingsClass
struct SettingsClass: Codable {
    let createdAt: String?
    let updatedAt: String?
}


let sampleJson = """
{
    "config": {
        "mode": "user",
        "name": "Demo",
        "about": "PhotoPrism®",
        "edition": "plus",
        "version": "230629-11e7d3f0d-Linux-AMD64-Plus",
        "copyright": "(c) 2018-2023 PhotoPrism UG. All rights reserved.",
        "flags": "public demo sponsor experimental settings",
        "baseUri": "",
        "staticUri": "https://demo-cdn.photoprism.app/static",
        "cssUri": "https://demo-cdn.photoprism.app/static/build/app.80ce31321a737d047b91.css",
        "jsUri": "https://demo-cdn.photoprism.app/static/build/app.b7772e8b1bed2d5d829b.js",
        "manifestUri": "/manifest.json?ff70543a",
        "apiUri": "/api/v1",
        "contentUri": "https://demo-cdn.photoprism.app/api/v1",
        "videoUri": "https://demo-cdn.photoprism.app/api/v1",
        "wallpaperUri": "https://demo-cdn.photoprism.app/static/img/wallpaper/welcome.jpg",
        "siteUrl": "https://demo.photoprism.app/",
        "siteDomain": "demo.photoprism.app",
        "siteAuthor": "PhotoPrism UG",
        "siteTitle": "PhotoPrism+",
        "siteCaption": "Demo",
        "siteDescription": "AI-Powered Photos App for the Decentralized Web",
        "sitePreview": "https://i.photoprism.app/prism",
        "legalInfo": "",
        "legalUrl": "",
        "appName": "Demo",
        "appMode": "standalone",
        "appIcon": "logo",
        "appColor": "#000000",
        "restart": false,
        "debug": false,
        "trace": false,
        "test": false,
        "demo": true,
        "sponsor": true,
        "readonly": false,
        "uploadNSFW": false,
        "public": true,
        "authMode": "public",
        "usersPath": "users",
        "loginUri": "/library/browse",
        "registerUri": "",
        "passwordLength": 0,
        "passwordResetUri": "",
        "experimental": true,
        "albumCategories": null,
        "albums": [
            {
                "ID": 2,
                "UID": "artisl61ivvteyk1",
                "Slug": "california",
                "Type": "album",
                "Title": "California",
                "Location": "",
                "Category": "",
                "Caption": "",
                "Description": "",
                "Notes": "",
                "Filter": "",
                "Order": "oldest",
                "Template": "",
                "State": "",
                "Country": "zz",
                "Year": 0,
                "Month": 0,
                "Day": 0,
                "Favorite": true,
                "Private": false,
                "Thumb": "e4d493c81905b0267976c1e8446f9fe33bbad832",
                "CreatedBy": "urtir4e5t5p1yoqg",
                "CreatedAt": "2023-04-22T14:07:54Z",
                "UpdatedAt": "2023-04-22T14:07:59.138137001Z",
                "DeletedAt": null
            }
        ],
        "cameras": [
            {
                "ID": 5,
                "Slug": "apple-iphone-4s",
                "Name": "Apple iPhone 4S",
                "Make": "Apple",
                "Model": "iPhone 4S"
            },
            {
                "ID": 7,
                "Slug": "apple-iphone-5s",
                "Name": "Apple iPhone 5s",
                "Make": "Apple",
                "Model": "iPhone 5s"
            },
            {
                "ID": 8,
                "Slug": "apple-iphone-6",
                "Name": "Apple iPhone 6",
                "Make": "Apple",
                "Model": "iPhone 6"
            },
            {
                "ID": 11,
                "Slug": "apple-iphone-8",
                "Name": "Apple iPhone 8",
                "Make": "Apple",
                "Model": "iPhone 8"
            },
            {
                "ID": 9,
                "Slug": "apple-iphone-se",
                "Name": "Apple iPhone SE",
                "Make": "Apple",
                "Model": "iPhone SE"
            },
            {
                "ID": 2,
                "Slug": "canon-eos-5d",
                "Name": "Canon EOS 5D",
                "Make": "Canon",
                "Model": "EOS 5D"
            },
            {
                "ID": 6,
                "Slug": "canon-eos-6d",
                "Name": "Canon EOS 6D",
                "Make": "Canon",
                "Model": "EOS 6D"
            },
            {
                "ID": 4,
                "Slug": "canon-eos-7d",
                "Name": "Canon EOS 7D",
                "Make": "Canon",
                "Model": "EOS 7D"
            },
            {
                "ID": 10,
                "Slug": "huawei-p30",
                "Name": "HUAWEI P30",
                "Make": "HUAWEI",
                "Model": "P30"
            },
            {
                "ID": 3,
                "Slug": "olympus-c2500l",
                "Name": "Olympus C2500L",
                "Make": "Olympus",
                "Model": "C2500L"
            },
            {
                "ID": 1,
                "Slug": "zz",
                "Name": "Unknown",
                "Make": "",
                "Model": "Unknown"
            }
        ],
        "lenses": [
            {
                "ID": 3,
                "Slug": "24",
                "Name": "24",
                "Make": "",
                "Model": "24",
                "Type": ""
            },
            {
                "ID": 7,
                "Slug": "100",
                "Name": "100",
                "Make": "",
                "Model": "100",
                "Type": ""
            },
            {
                "ID": 8,
                "Slug": "apple-iphone-5s-back-camera-4-12mm-f-2-2",
                "Name": "Apple iPhone 5s back camera 4.12mm f/2.2",
                "Make": "Apple",
                "Model": "iPhone 5s back camera 4.12mm f/2.2",
                "Type": ""
            },
            {
                "ID": 10,
                "Slug": "apple-iphone-6-back-camera-4-15mm-f-2-2",
                "Name": "Apple iPhone 6 back camera 4.15mm f/2.2",
                "Make": "Apple",
                "Model": "iPhone 6 back camera 4.15mm f/2.2",
                "Type": ""
            },
            {
                "ID": 12,
                "Slug": "apple-iphone-8-back-camera-3-99mm-f-1-8",
                "Name": "Apple iPhone 8 back camera 3.99mm f/1.8",
                "Make": "Apple",
                "Model": "iPhone 8 back camera 3.99mm f/1.8",
                "Type": ""
            },
            {
                "ID": 11,
                "Slug": "apple-iphone-se-back-camera-4-15mm-f-2-2",
                "Name": "Apple iPhone SE back camera 4.15mm f/2.2",
                "Make": "Apple",
                "Model": "iPhone SE back camera 4.15mm f/2.2",
                "Type": ""
            },
            {
                "ID": 4,
                "Slug": "ef100mm-f-2-8l-macro-is-usm",
                "Name": "EF100mm f/2.8L Macro IS USM",
                "Make": "",
                "Model": "EF100mm f/2.8L Macro IS USM",
                "Type": ""
            },
            {
                "ID": 6,
                "Slug": "ef16-35mm-f-2-8l-ii-usm",
                "Name": "EF16-35mm f/2.8L II USM",
                "Make": "",
                "Model": "EF16-35mm f/2.8L II USM",
                "Type": ""
            },
            {
                "ID": 5,
                "Slug": "ef24-105mm-f-4l-is-usm",
                "Name": "EF24-105mm f/4L IS USM",
                "Make": "",
                "Model": "EF24-105mm f/4L IS USM",
                "Type": ""
            },
            {
                "ID": 9,
                "Slug": "ef35mm-f-2-is-usm",
                "Name": "EF35mm f/2 IS USM",
                "Make": "",
                "Model": "EF35mm f/2 IS USM",
                "Type": ""
            },
            {
                "ID": 2,
                "Slug": "ef70-200mm-f-4l-is-usm",
                "Name": "EF70-200mm f/4L IS USM",
                "Make": "",
                "Model": "EF70-200mm f/4L IS USM",
                "Type": ""
            },
            {
                "ID": 1,
                "Slug": "zz",
                "Name": "Unknown",
                "Make": "",
                "Model": "Unknown",
                "Type": ""
            }
        ],
        "countries": [
            {
                "ID": "at",
                "Slug": "austria",
                "Name": "Austria"
            },
            {
                "ID": "bw",
                "Slug": "botswana",
                "Name": "Botswana"
            },
            {
                "ID": "ca",
                "Slug": "canada",
                "Name": "Canada"
            },
            {
                "ID": "cu",
                "Slug": "cuba",
                "Name": "Cuba"
            },
            {
                "ID": "fr",
                "Slug": "france",
                "Name": "France"
            },
            {
                "ID": "de",
                "Slug": "germany",
                "Name": "Germany"
            },
            {
                "ID": "gr",
                "Slug": "greece",
                "Name": "Greece"
            },
            {
                "ID": "it",
                "Slug": "italy",
                "Name": "Italy"
            },
            {
                "ID": "za",
                "Slug": "south-africa",
                "Name": "South Africa"
            },
            {
                "ID": "ch",
                "Slug": "switzerland",
                "Name": "Switzerland"
            },
            {
                "ID": "gb",
                "Slug": "united-kingdom",
                "Name": "United Kingdom"
            },
            {
                "ID": "us",
                "Slug": "usa",
                "Name": "USA"
            },
            {
                "ID": "zz",
                "Slug": "zz",
                "Name": "Unknown"
            }
        ],
        "people": [
            {
                "UID": "jrx9tgqtif45icjx",
                "Name": "Tim robbins",
                "Keywords": [
                    "tim",
                    "robbins"
                ]
            },
            {
                "UID": "jrx9go33mzd2uw2v",
                "Name": "Yo",
                "Keywords": [
                    "yo"
                ]
            }
        ],
        "thumbs": [
            {
                "size": "fit_720",
                "use": "Mobile, TV",
                "w": 720,
                "h": 720
            },
            {
                "size": "fit_1280",
                "use": "Mobile, HD Ready TV",
                "w": 1280,
                "h": 1024
            },
            {
                "size": "fit_1920",
                "use": "Mobile, Full HD TV",
                "w": 1920,
                "h": 1200
            },
            {
                "size": "fit_2048",
                "use": "Tablets, Cinema 2K",
                "w": 2048,
                "h": 2048
            },
            {
                "size": "fit_2560",
                "use": "Quad HD, Retina Display",
                "w": 2560,
                "h": 1600
            },
            {
                "size": "fit_3840",
                "use": "Ultra HD",
                "w": 3840,
                "h": 2400
            },
            {
                "size": "fit_4096",
                "use": "Ultra HD, Retina 4K",
                "w": 4096,
                "h": 4096
            },
            {
                "size": "fit_7680",
                "use": "8K Ultra HD 2, Retina 6K",
                "w": 7680,
                "h": 4320
            }
        ],
        "tier": 8,
        "membership": "plus",
        "customer": "",
        "mapKey": "l59pjCkMNkYFwV6zyvqB",
        "downloadToken": "public",
        "previewToken": "public",
        "disable": {
            "webdav": true,
            "settings": false,
            "places": false,
            "backups": false,
            "tensorflow": false,
            "faces": false,
            "classification": false,
            "sips": true,
            "ffmpeg": false,
            "exiftool": false,
            "darktable": false,
            "rawtherapee": false,
            "imagemagick": false,
            "heifconvert": false,
            "vectors": false,
            "jpegxl": false,
            "raw": false
        },
        "count": {
            "all": 155,
            "photos": 150,
            "live": 3,
            "videos": 2,
            "cameras": 10,
            "lenses": 11,
            "countries": 12,
            "hidden": 0,
            "favorites": 2,
            "review": 4,
            "stories": 0,
            "private": 4,
            "albums": 6,
            "private_albums": 0,
            "moments": 5,
            "private_moments": 0,
            "months": 46,
            "private_months": 0,
            "states": 19,
            "private_states": 0,
            "folders": 25,
            "private_folders": 0,
            "files": 314,
            "people": 2,
            "places": 51,
            "labels": 36,
            "labelMaxPhotos": 32
        },
        "pos": {
            "uid": "prx0zsv10aj5megb",
            "cid": "s2:47a85a622504",
            "utc": "2023-04-21T09:08:53Z",
            "lat": 52.45151901245117,
            "lng": 13.308182716369629
        },
        "years": [
            2023,
            2022,
            2021,
            2020,
            2019,
            2018,
            2017,
            2016,
            2015,
            2014,
            2013,
            2012,
            2011,
            2010,
            2002
        ],
        "colors": [
            {
                "Example": "#AB47BC",
                "Name": "Purple",
                "Slug": "purple"
            },
            {
                "Example": "#FF00FF",
                "Name": "Magenta",
                "Slug": "magenta"
            },
            {
                "Example": "#EC407A",
                "Name": "Pink",
                "Slug": "pink"
            },
            {
                "Example": "#EF5350",
                "Name": "Red",
                "Slug": "red"
            },
            {
                "Example": "#FFA726",
                "Name": "Orange",
                "Slug": "orange"
            },
            {
                "Example": "#D4AF37",
                "Name": "Gold",
                "Slug": "gold"
            },
            {
                "Example": "#FDD835",
                "Name": "Yellow",
                "Slug": "yellow"
            },
            {
                "Example": "#CDDC39",
                "Name": "Lime",
                "Slug": "lime"
            },
            {
                "Example": "#66BB6A",
                "Name": "Green",
                "Slug": "green"
            },
            {
                "Example": "#009688",
                "Name": "Teal",
                "Slug": "teal"
            },
            {
                "Example": "#00BCD4",
                "Name": "Cyan",
                "Slug": "cyan"
            },
            {
                "Example": "#2196F3",
                "Name": "Blue",
                "Slug": "blue"
            },
            {
                "Example": "#A1887F",
                "Name": "Brown",
                "Slug": "brown"
            },
            {
                "Example": "#F5F5F5",
                "Name": "White",
                "Slug": "white"
            },
            {
                "Example": "#9E9E9E",
                "Name": "Grey",
                "Slug": "grey"
            },
            {
                "Example": "#212121",
                "Name": "Black",
                "Slug": "black"
            }
        ],
        "categories": [
            {
                "UID": "lrx0zs42i8czvimm",
                "Slug": "animal",
                "Name": "Animal"
            },
            {
                "UID": "lrx0zsh25n5hpk56",
                "Slug": "architecture",
                "Name": "Architecture"
            },
            {
                "UID": "lrx0zsskx1lxqzb3",
                "Slug": "beach",
                "Name": "Beach"
            },
            {
                "UID": "lrx0zsa150hoax7h",
                "Slug": "beetle",
                "Name": "Beetle"
            },
            {
                "UID": "lrx0zs63bcizxmnh",
                "Slug": "bird",
                "Name": "Bird"
            },
            {
                "UID": "lrx0zs33n7gwup8s",
                "Slug": "building",
                "Name": "Building"
            },
            {
                "UID": "lrx0zs2eai5e7fvp",
                "Slug": "car",
                "Name": "Car"
            },
            {
                "UID": "lrx0zs5ssqn4tb0z",
                "Slug": "cat",
                "Name": "Cat"
            },
            {
                "UID": "lrx0zsc2xrinvlqt",
                "Slug": "farm",
                "Name": "Farm"
            },
            {
                "UID": "lrx0zs537jsnlfm6",
                "Slug": "insect",
                "Name": "Insect"
            },
            {
                "UID": "lrx0zs325ocjwotf",
                "Slug": "landscape",
                "Name": "Landscape"
            },
            {
                "UID": "lrx0zse29svpki5l",
                "Slug": "monkey",
                "Name": "Monkey"
            },
            {
                "UID": "lrx0zs335kizwqjr",
                "Slug": "mountain",
                "Name": "Mountain"
            },
            {
                "UID": "lrx0zs2371tlihr2",
                "Slug": "nature",
                "Name": "Nature"
            },
            {
                "UID": "lrx0zsv2l7damgsk",
                "Slug": "people",
                "Name": "People"
            },
            {
                "UID": "lrx0zs2yhlux46gh",
                "Slug": "plant",
                "Name": "Plant"
            },
            {
                "UID": "lrx0zsj20oygmfvd",
                "Slug": "reptile",
                "Name": "Reptile"
            },
            {
                "UID": "lrx0zs23hwv06fr7",
                "Slug": "shop",
                "Name": "Shop"
            },
            {
                "UID": "lrx0zsf2msdhgv5h",
                "Slug": "snow",
                "Name": "Snow"
            },
            {
                "UID": "lrx0zsh1uciqh9k5",
                "Slug": "tower",
                "Name": "Tower"
            },
            {
                "UID": "lrx0zs22zpiqxwzp",
                "Slug": "vehicle",
                "Name": "Vehicle"
            },
            {
                "UID": "lrx0zsjlkmzcotom",
                "Slug": "water",
                "Name": "Water"
            },
            {
                "UID": "lrx0zsaiqa7p8xck",
                "Slug": "wildlife",
                "Name": "Wildlife"
            }
        ],
        "clip": 160,
        "server": {
            "cores": 24,
            "routines": 105,
            "memory": {
                "total": 135059107840,
                "free": 21501997056,
                "used": 77106776,
                "reserved": 448152688,
                "info": "Used 77 MB / Reserved 448 MB"
            }
        },
        "settings": {
            "ui": {
                "scrollbar": true,
                "zoom": false,
                "theme": "nordic",
                "language": "en",
                "timeZone": ""
            },
            "search": {
                "batchSize": 0
            },
            "maps": {
                "animate": 2500,
                "style": ""
            },
            "features": {
                "account": true,
                "albums": true,
                "archive": true,
                "delete": true,
                "download": true,
                "edit": true,
                "estimates": false,
                "favorites": true,
                "files": true,
                "folders": true,
                "import": true,
                "labels": true,
                "library": true,
                "logs": true,
                "moments": true,
                "people": true,
                "places": true,
                "private": true,
                "ratings": true,
                "reactions": true,
                "review": false,
                "search": true,
                "services": true,
                "settings": true,
                "share": true,
                "upload": true,
                "videos": true
            },
            "import": {
                "path": "/",
                "move": false
            },
            "index": {
                "path": "/",
                "convert": true,
                "rescan": true,
                "skipArchived": false
            },
            "stack": {
                "uuid": true,
                "meta": true,
                "name": true
            },
            "share": {
                "title": ""
            },
            "download": {
                "name": "file",
                "disabled": false,
                "originals": true,
                "mediaRaw": true,
                "mediaSidecar": false
            },
            "templates": {
                "default": "index.gohtml"
            }
        },
        "acl": {
            "albums": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "calendar": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "config": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "default": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "favorites": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "feedback": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "files": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "folders": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "labels": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "logs": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "moments": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "password": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "people": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "photos": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "places": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "services": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "settings": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "shares": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "users": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            },
            "videos": {
                "access_all": true,
                "access_library": true,
                "create": true,
                "delete": true,
                "download": true,
                "full_access": true,
                "manage": true,
                "rate": true,
                "react": true,
                "share": true,
                "subscribe": true,
                "update": true
            }
        },
        "ext": {
            "plus": {}
        }
    },
    "data": {
        "tokens": null,
        "shares": null
    },
    "id": "234200000000000000000000000000000000000000000000",
    "provider": "",
    "status": "ok",
    "user": {
        "ID": 1,
        "UID": "urx0zrt8c15sfd2d",
        "AuthProvider": "local",
        "AuthID": "",
        "Name": "admin",
        "DisplayName": "Admin",
        "Email": "",
        "Role": "admin",
        "Attr": "",
        "SuperAdmin": true,
        "CanLogin": true,
        "LoginAt": null,
        "WebDAV": true,
        "BasePath": "",
        "UploadPath": "",
        "CanInvite": true,
        "Details": {
            "BirthYear": 0,
            "BirthMonth": 0,
            "BirthDay": 0,
            "NameTitle": "",
            "GivenName": "",
            "MiddleName": "",
            "FamilyName": "",
            "NameSuffix": "",
            "NickName": "",
            "NameSrc": "",
            "Gender": "",
            "About": "",
            "Bio": "",
            "Location": "",
            "Country": "",
            "Phone": "",
            "SiteURL": "",
            "ProfileURL": "",
            "OrgTitle": "",
            "OrgName": "",
            "OrgEmail": "",
            "OrgPhone": "",
            "OrgURL": "",
            "CreatedAt": "2023-06-29T17:40:41.047116845Z",
            "UpdatedAt": "2023-06-29T17:40:41.04749802Z"
        },
        "Settings": {
            "CreatedAt": "2023-07-04T18:49:30.657403942Z",
            "UpdatedAt": "2023-07-04T18:49:30.657403942Z"
        },
        "Thumb": "",
        "ThumbSrc": "",
        "CreatedAt": "2023-06-29T17:40:41.045911955Z",
        "UpdatedAt": "2023-06-29T17:40:41.045911955Z"
    }
}
"""
