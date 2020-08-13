Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "EKBlurAlert"
s.summary = "EKBlurAlert Swift 5.2 framework for Blured Alert View with auto hiding."
s.requires_arc = true
s.swift_version = '5.2'

# 2
s.version = "2.0.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Emil Karimov" => "emvakar@gmail.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/emvakar"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/emvakar/EKBlurAlert.git", :tag => "#{s.version}"}

# 7
s.framework = "UIKit"
s.dependency 'SnapKit'

# 8
s.source_files = "Sources/EKBlurAlert/**/*.{swift}"

# 9
#s.resources = "EKBlurAlert/**/*.{png,jpeg,jpg,storyboard,xib}"
#s.resource_bundles = {
#    'EKBlurAlertAssets' => ['EKBlurAlert/**/*.xcassets']
#}
end
