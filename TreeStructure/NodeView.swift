//
//  Node.swift
//  TreeStructure
//
//  Created by Gerardo Garrido on 13/07/16.
//

import UIKit

class NodeView: UIView {
    static let nodeSize = CGSize(width: 50, height: 25);
    static let separatorSize = CGSize(width: 10, height: 25);
    
    
    var name: String {
        get {
            if let text = self.lbName.text {
                return text;
            }
            return "";
        }
        set {
            self.lbName.text = newValue;
        }
    }
    
    var node: Node?;
    
    
    @IBOutlet weak var lbName: UILabel!;
    @IBOutlet weak var connectorsView: UIView!
    @IBOutlet weak var childrenView: UIView!
    @IBOutlet weak var vertexView: UIView!
    
    
    
    // MARK: Lifecycle methods
    
    class func initFromXib(with node: Node) -> NodeView {
        let nodeView = Bundle.main.loadNibNamed(String(describing: NodeView.self), owner: self, options: nil)?[0] as! NodeView
        nodeView.node = node;
        nodeView.name = node.name;
        nodeView.frame.size = node.neededSize();
        
        return nodeView;
    }
    
    // MARK: Actions
    
    @IBAction func onVisxibilityTap(sender: UIButton) {
        self.childrenView.isHidden = !self.childrenView.isHidden;
        self.connectorsView.isHidden = !self.connectorsView.isHidden;
    }
    
    
    // MARK: Public
    
    func drawChildrenNodes() {
        self.clearChildrenView();
        
        guard let node = self.node else {
            return;
        }
        
        let size = node.neededSize();
        
        self.frame.size = size;
        self.childrenView.frame.size = size;
        self.connectorsView.frame.size = size;
        
        var origin = CGPoint(x: 0,
                             y: NodeView.nodeSize.height + NodeView.separatorSize.height);
        
        for child in node.children {
            let childView = NodeView.initFromXib(with: child);
            self.childrenView.addSubview(childView);
            childView.drawChildrenNodes();
            childView.frame.origin = origin;
            origin.x += childView.frame.width + NodeView.separatorSize.width;
        }
        
        self.vertexView.frame.origin.x = (size.width - NodeView.nodeSize.width) / 2;
        
        self.drawConnectors();
    }
    
    
    // MARK: Private
    
    private func clearChildrenView() {
        for view in self.childrenView.subviews {
            view.removeFromSuperview();
        }
        
        for connector in self.connectorsView.subviews {
            connector.removeFromSuperview();
        }
    }
    
    private func drawConnectors() {
        guard let node = self.node, node.numberOfChildren() > 0 else {
            return;
        }
        
        UIGraphicsBeginImageContext(self.frame.size);
        guard let context = UIGraphicsGetCurrentContext() else {
            return;
        }
        
        context.setLineWidth(1);
        context.setStrokeColor(UIColor.black.cgColor);
        let firstChildView = self.childrenView.subviews.first!;
        
        if (node.children.count == 1) {
            context.move(to: CGPoint(x: firstChildView.center.x, y: self.vertexView.center.y));
            context.addLine(to: CGPoint(x: firstChildView.center.x, y: firstChildView.frame.origin.y));
            context.strokePath();
        }
        else if (node.children.count > 1) {
            let linePosY = NodeView.nodeSize.height/2 + NodeView.separatorSize.height;
            let lastChildView = self.childrenView.subviews.last!;
            context.move(to: CGPoint(x: firstChildView.center.x, y: linePosY));
            context.addLine(to: CGPoint(x: lastChildView.center.x, y:  linePosY));
            context.strokePath();
            
            for childView in self.childrenView.subviews {
                self.drawLine(fromNode: childView, toLineAt: linePosY, in: context);
            }
            
            self.drawLine(fromNode: self.vertexView, toLineAt: linePosY, in: context);
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.connectorsView.addSubview(UIImageView(image: img));
    }
    
    private func drawLine(fromNode node: UIView, toLineAt posY: CGFloat, in context: CGContext) {
        context.move(to: CGPoint(x: node.center.x, y: node.frame.origin.y));
        context.addLine(to: CGPoint(x: node.center.x, y: posY));
        context.strokePath();
    }
}



