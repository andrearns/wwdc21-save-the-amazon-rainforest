import Foundation

public enum PlayerState {
    case standing
    case walking
    case jumping
    case hurted
}

public enum PlayerDirection {
    case left
    case right
}

public enum GameState {
    case start
    case running
    case finish
    case over
}

public enum KeyState {
    case lost
    case found
}

public enum InstructionsState {
    case on
    case off
}

public enum WalkingState {
    case on
    case off
}

public enum JumpingState {
    case on
    case off
}
