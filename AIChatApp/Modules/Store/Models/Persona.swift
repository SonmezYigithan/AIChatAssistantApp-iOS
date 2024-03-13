//
//  Persona.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 11.03.2024.
//

import UIKit

struct Persona {
    let name: String
    let description: String
    let prompt: String
    let image: String?
    let greetingMessage: String
}

struct PersonaPresenter {
    let name: String
    let description: String
    let image: String?
}
