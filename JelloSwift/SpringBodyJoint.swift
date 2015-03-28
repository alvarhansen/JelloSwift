//
//  SpringBodyJoint.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 06/03/15.
//  Copyright (c) 2015 Luiz Fernando Silva. All rights reserved.
//

import Foundation
import CoreGraphics

class SpringBodyJoint : BodyJoint
{
    /// The spring coefficient for this spring body joint
    var springK: CGFloat;
    /// The spring dampness for this spring body joint
    var springD: CGFloat;
    
    /// Inits a new spring body joint witht he specified parameters. Leave the distance as -1 to calculate the distance automatically from the current distance of the two provided joint links
    init(world: World, link1: JointLinkType, link2: JointLinkType, springK: CGFloat, springD: CGFloat, distance: CGFloat = -1)
    {
        self.springK = springK;
        self.springD = springD;
        
        super.init(world: world, link1: link1, link2: link2, distance: distance);
    }
    
    /**
     * Resolves this joint
     *
     * :param: dt The delta time to update the resolve on
    */
    override func resolve(dt: CGFloat)
    {
        let pos1 = _bodyLink1.position;
        let pos2 = _bodyLink2.position;
        
        let force = calculateSpringForce(pos1, _bodyLink1.velocity, pos2, _bodyLink2.velocity, restDistance, springK, springD);
        
        if(!_bodyLink1.isStatic && !_bodyLink2.isStatic)
        {
            let mass1 = _bodyLink1.mass;
            let mass2 = _bodyLink2.mass;
            let massSum = mass1 + mass2;
            
            _bodyLink1.applyForce( force * (massSum / mass1));
            _bodyLink2.applyForce(-force * (massSum / mass2));
        }
        // Static bodies:
        else if(!_bodyLink1.isStatic && _bodyLink2.isStatic)
        {
            _bodyLink1.applyForce(force);
        }
        else if(!_bodyLink2.isStatic && _bodyLink1.isStatic)
        {
            _bodyLink2.applyForce(-force);
        }
    }
}