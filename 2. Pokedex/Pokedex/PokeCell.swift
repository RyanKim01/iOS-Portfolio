//
//  PokeCell.swift
//  Pokedex
//
//  Created by Ryan Kim on 6/7/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon) {

        self.pokemon = pokemon
        thumbImg.image = UIImage(named: "\(pokemon.pokedexID)")
        nameLabel.text = pokemon.name.capitalized
    }
}
