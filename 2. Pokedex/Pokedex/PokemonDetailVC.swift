//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Ryan Kim on 6/7/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokeDexIdLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!

    var passedPokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = passedPokemon.name.capitalized
        passedPokemon.downloadPokemonDetail { 
            self.updateUI()
        }
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func updateUI() {
        attackLabel.text = passedPokemon.attack
        defenseLabel.text = passedPokemon.defense
        weightLabel.text = passedPokemon.weight
        heightLabel.text = passedPokemon.height
        nameLabel.text = passedPokemon.name
    }
}
