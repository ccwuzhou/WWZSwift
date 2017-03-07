//
//  WWZSiriWaveView.swift
//  wwz_swift
//
//  Created by wwz on 17/3/3.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

class WWZSiriWaveView: UIView {

    // The total number of waves
    var numberOfWaves : UInt = 5
    
    // Color to use when drawing the waves
    var waveColor : UIColor = UIColor.white
    
    // Line width used for the proeminent wave
    var primaryWaveLineWidth : CGFloat  = 3.0
    
    // Line width used for all secondary waves
    var secondaryWaveLineWidth : CGFloat  = 1.0
    
    // The amplitude that is used when the incoming amplitude is near zero.
    // Setting a value greater 0 provides a more vivid visualization.
    var idleAmplitude : CGFloat  = 0.05
    
    // The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
    var frequency : CGFloat  = 1.5
    
    // The current amplitude
    var amplitude : CGFloat  = 0.01
    
    // The lines are joined stepwise, the more dense you draw, the more CPU power is used.
    var density : CGFloat  = 5.0

    // The phase shift that will be applied with each level setting
    // Change this to modify the animation speed or direction
    var phaseShift : CGFloat  = -0.15
    

    private var phase : CGFloat = 0


    // Tells the waveform to redraw itself using the given level (normalized value)
    func update(level: CGFloat) {
        
        self.phase += self.phaseShift
        self.amplitude = fmax(level, self.idleAmplitude)
        
        self.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        for i in 0..<self.numberOfWaves {
            
            let context = UIGraphicsGetCurrentContext()
            
            context?.setLineWidth(i == 0 ? self.primaryWaveLineWidth : self.secondaryWaveLineWidth)
            
            let halfHeight = self.height * 0.5
            let mid = self.width * 0.5
            
            let maxAmplitude = halfHeight - 4.0
            
            let progress = 1 - CGFloat(i)/CGFloat(self.numberOfWaves)
            
            let normedAmplitude = (1.5 * progress - 0.5) * self.amplitude
            
            self.waveColor.withAlphaComponent((progress / 3.0 * 2.0) + (1.0 / 3.0)).set()
            
            var x : CGFloat = 0.0
            while x < self.width + self.density {
                
                let scaling : CGFloat = -pow(1 / mid * (x-mid), 2) + 1
                
                let y = scaling * maxAmplitude * normedAmplitude * CGFloat(sinf(Float(2 * CGFloat(M_PI) * (x / width) * self.frequency + self.phase))) + halfHeight
                if x == 0 {
                    context?.move(to: CGPoint(x: x, y: y))
                }else{
                
                    context?.addLine(to: CGPoint(x: x, y: y))
                }
                
                x += self.density
            }
            
            context?.strokePath()
        }
    }
}
