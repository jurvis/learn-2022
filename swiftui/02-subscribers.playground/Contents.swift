import Combine
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Sink
// Assign

func sinkExampleManual() {
    let publisher = [1, 3, 5, 8, 11].publisher
    
    let subscriber = Subscribers.Sink<Int, Never>(receiveCompletion: { completion in
        print(completion)
    }, receiveValue: { value in
        print(value)
    })
    
    publisher.subscribe(subscriber)
}

func sinkExampleShorthand() {
    let publisher = [1, 3, 5, 8, 11].publisher

    publisher.sink(receiveCompletion: {completion in
        print(completion)
    }, receiveValue: { value in
        print(value)
    })
}

class Forum {
    var latestMessage: String = "" {
        didSet {
            print("Latest message is now: \(latestMessage)")
        }
    }
}

func assignExampleManual() {
    let messages = ["Hey there", "How's it going"].publisher
    let forum = Forum()
    
    // can only work with never
    let subscriber = Subscribers.Assign<Forum, String>(object: forum, keyPath: \.latestMessage)
    
    messages.subscribe(subscriber)
}

func assignExampleShorthand() {
    let messages = ["Hey there", "How's it going"].publisher
    let forum = Forum()
    
    messages.assign(to: \.latestMessage, on: forum)
}

class TickTock {
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [unowned self] _ in
                tick()
            }
            .store(in: &cancellables)
    }
    
    func tick() {
        print("Tick")
    }
}

var ex: TickTock? = TickTock()

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    print("Cleaning Up")
    ex = nil
}
