//
//  ViewController.swift
//  hibiscus-macOS
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Cocoa
import Gong

class ViewController: NSViewController {
    
    @IBOutlet var cButton: NSButton!
    @IBOutlet var dButton: NSButton!
    @IBOutlet var eButton: NSButton!
    @IBOutlet var fButton: NSButton!
    @IBOutlet var gButton: NSButton!
    @IBOutlet var aButton: NSButton!
    @IBOutlet var bButton: NSButton!
    
    var buttons: [NSButton] {
        return [cButton, dButton, eButton, fButton, gButton, aButton, bButton]
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
        for button in buttons {
            button.sendAction(on: [.leftMouseDown, .leftMouseUp])
        }
        
        MIDI.addReceiver(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeReceiver(self)
    }
    
    @IBAction func buttonClick(_ button: NSButton) {
        switch button.window?.currentEvent?.type {
        case .leftMouseDown?:
            buttonMouseDown(button)
        case .leftMouseUp?:
            buttonMouseUp(button)
        default:
            break
        }
    }
    
    func buttonMouseDown(_ button: NSButton) {
        switch button.title {
        case "C":
            sendNoteOnEvent(key: .c4)
        case "D":
            sendNoteOnEvent(key: .d4)
        case "E":
            sendNoteOnEvent(key: .e4)
        case "F":
            sendNoteOnEvent(key: .f4)
        case "G":
            sendNoteOnEvent(key: .g4)
        case "A":
            sendNoteOnEvent(key: .a4)
        case "B":
            sendNoteOnEvent(key: .b4)
        default:
            break
        }
    }
    
    func buttonMouseUp(_ button: NSButton) {
        switch button.title {
        case "C":
            sendNoteOffEvent(key: .c4)
        case "D":
            sendNoteOffEvent(key: .d4)
        case "E":
            sendNoteOffEvent(key: .e4)
        case "F":
            sendNoteOffEvent(key: .f4)
        case "G":
            sendNoteOffEvent(key: .g4)
        case "A":
            sendNoteOffEvent(key: .a4)
        case "B":
            sendNoteOffEvent(key: .b4)
        default:
            break
        }
    }

}

extension ViewController {
    
    var device: MIDIDevice? {
        return MIDIDevice(named: "minilogue")
    }
    
    func sendNoteOnEvent(key: MIDIKey) {
        let sequence: MIDISequence = [
            MIDINote(key: key + .P1, time: .now, duration: .whole),
            MIDINote(key: key + .M2, time: .now + .whole, duration: .whole),
            MIDINote(key: key + .M3, time: .now + .whole * 2, duration: .whole),
            MIDINote(key: key + .P4, time: .now + .whole * 3, duration: .whole),
            MIDINote(key: key + .P5, time: .now + .whole * 4, duration: .whole),
            MIDIControl(controller: 0, value: 0)
        ]
        
        device?.send(sequence)
        
//        for key in key.chord(.P1, .P5, .P8) {
//            let message = MIDIMessage(.noteOn(channel: 0, key: UInt8(key.number), velocity: 100))
//            device?.send(message)
//        }
    }
    
    func sendNoteOffEvent(key: MIDIKey) {
//        for key in key.chord(.P1, .P5, .P8) {
//            let message = MIDIMessage(.noteOff(channel: 0, key: UInt8(key.number), velocity: 100))
//            device?.send(message)
//        }
    }
    
}

extension ViewController: MIDIReceiver {
    
    func receive(_ notification: MIDINotification) {
        print(notification)
    }
    
    func receive(_ packet: MIDIPacket, from source: MIDIEndpoint<Source>) {
        switch packet.message {
        case .noteOn, .noteOff, .controlChange:
            print(packet, source)
        default:
            break
        }
    }
    
}
