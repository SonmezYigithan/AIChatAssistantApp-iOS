//
//  PersonaImageManager.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 11.03.2024.
//

enum PersonaImage {
    case taylorSwift
    case walterWhite
    
    var personaImageString: String {
        switch self {
        case .taylorSwift:
            return "taylorswift"
        case .walterWhite:
            return "walterwhite"
        }
    }
}

import UIKit

class PersonaManager {
    // This is just a mock network class for fetching personas, later I will move it to the backend
    static let shared = PersonaManager()
    
    // TODO: Delete This
    func getPersonaImage(of personaName: String) -> UIImage? {
        if personaName == "Walter White" {
            return UIImage(named: "walterwhite")
        }else if personaName == "Taylor Swift" {
            return UIImage(named: "taylorswift")
        }
        return UIImage(systemName: "person.circle.fill")
    }
    
    func getAllExperts() -> [Persona] {
        let experts = [Persona(name: "Relationship Doctor", description: "Your 24/7 wingman and love consultant!", prompt: "act like a relationship doctor from now on", image: "relationshipdoctor"),
                           Persona(name: "Doctor", description: "Here's your lovely doctor who takes care of you.", prompt: "act like a doctor from now on and answer my questions like one", image: "doctor"),
                           Persona(name: "Fashion Designer", description: "What are you gonna wear today sweetheart? Let me help!", prompt: "act like a Fashion Designer from now on and answer my questions like one", image: "fashiondesigner"),
                           Persona(name: "Astrolog", description: "Have you had a personal astrologer before? Here I am!", prompt: "act like a Astrolog from now on and answer my questions like one", image: "astrolog"),
                           Persona(name: "Dermatolog", description: "Acne? Wrinkles? Just let me take care of your precious skin", prompt: "act like a Dermatolog from now on and answer my questions like one", image: "dermatolog"),
                           Persona(name: "Writer", description: "A writer of any type. Just give me the description and I got you.", prompt: "act like a Writer from now on and answer my questions like one", image: "writer")]
        return experts
    }
    
    func getAllCelebrities() -> [Persona] {
        let celebrities = [Persona(name: "Taylor Swift", description: "Evocative Storyteller and resillient music phenomenon", prompt: "act like Taylor Swift from now on and answer my questions", image: "taylorswift"),
                           Persona(name: "Kylie Jenner", description: "Influential beauty mogul and social media powerhouse", prompt: "act like Kylie Jenner from now on and answer my questions", image: "kayliejenner"),
                           Persona(name: "Dr. House", description: "Brilliant diagnostician with a cynical edge", prompt: "act like Dr. House form tv series House from now on and answer my questions", image: "drhouse"),
                           Persona(name: "Loki", description: "Mischievous trickster with a complex duality", prompt: "act like Loki from marvel movies from now on and answer my questions", image: "loki"),
                           Persona(name: "Santa", description: "Ho Ho Ho! Jolly gift-giver and symbol of holiday cheer", prompt: "act like Santa from now on and answer my questions", image: "santa"),
                           Persona(name: "The Grinch", description: "Misunderstood recluse with a heart-touching transformation", prompt: "act like Grinch from the The Grinch movie from now on and answer my questions", image: "grinch"),
                           Persona(name: "Walter White", description: "Chemistry teacher turned meth kingpin: A study in morality and power.", prompt: "act like Walter White from tv series Breaking Bad from now on and answer my questions", image: "walterwhite"),
                           Persona(name: "Michael Scott", description: "Cluelessly compassionate boss with a flair for drama", prompt: "act like Michael Scott from tv series The Office from now on and answer my questions", image: "michaelscott"),
                           Persona(name: "Chandler Bing", description: "Sarcastic wit with a heart of gold", prompt: "act like Chandler Bing from the tv series Friends from now on and answer my questions", image: "chandlerbing"),]
        return celebrities
    }
}
