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
        
        let img = UIImage(named: "\(passedPokemon.pokedexID)")
        mainImage.image = img
        currentEvoImage.image = img
        pokeDexIdLabel.text = "\(passedPokemon.pokedexID)"
        
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
        typeLabel.text = passedPokemon.type
        descriptionLabel.text = passedPokemon.description
        
        if passedPokemon.nextEvolutionId == "" {
            evoLabel.text = "No Evolutions"
            nextEvoImage.isHidden = true
        } else {
            nextEvoImage.isHidden = false
            nextEvoImage.image = UIImage(named: "\(passedPokemon.nextEvolutionId)")
            let evolutionText = "Next Evolution: \(passedPokemon.nextEvolutionName) - LVL \(passedPokemon.nextEvolutionLevel)"
            evoLabel.text = evolutionText
        }
        
        
    }
}
