import Foundation

// Environment is an enum so it can never be initialised
// A class/struct would require a private init() to do the same thing
internal enum Environment {
    internal static var Variables: EnvironmentalVariablesProtocol.Type {
        // The idea in here is to have some logic to decide which
        // environmental variables to return (normally preprocessor macros)
        
        return DevEnvironmentalVariables.self
    }
}
