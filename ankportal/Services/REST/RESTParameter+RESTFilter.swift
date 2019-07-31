//
//  RESTParameter.swift
//  ankportal
//
//  Created by Admin on 30/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

let RESTFiltersDescription: [RESTFilter:String] = [
    .isNewProduct: "Новинка",
    .brandId: "Бренд",
    .article: "Артикул"
]

enum RESTFilter: String {
    case id = "id"
    case pageSize = "pagesize"
    case pageNumber = "PAGEN_1"
    case isNewProduct = "f_PROPERTY_IS_NEW.VALUE"
    case isTest = "test"
    case brandId = "f_PROPERTY_BRAND_ID"
    case sectionId = "f_SECTION_ID"
    case article = "f_PROPERTY_ARTICLE"
    case price = "f_CATALOG_PRICE_1"
    case priceLess = "f_<CATALOG_PRICE_1"
    case priceMore = "f_>CATALOG_PRICE_1"
    case priceNot = "f_!CATALOG_PRICE_1"
    
    func description() -> String? {
        return RESTFiltersDescription[self]
    }
}

class RESTParameter: CustomStringConvertible {
    
    private(set) var name: String
    private(set) var value: String
    
    var description: String = ""

    static func == (left: RESTParameter, right: RESTParameter) -> Bool {
        return left.serialize() == right.serialize()
    }
    
    static func != (left: RESTParameter, right: RESTParameter) -> Bool {
        return !(left == right)
    }
    
    convenience init(filter: RESTFilter, value: String) {
        self.init(name: filter.rawValue, value: value)
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    func set(value: String) {
        self.value = value
    }
    
    func set(value: Int) {
        self.value = "\(value)"
    }
    
    func serialize() -> String {
        return "&\(name)=\(value)"
    }
    
}

class RESTParameterANKPortalItem: RESTParameter {
    
    var ankportalItem: ANKPortalItemSelectable?
    
}
