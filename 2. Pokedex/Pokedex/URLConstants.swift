//
//  Constants.swift
//  Pokedex
//
//  Created by Ryan Kim on 6/7/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation

struct APPURL {
    private struct Domain {
        static let Pokemon = "http://pokeapi.co"
    }
    
    private struct Routes {
        static let Api = "/api/v1/"
        static let PokemonUrl = "pokemon/"
    }
    
    static let BaseURL = Domain.Pokemon + Routes.Api + Routes.PokemonUrl
    static let domainURL = Domain.Pokemon
}

typealias DownloadComplete = () -> ()
