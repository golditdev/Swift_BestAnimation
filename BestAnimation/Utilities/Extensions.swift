import UIKit
import CoreText

extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var test: UIStoryboard {
        return UIStoryboard(name: "Test", bundle: nil)
    }
}

extension UITableView {
    
    func nextResponder(index: Int){
        var currIndex = -1
        for i in index+1..<index+100{
            if let view = self.superview?.superview?.viewWithTag(i){
                view.becomeFirstResponder()
                currIndex = i
                break
            }
        }
        
        let ind = IndexPath(row: currIndex - 100, section: 0)
        if let nextCell = self.cellForRow(at: ind){
            self.scrollRectToVisible(nextCell.frame, animated: true)
        }
    }
    
    func keyboardRaised(height: CGFloat){
        self.contentInset.bottom = height
        self.scrollIndicatorInsets.bottom = height
    }
    
    func keyboardClosed(){
        self.contentInset.bottom = 0
        self.scrollIndicatorInsets.bottom = 0
        self.scrollRectToVisible(CGRect.zero, animated: true)
    }
    
    func reloadWithAnimation() {
        self.reloadData()
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.alpha = 0
        }
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: 0.1 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.alpha = 1
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func hideWithAnimation() {
        self.reloadData()
        let cells = self.visibleCells
        var delayCounter = 0
        
        var i = cells.count - 1
        
        while i >= 0 {
            let cell = cells[i]
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.alpha = 0
            }, completion: nil)
            delayCounter += 1
            i -= 1
        } 
    }
}

extension UISearchBar {
    func removeBackgroundImageView(){
        if let view:UIView = self.subviews.first {
            for curr in view.subviews {
                guard let searchBarBackgroundClass = NSClassFromString("UISearchBarBackground") else {
                    return
                }
                if curr.isKind(of:searchBarBackgroundClass){
                    if let imageView = curr as? UIImageView{
                        imageView.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
}

extension UIView {
    func setAlphaGradient(_ frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]) {
        let mask = CAGradientLayer()
        mask.startPoint = startPoint
        mask.endPoint = endPoint
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(1.0).cgColor,whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(0.0).cgColor]
        mask.locations = locations
        mask.frame = frame
        self.layer.mask = mask
    }
    
    func roundedCorners(_ corners: UIRectCorner, size: CGFloat){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: size, height: size))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func removeAllSubViews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func shakePlace(offset: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.center = CGPoint(x: self.center.x + offset + 2, y: self.center.y)
        }) { finish in
            UIView.animate(withDuration: 0.3, animations: {
                self.center = CGPoint(x: self.center.x - 2, y: self.center.y)
            })            
        }
    }
    
    func shakeVPlace(offset: CGFloat) {
        self.center = CGPoint(x: self.center.x, y: self.center.y - 2)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.center = CGPoint(x: self.center.x, y: self.center.y + offset + 2)
        }) { finish in
            UIView.animate(withDuration: 0.3, animations: {
                self.center = CGPoint(x: self.center.x, y: self.center.y - offset)
            })
        }
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    
    func expand(withDuration duration: TimeInterval, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        transform = transform.scaledBy(x: 0, y: 0)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            self.transform = .identity
        }, completion: completion)
    }
    
    func collapse(withDuration duration: TimeInterval, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        transform = transform.scaledBy(x: 1, y: 1)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            self.transform = self.transform.scaledBy(x:0, y: 0)
        }, completion: completion)
    }
    
    func animateTo(frame: CGRect, withDuration duration: TimeInterval, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        guard let _ = superview else {
            return
        }
        
        let xScale: CGFloat = self.frame.size.width == 0 ? frame.size.width : frame.size.width / self.frame.size.width
        let yScale: CGFloat = self.frame.size.height == 0 ? frame.size.height : frame.size.height / self.frame.size.height
        let x = frame.origin.x + (self.frame.width * xScale) * self.layer.anchorPoint.x
        let y = frame.origin.y + (self.frame.height * yScale) * self.layer.anchorPoint.y
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            self.layer.position = CGPoint(x: x, y: y)
            self.transform = self.transform.scaledBy(x: xScale, y: yScale)
        }, completion: completion)
    }
    
    func reset(duration: TimeInterval, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            self.transform = .identity
        }, completion: completion)
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func applyBlurEffect(amount:CGFloat) -> UIImage{
        let imageToBlur = CIImage(image: self)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        blurfilter?.setValue(amount, forKey: "inputRadius")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        return blurredImage
    }
    
    func imageWithColor (newColor: UIColor?) -> UIImage? {
        
        if let newColor = newColor {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            newColor.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }

        
        return self
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIFont {
    fileprivate static var fontFor: ( _ name: String, _ size: CGFloat) -> UIFont = { fontName, size in
        guard let font = UIFont(name: fontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    //SF Pro Display
    static var sfProDisplayHeavyItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-HeavyItalic", size)
    }
    
    static var sfProDisplayThinItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-ThinItalic", size)
    }
    
    static var sfProDisplayUltralightFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Ultralight", size)
    }
    
    static var sfProDisplayHeavyFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Heavy", size)
    }
    
    static var sfProDisplayBoldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-BoldItalic", size)
    }
    
    static var sfProDisplaySemiboldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-SemiboldItalic", size)
    }
    
    static var sfProDisplayRegularFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Regular", size)
    }
    
    static var sfProDisplayBoldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Bold", size)
    }
    
    static var sfProDisplayMediumItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-MediumItalic", size)
    }
    
    static var sfProDisplayThinFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Thin", size)
    }
    
    static var sfProDisplaySemiboldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Semibold", size)
    }
    
    static var sfProDisplayBlackItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-BlackItalic", size)
    }
    
    static var sfProDisplayLightFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Light", size)
    }
    
    static var sfProDisplayUltralightItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-UltralightItalic", size)
    }
    
    static var sfProDisplayItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Italic", size)
    }
    
    static var sfProDisplayLightItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-LightItalic", size)
    }
    
    static var sfProDisplayBlackFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Black", size)
    }
    
    static var sfProDisplayMediumFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoDisplay-Medium", size)
    }
    
    // SF Pro Text
    static var sfProTextHeavyFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Heavy", size)
    }
    
    static var sfProTextLightItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-LightItalic", size)
    }
    
    static var sfProTextHeavyItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-HeavyItalic", size)
    }
    
    static var sfProTextMediumFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Medium", size)
    }
    
    static var sfProTextItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Italic", size)
    }
    
    static var sfProTextBoldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Bold", size)
    }
    
    static var sfProTextSemiboldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-SemiboldItalic", size)
    }
    
    static var sfProTextLightFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Light", size)
    }
    
    static var sfProTextMediumItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-MediumItalic", size)
    }
    
    static var sfProTextBoldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-BoldItalic", size)
    }
    
    static var sfProTextRegularFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Regular", size)
    }
    
    static var sfProTextSemiboldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SanFranciscoText-Semibold", size)
    }
}
