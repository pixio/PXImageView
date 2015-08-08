Pod::Spec.new do |s|
  s.name             = "PXImageView"
  s.version          = "0.1.1"
  s.summary          = "An image view with more expressive content modes"
  s.description      = <<-DESC
                       An imageview with better content modes like Top which means fit and align to top.
                       DESC
  s.homepage         = "https://github.com/pixio/PXImageView"
  s.license          = 'MIT'
  s.author           = { "Daniel Blakemore" => "DanBlakemore@gmail.com" }
  s.source = {
    :git => "https://github.com/pixio/PXImageView.git",
    :tag => s.version.to_s
  }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PXImageView' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'UIImageView_AFNetworking-Blocks'
end
